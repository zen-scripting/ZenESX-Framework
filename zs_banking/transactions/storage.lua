-- ========================================
-- STORAGE SYSTEM - JSON DATEIEN
-- ========================================
-- Speichert Transaktionen in JSON-Dateien
-- Bleibt nach Server-Neustart erhalten

local Storage = {}
local StoragePath = GetResourcePath(GetCurrentResourceName()) .. '/data/'
local TransactionsFile = StoragePath .. 'transactions.json'
local AddonsFile = StoragePath .. 'addons.json'
local PlayerDataFile = StoragePath .. 'playerdata.json'

-- ========================================
-- DATEI-MANAGEMENT
-- ========================================

-- Verzeichnis erstellen falls nicht vorhanden
function Storage.EnsureDirectory()
    if not file_exists(StoragePath) then
        os.execute('mkdir "' .. StoragePath .. '"')
        -- print("^2[ZS Banking]^7 Datenverzeichnis erstellt: " .. StoragePath) -- Auskommentiert
    end
end

-- Prüfen ob Datei existiert
function file_exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end

-- ========================================
-- TRANSACTIONS SPEICHERN
-- ========================================

-- Alle Transaktionen speichern
function Storage.SaveAllTransactions(transactionCache)
    Storage.EnsureDirectory()
    
    local file = io.open(TransactionsFile, "w")
    if not file then
        -- print("^1[ZS Banking]^7 Fehler: Kann Transaktionsdatei nicht öffnen") -- Auskommentiert
        return false
    end
    
    -- Daten für JSON vorbereiten
    local dataToSave = {}
    for playerId, transactions in pairs(transactionCache) do
        dataToSave[tostring(playerId)] = transactions
    end
    
    local jsonData = json.encode(dataToSave)
    file:write(jsonData)
    file:close()
    
    -- print("^2[ZS Banking]^7 Alle Transaktionen gespeichert") -- Auskommentiert
    return true
end

-- ========================================
-- SPIELERDATEN SPEICHERN
-- ========================================

-- Spielerdaten für einen Spieler speichern
function Storage.SavePlayerData(playerId, playerData)
    Storage.EnsureDirectory()
    
    -- Bestehende Daten laden
    local allPlayerData = Storage.LoadAllPlayerData()
    
    -- Neue/aktualisierte Daten hinzufügen
    allPlayerData[tostring(playerId)] = {
        name = playerData.name,
        cash = playerData.cash,
        bank = playerData.bank,
        lastUpdate = os.time()
    }
    
    -- Alle Daten speichern
    local file = io.open(PlayerDataFile, "w")
    if not file then
        -- print("^1[ZS Banking]^7 Fehler: Kann Spielerdaten-Datei nicht öffnen") -- Auskommentiert
        return false
    end
    
    local jsonData = json.encode(allPlayerData)
    file:write(jsonData)
    file:close()
    
    -- print("^2[ZS Banking]^7 Spielerdaten gespeichert für: " .. playerId) -- Auskommentiert
    return true
end

