-- ========================================
-- TRANSACTIONS SYSTEM - LOKALER CACHE
-- ========================================
-- Vereinfachte transactions.lua ohne MySQL
-- Verwendet nur lokalen Cache für Transaktionen

-- ========================================
-- HAUPTVARIABLEN
-- ========================================

local Transactions = {}
local LocalTransactionCache = {}
local AddonStatus = {}

-- Storage-System importieren (wird nach dem Laden verfügbar sein)
local Storage = nil

-- ========================================
-- ADDON-ERKENNUNG UND -VERWALTUNG
-- ========================================

-- Addon-Status aktualisieren
function Transactions.UpdateAddonStatus()
    local addons = {
        {name = 'stocks', resource = 'zs_stocks', display_name = 'ZS Stocks - Aktienhandel'},
        {name = 'crypto', resource = 'zs_crypto', display_name = 'ZS Crypto - Kryptowährungen'},
        {name = 'loans', resource = 'zs_loans', display_name = 'ZS Loans - Kreditsystem'},
        {name = 'insurance', resource = 'zs_insurance', display_name = 'ZS Insurance - Versicherungen'}
    }
    
    for _, addon in ipairs(addons) do
        local isInstalled = GetResourceState(addon.resource) == 'started'
        local isActive = isInstalled
        
        -- Lokalen Cache aktualisieren
        AddonStatus[addon.name] = {
            installed = isInstalled,
            active = isActive,
            resource = addon.resource,
            config = addon
        }
        
        if isActive then
            -- print("^2[ZS Banking]^7 Addon erkannt: " .. addon.display_name) -- Auskommentiert
        end
    end
    
    -- Addon-Status speichern (falls Storage verfügbar)
    if Storage and Storage.SaveAddonStatus then
        Storage.SaveAddonStatus(AddonStatus)
    end
    
    return true
end

-- Alle aktiven Addons abrufen
function Transactions.GetActiveAddons()
    return AddonStatus
end

-- Prüfen ob ein Addon verfügbar ist
function Transactions.IsAddonAvailable(addonName)
    return AddonStatus[addonName] and AddonStatus[addonName].active
end

-- ========================================
-- TRANSACTIONS-MANAGEMENT
-- ========================================

-- Neue Transaktion erstellen (mit JSON-Speicherung)
function Transactions.CreateTransaction(playerId, type, amount, description, status, additionalData)
    -- Lokalen Cache aktualisieren
    if not LocalTransactionCache[playerId] then
        LocalTransactionCache[playerId] = {}
    end
    
    local transaction = {
        id = #LocalTransactionCache[playerId] + 1,
        playerId = playerId,
        type = type,
        amount = amount,
        description = description,
        status = status or 'completed',
        date = os.date('%Y-%m-%d %H:%M:%S'),
        timestamp = os.time(),
        fee = additionalData and additionalData.fee or 0,
        targetPlayer = additionalData and additionalData.targetPlayer or nil,
        bankLocation = additionalData and additionalData.bankLocation or nil
    }
    
    table.insert(LocalTransactionCache[playerId], transaction)
    
    -- In JSON-Datei speichern (falls Storage verfügbar)
    if Storage and Storage.SaveAllTransactions then
        Storage.SaveAllTransactions(LocalTransactionCache)
    end
    
    -- print("^2[ZS Banking]^7 Transaktion erstellt: " .. type .. " - " .. amount) -- Auskommentiert
    return transaction
end

-- Transaktionen eines Spielers abrufen (nur lokal)
function Transactions.GetPlayerTransactions(playerId, limit, offset)
    local localTransactions = LocalTransactionCache[playerId] or {}
    
    -- Nach Datum sortieren
    if #localTransactions > 0 then
        table.sort(localTransactions, function(a, b) 
            return (a.timestamp or 0) > (b.timestamp or 0) 
        end)
        
        if limit and #localTransactions > limit then
            local limited = {}
            for i = 1, limit do
                table.insert(limited, localTransactions[i])
            end
            localTransactions = limited
        end
    end
    
    return localTransactions
end

-- Transaktionen nach Typ abrufen
function Transactions.GetTransactionsByType(playerId, type, limit)
    local allTransactions = Transactions.GetPlayerTransactions(playerId, limit)
    local filteredTransactions = {}
    
    for _, transaction in ipairs(allTransactions) do
        if transaction.type == type then
            table.insert(filteredTransactions, transaction)
        end
    end
    
    return filteredTransactions
end

-- Tägliche Transaktionen abrufen
function Transactions.GetDailyTransactions(playerId, date)
    local allTransactions = Transactions.GetPlayerTransactions(playerId)
    local targetDate = date or os.date('%Y-%m-%d')
    local dailyTransactions = {}
    
    for _, transaction in ipairs(allTransactions) do
        local transactionDate = os.date('%Y-%m-%d', transaction.timestamp)
        if transactionDate == targetDate then
            table.insert(dailyTransactions, transaction)
        end
    end
    
    return dailyTransactions
end

-- ========================================
-- STATISTIKEN UND BERICHTE
-- ========================================

-- Spieler-Statistiken abrufen
function Transactions.GetPlayerStats(playerId)
    local transactions = Transactions.GetPlayerTransactions(playerId)
    local stats = {
        totalTransactions = #transactions,
        totalDeposits = 0,
        totalWithdrawals = 0,
        totalTransfers = 0,
        averageAmount = 0,
        lastTransaction = nil
    }
    
    if #transactions > 0 then
        stats.lastTransaction = transactions[1]
        
        local totalAmount = 0
        for _, transaction in ipairs(transactions) do
            totalAmount = totalAmount + transaction.amount
            
            if transaction.type == 'deposit' then
                stats.totalDeposits = stats.totalDeposits + 1
            elseif transaction.type == 'withdraw' then
                stats.totalWithdrawals = stats.totalWithdrawals + 1
            elseif transaction.type:find('transfer') then
                stats.totalTransfers = stats.totalTransfers + 1
            end
        end
        
        stats.averageAmount = totalAmount / #transactions
    end
    
    return stats
end

-- Server-Statistiken abrufen
function Transactions.GetServerStats()
    local stats = {
        totalTransactions = 0,
        totalBankBalance = 0,
        activeAccounts = 0
    }
    
    for playerId, transactions in pairs(LocalTransactionCache) do
        stats.totalTransactions = stats.totalTransactions + #transactions
        
        -- Aktive Konten (letzte Transaktion in den letzten 30 Tagen)
        local thirtyDaysAgo = os.time() - (30 * 24 * 60 * 60)
        for _, transaction in ipairs(transactions) do
            if transaction.timestamp > thirtyDaysAgo then
                stats.activeAccounts = stats.activeAccounts + 1
                break
            end
        end
    end
    
    return stats
end

-- ========================================
-- UTILITY-FUNKTIONEN
-- ========================================

-- Transaktion löschen
function Transactions.DeleteTransaction(playerId, transactionId)
    local transactions = LocalTransactionCache[playerId]
    if not transactions then return false end
    
    for i, transaction in ipairs(transactions) do
        if transaction.id == transactionId then
                    table.remove(transactions, i)
        -- print("^2[ZS Banking]^7 Transaktion gelöscht: " .. transactionId) -- Auskommentiert
        return true
        end
    end
    
    return false
end

-- Alle Transaktionen eines Spielers löschen
function Transactions.ClearAllTransactions(playerId)
    if playerId then
        LocalTransactionCache[playerId] = {}
        -- print("^2[ZS Banking]^7 Alle Transaktionen für Spieler gelöscht: " .. playerId) -- Auskommentiert
    else
        LocalTransactionCache = {}
        -- print("^2[ZS Banking]^7 Alle Transaktionen gelöscht") -- Auskommentiert
    end
    return true
end

-- ========================================
-- EXPORTS
-- ========================================

-- Server Exports
exports('CreateTransaction', Transactions.CreateTransaction)
exports('GetPlayerTransactions', Transactions.GetPlayerTransactions)
exports('GetTransactionsByType', Transactions.GetTransactionsByType)
exports('GetDailyTransactions', Transactions.GetDailyTransactions)
exports('GetPlayerStats', Transactions.GetPlayerStats)
exports('DeleteTransaction', Transactions.DeleteTransaction)
exports('ClearAllTransactions', Transactions.ClearAllTransactions)

-- Addon-Management Exports
exports('UpdateAddonStatus', Transactions.UpdateAddonStatus)
exports('GetActiveAddons', Transactions.GetActiveAddons)
exports('IsAddonAvailable', Transactions.IsAddonAvailable)

-- Utility Exports
exports('GetServerStats', Transactions.GetServerStats)

-- Spielerdaten Exports (werden direkt aus storage.lua geladen)
exports('SavePlayerData', function(playerData)
    if Storage and Storage.SavePlayerData then
        return Storage.SavePlayerData(playerData)
    end
    return false
end)

exports('LoadPlayerData', function(playerId)
    if Storage and Storage.LoadPlayerData then
        return Storage.LoadPlayerData(playerId)
    end
    return nil
end)

exports('LoadAllPlayerData', function()
    if Storage and Storage.LoadAllPlayerData then
        return Storage.LoadAllPlayerData()
    end
    return {}
end)

-- ========================================
-- INITIALISIERUNG
-- ========================================

-- Beim Resource-Start
CreateThread(function()
    Wait(1000) -- Kurz warten bis alle Ressourcen geladen sind
    
    -- print("^2[ZS Banking]^7 Initialisiere Transaktions-System...") -- Auskommentiert
    
    -- Storage-System direkt laden
    local resourceName = GetCurrentResourceName()
    
    -- Gespeicherte Transaktionen laden
    LocalTransactionCache = {}
    if LoadResourceFile(resourceName, 'transactions.json') then
        local content = LoadResourceFile(resourceName, 'transactions.json')
        if content and content ~= '' then
            local success, data = pcall(json.decode, content)
            if success and data then
                LocalTransactionCache = data
            end
        end
    end
    
    -- Addon-Status laden
    AddonStatus = {}
    if LoadResourceFile(resourceName, 'addons.json') then
        local content = LoadResourceFile(resourceName, 'addons.json')
        if content and content ~= '' then
            local success, data = pcall(json.decode, content)
            if success and data then
                AddonStatus = data
            end
        end
    end
    
    -- Addon-Status aktualisieren
    Transactions.UpdateAddonStatus()
    
    -- print("^2[ZS Banking]^7 Transaktions-System erfolgreich geladen") -- Auskommentiert
    -- print("^2[ZS Banking]^7 Verfügbare Funktionen:") -- Auskommentiert
    -- print("^3[ZS Banking]^7 - JSON-Speicherung (Persistent)") -- Auskommentiert
    -- print("^2[ZS Banking]^7 - Lokaler Cache (Transaktionen)") -- Auskommentiert
    -- print("^2[ZS Banking]^7 - Addon-Erkennung") -- Auskommentiert
    -- print("^2[ZS Banking]^7 - Statistiken und Berichte") -- Auskommentiert
end)

-- Regelmäßige Addon-Status-Updates
CreateThread(function()
    while true do
        Wait(300000) -- Alle 5 Minuten
        
        -- Addon-Status aktualisieren
        Transactions.UpdateAddonStatus()
    end
end)

return Transactions