-- Alle Spielerdaten laden
function Storage.LoadAllPlayerData()
    if not file_exists(PlayerDataFile) then
        -- print("^3[ZS Banking]^7 Keine Spielerdaten-Datei gefunden - verwende leeren Cache") -- Auskommentiert
        return {}
    end
    
    local file = io.open(PlayerDataFile, "r")
    if not file then
        -- print("^1[ZS Banking]^7 Fehler: Kann Spielerdaten-Datei nicht öffnen") -- Auskommentiert
        return {}
    end
    
    local content = file:read("*all")
    file:close()
    
    if content == "" then
        return {}
    end
    
    local success, data = pcall(json.decode, content)
    if not success then
        print("^1[ZS Banking]^7 Fehler: Kann Spielerdaten-Datei nicht lesen")
        return {}
    end
    
    -- Player IDs zurück zu Zahlen konvertieren
    local convertedData = {}
    for playerIdStr, playerData in pairs(data) do
        local playerId = tonumber(playerIdStr)
        if playerId then
            convertedData[playerId] = playerData
        end
    end
    
    -- print("^2[ZS Banking]^7 Spielerdaten geladen: " .. #convertedData .. " Spieler") -- Auskommentiert
    return convertedData
end

-- Spielerdaten für einen Spieler laden
function Storage.LoadPlayerData(playerId)
    local allPlayerData = Storage.LoadAllPlayerData()
    return allPlayerData[playerId] or nil
end

-- Alle Transaktionen laden
function Storage.LoadAllTransactions()
    if not file_exists(TransactionsFile) then
        -- print("^3[ZS Banking]^7 Keine Transaktionsdatei gefunden - verwende leeren Cache") -- Auskommentiert
        return {}
    end
    
    local file = io.open(TransactionsFile, "r")
    if not file then
        -- print("^1[ZS Banking]^7 Fehler: Kann Transaktionsdatei nicht öffnen") -- Auskommentiert
        return {}
    end
    
    local content = file:read("*all")
    file:close()
    
    if content == "" then
        return {}
    end
    
    local success, data = pcall(json.decode, content)
    if not success then
        print("^1[ZS Banking]^7 Fehler: Kann Transaktionsdatei nicht lesen")
        return {}
    end
    
    -- Player IDs zurück zu Zahlen konvertieren
    local convertedData = {}
    for playerIdStr, transactions in pairs(data) do
        local playerId = tonumber(playerIdStr)
        if playerId then
            convertedData[playerId] = transactions
        end
    end
    
    -- print("^2[ZS Banking]^7 Transaktionen geladen: " .. #convertedData .. " Spieler") -- Auskommentiert
    return convertedData
end

-- ========================================
-- ADDON STATUS SPEICHERN
-- ========================================

-- Addon-Status speichern
function Storage.SaveAddonStatus(addonStatus)
    Storage.EnsureDirectory()
    
    local file = io.open(AddonsFile, "w")
    if not file then
        -- print("^1[ZS Banking]^7 Fehler: Kann Addon-Datei nicht öffnen") -- Auskommentiert
        return false
    end
    
    local jsonData = json.encode(addonStatus)
    file:write(jsonData)
    file:close()
    
    -- print("^2[ZS Banking]^7 Addon-Status gespeichert") -- Auskommentiert
    return true
end

-- Addon-Status laden
function Storage.LoadAddonStatus()
    if not file_exists(AddonsFile) then
        -- print("^3[ZS Banking]^7 Keine Addon-Datei gefunden - verwende leeren Cache") -- Auskommentiert
        return {}
    end
    
    local file = io.open(AddonsFile, "r")
    if not file then
        -- print("^3[ZS Banking]^7 Warnung: Kann Addon-Datei nicht öffnen - verwende leeren Cache") -- Auskommentiert
        return {}
    end
    
    local content = file:read("*all")
    file:close()
    
    if content == "" then
        return {}
    end
    
    local success, data = pcall(json.decode, content)
    if not success then
        -- print("^3[ZS Banking]^7 Warnung: Kann Addon-Datei nicht lesen - verwende leeren Cache") -- Auskommentiert
        return {}
    end
    
    if data and type(data) == "table" then
        -- print("^2[ZS Banking]^7 Addon-Status geladen") -- Auskommentiert
        return data
    else
        -- print("^3[ZS Banking]^7 Warnung: Ungültige Addon-Daten - verwende leeren Cache") -- Auskommentiert
        return {}
    end
end

-- ========================================
-- BACKUP UND WARTUNG
-- ========================================

-- Backup erstellen
function Storage.CreateBackup()
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local backupPath = StoragePath .. 'backup/'
    
    -- Backup-Verzeichnis erstellen
    if not file_exists(backupPath) then
        os.execute('mkdir "' .. backupPath .. '"')
    end
    
    -- Dateien kopieren
    if file_exists(TransactionsFile) then
        local backupFile = backupPath .. 'transactions_' .. timestamp .. '.json'
        os.execute('copy "' .. TransactionsFile .. '" "' .. backupFile .. '"')
        -- print("^2[ZS Banking]^7 Backup erstellt: " .. backupFile) -- Auskommentiert
    end
    
    if file_exists(AddonsFile) then
        local backupFile = backupPath .. 'addons_' .. timestamp .. '.json'
        os.execute('copy "' .. AddonsFile .. '" "' .. backupFile .. '"')
        -- print("^2[ZS Banking]^7 Backup erstellt: " .. backupFile) -- Auskommentiert
    end
end

-- Alte Backups löschen (älter als 7 Tage)
function Storage.CleanupOldBackups()
    local backupPath = StoragePath .. 'backup/'
    if not file_exists(backupPath) then return end
    
    local sevenDaysAgo = os.time() - (7 * 24 * 60 * 60)
    
    -- Hier könnte man alte Backup-Dateien löschen
    -- Für FiveM ist das aber nicht so einfach, daher nur Info
    -- print("^3[ZS Banking]^7 Backup-Bereinigung: Manuell überprüfen empfohlen") -- Auskommentiert
end

-- ========================================
-- EXPORTS
-- ========================================

exports('SaveAllTransactions', Storage.SaveAllTransactions)
exports('LoadAllTransactions', Storage.LoadAllTransactions)
exports('SaveAddonStatus', Storage.SaveAddonStatus)
exports('LoadAddonStatus', Storage.LoadAddonStatus)
exports('CreateBackup', Storage.CreateBackup)

return Storage
