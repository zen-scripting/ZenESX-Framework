-- ========================================
-- ZS BANKING SERVER
-- ========================================
-- Server-seitige Logik für das Banking-System

ESX = nil

-- Einfache Transaktionsverwaltung
local playerTransactions = {}

-- Transaktion für einen Spieler hinzufügen
local function AddTransaction(playerId, transaction)
    print("^2[ZS Banking]^7 === AddTransaction aufgerufen ===")
    print("^2[ZS Banking]^7 PlayerID:", playerId)
    print("^2[ZS Banking]^7 Transaction Type:", transaction.type)
    print("^2[ZS Banking]^7 Transaction Amount:", transaction.amount)
    print("^2[ZS Banking]^7 Transaction Description:", transaction.description)
    
    if not playerTransactions[playerId] then
        playerTransactions[playerId] = {}
        print("^2[ZS Banking]^7 Neue Transaktionsliste für Spieler erstellt")
    end
    
    -- Neue Transaktion hinzufügen
    local newTransaction = {
        type = transaction.type,
        amount = transaction.amount,
        date = os.date('%Y-%m-%d %H:%M:%S'),
        description = transaction.description or 'Banking Transaction'
    }
    
    print("^2[ZS Banking]^7 Neue Transaktion erstellt:")
    print("^2[ZS Banking]^7 - Type:", newTransaction.type)
    print("^2[ZS Banking]^7 - Amount:", newTransaction.amount)
    print("^2[ZS Banking]^7 - Date:", newTransaction.date)
    print("^2[ZS Banking]^7 - Description:", newTransaction.description)
    
    table.insert(playerTransactions[playerId], newTransaction)
    print("^2[ZS Banking]^7 Transaktion zur Liste hinzugefügt")
    
    -- Nur die letzten 50 Transaktionen behalten
    if #playerTransactions[playerId] > 50 then
        table.remove(playerTransactions[playerId], 1)
        print("^2[ZS Banking]^7 Älteste Transaktion entfernt (Limit: 50)")
    end
    
    print("^2[ZS Banking]^7 Aktuelle Transaktionen für " .. playerId .. ": " .. #playerTransactions[playerId])
    
    if Config.Debug and Config.Debug.enabled and Config.Debug.logging and Config.Debug.logging.transactions then
        print("^2[ZS Banking]^7 Transaktion hinzugefügt für " .. playerId .. ": " .. transaction.type .. " $" .. transaction.amount)
        print("^2[ZS Banking]^7 Aktuelle Transaktionen für " .. playerId .. ": " .. #playerTransactions[playerId])
    end
    
    return newTransaction
end

-- Transaktionen für einen Spieler abrufen
local function GetPlayerTransactions(playerId)
    print("^2[ZS Banking]^7 === GetPlayerTransactions aufgerufen ===")
    print("^2[ZS Banking]^7 PlayerID:", playerId)
    
    local transactions = playerTransactions[playerId] or {}
    print("^2[ZS Banking]^7 Transaktionen gefunden:", #transactions)
    
    if #transactions > 0 then
        print("^2[ZS Banking]^7 Transaktionsdetails:")
        for i, trans in ipairs(transactions) do
            print("^2[ZS Banking]^7 Transaktion " .. i .. ": " .. trans.type .. " $" .. trans.amount .. " - " .. trans.date)
        end
    else
        print("^2[ZS Banking]^7 Keine Transaktionen für diesen Spieler")
    end
    
    if Config.Debug and Config.Debug.enabled and Config.Debug.logging and Config.Debug.logging.transactions then
        print("^2[ZS Banking]^7 Transaktionen abgerufen für " .. playerId .. ": " .. #transactions)
        for i, trans in ipairs(transactions) do
            print("^2[ZS Banking]^7 Transaktion " .. i .. ": " .. trans.type .. " $" .. trans.amount .. " - " .. trans.date)
        end
    end
    
    return transactions
end

-- ESX Initialization
TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
    print("^2[ZS Banking]^7 ESX Framework geladen - Version: " .. (ESX.GetConfig().OxVersion and "OX" or "Legacy"))
end)

-- ========================================
-- TRANSLATION SYSTEM
-- ========================================
local ServerLocales = {
    ['de'] = {
        ['error_invalid_amount'] = 'Ungültiger Betrag!',
        ['error_not_enough_cash'] = 'Du hast nicht genug Bargeld!',
        ['error_not_enough_bank'] = 'Du hast nicht genug Geld auf dem Konto!',
        ['error_player_not_found'] = 'Spieler nicht gefunden!',
        ['error_transfers_disabled'] = 'Überweisungen sind deaktiviert!',
        ['success_deposit_free'] = 'Einzahlung erfolgreich!',
        ['crypto_system_disabled'] = 'Crypto-System ist deaktiviert',
        ['not_enough_cash_for_crypto'] = 'Nicht genug Bargeld für den Kauf!',
        ['not_enough_crypto_to_sell'] = 'Nicht genug Crypto zum Verkaufen!',
        ['crypto_buy_success'] = 'Crypto erfolgreich gekauft!',
        ['crypto_sell_success'] = 'Crypto erfolgreich verkauft!',
        ['success_withdraw_free'] = 'Abhebung erfolgreich!',
        ['success_transfer_fee'] = 'Überweisung erfolgreich! Gebühr: $',
        ['success_transfer_received'] = 'Du hast $ erhalten!',
        ['deposit_type'] = 'Einzahlung',
        ['withdraw_type'] = 'Abhebung',
        ['transfer_sent_type'] = 'Überweisung gesendet',
        ['transfer_received_type'] = 'Überweisung erhalten',
        ['success_transfer'] = 'Überweisung erfolgreich!',
        ['success_transfer_received'] = 'Überweisung erhalten!'
    },
    ['en'] = {
        ['error_invalid_amount'] = 'Invalid amount!',
        ['error_not_enough_cash'] = 'You don\'t have enough cash!',
        ['error_not_enough_bank'] = 'You don\'t have enough money in your account!',
        ['error_player_not_found'] = 'Player not found!',
        ['error_transfers_disabled'] = 'Transfers are disabled!',
        ['success_deposit_free'] = 'Deposit successful!',
        ['success_withdraw_free'] = 'Withdrawal successful!',
        ['success_transfer_fee'] = 'Transfer successful! Fee: $',
        ['success_transfer_received'] = 'You received $!',
        ['deposit_type'] = 'Deposit',
        ['withdraw_type'] = 'Withdrawal',
        ['transfer_sent_type'] = 'Transfer Sent',
        ['transfer_received_type'] = 'Transfer Received'
    }
}

-- Übersetzungsfunktion
local function GetTranslation(key, language)
    local lang = language or 'de'
    if ServerLocales[lang] and ServerLocales[lang][key] then
        return ServerLocales[lang][key]
    end
    return key
end

-- ========================================
-- PLAYER DATA CALLBACK
-- ========================================

-- Player Data Callback
ESX.RegisterServerCallback('bank:getPlayerData', function(source, cb)
    print("^2[ZS Banking]^7 === getPlayerData Callback aufgerufen ===")
    print("^2[ZS Banking]^7 Source:", source)
    
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        print("^1[ZS Banking ERROR]^7 Spieler nicht gefunden für Source:", source)
        cb(nil)
        return
    end
    
    local playerId = xPlayer.identifier
    print("^2[ZS Banking]^7 Spieler gefunden:", xPlayer.getName())
    print("^2[ZS Banking]^7 PlayerID:", playerId)
    
    -- Transaktionen aus lokaler Verwaltung laden
    local playerTransactions = GetPlayerTransactions(playerId)
    print("^2[ZS Banking]^7 Transaktionen geladen:", #playerTransactions)
    
    -- Spielerdaten erstellen
    local playerData = {
        cash = xPlayer.getMoney(),
        bank = xPlayer.getAccount('bank').money,
        name = xPlayer.getName(),
        transactions = playerTransactions
    }
    
    print("^2[ZS Banking]^7 PlayerData erstellt:")
    print("^2[ZS Banking]^7 - Cash:", playerData.cash)
    print("^2[ZS Banking]^7 - Bank:", playerData.bank)
    print("^2[ZS Banking]^7 - Name:", playerData.name)
    print("^2[ZS Banking]^7 - Transactions Count:", #playerData.transactions)
    
    -- Debug: Alle Spielerdaten anzeigen
    print("^2[ZS Banking Server]^7 === SPIELERDATEN GELADEN ===")
    print("^2[ZS Banking Server]^7 Spieler ID:", source)
    print("^2[ZS Banking Server]^7 Spieler Name:", xPlayer.getName())
    print("^2[ZS Banking Server]^7 Spieler Cash:", xPlayer.getMoney())
    print("^2[ZS Banking Server]^7 Spieler Bank:", xPlayer.getAccount('bank').money)
    print("^2[ZS Banking Server]^7 Transaktionen:", #playerTransactions)
    print("^2[ZS Banking Server]^7 ================================")
    
    if Config.Debug and Config.Debug.enabled and Config.Debug.logging and Config.Debug.logging.playerData then
        print("^2[ZS Banking]^7 Spielerdaten geladen für " .. xPlayer.getName() .. " - Transaktionen: " .. #playerTransactions)
    end
    
    -- Sofort die Spielerdaten an den Client senden
    print("^2[ZS Banking]^7 Sende updatePlayerData an Client:", source)
    TriggerClientEvent('bank:updatePlayerData', source, playerData)
    print("^2[ZS Banking]^7 updatePlayerData Event gesendet")
    
    cb(playerData)
    print("^2[ZS Banking]^7 Callback ausgeführt")
end)

-- ========================================
-- SERVER EVENTS
-- ========================================

-- Einzahlung
RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    -- Validierung
    if not amount or amount <= 0 then
        TriggerClientEvent('bank:showNotification', source, GetTranslation('error_invalid_amount', Config.Language), 'error')
        return
    end
    
    local cash = xPlayer.getMoney()
    if cash < amount then
        TriggerClientEvent('bank:showNotification', source, GetTranslation('error_not_enough_cash', Config.Language), 'error')
        return
    end
    
    -- Einzahlung durchführen
    xPlayer.removeMoney(amount)
    xPlayer.addAccountMoney('bank', amount)
    
    -- Transaktion zur lokalen Verwaltung hinzufügen
    local transaction = AddTransaction(xPlayer.identifier, {
        type = 'deposit',
        amount = amount,
        description = 'Einzahlung'
    })
    
    print("^2[ZS Banking]^7 === EINZAHLUNG ABGESCHLOSSEN ===")
    print("^2[ZS Banking]^7 Spieler:", xPlayer.getName())
    print("^2[ZS Banking]^7 Betrag:", amount)
    print("^2[ZS Banking]^7 Transaktion hinzugefügt:", transaction)
    
    -- Neue Transaktionen laden
    local playerTransactions = GetPlayerTransactions(xPlayer.identifier)
    print("^2[ZS Banking]^7 Alle Transaktionen für Spieler:", #playerTransactions)
    
    -- Spielerdaten aktualisieren (nur ein Event senden)
    local playerData = {
        cash = xPlayer.getMoney(),
        bank = xPlayer.getAccount('bank').money,
        name = xPlayer.getName(),
        transactions = playerTransactions
    }
    
    print("^2[ZS Banking]^7 Sende updatePlayerData an Client:", source)
    print("^2[ZS Banking]^7 PlayerData Details:")
    print("^2[ZS Banking]^7 - Cash:", playerData.cash)
    print("^2[ZS Banking]^7 - Bank:", playerData.bank)
    print("^2[ZS Banking]^7 - Name:", playerData.name)
    print("^2[ZS Banking]^7 - Transactions Count:", #playerData.transactions)
    
    TriggerClientEvent('bank:updatePlayerData', source, playerData)
    print("^2[ZS Banking]^7 updatePlayerData Event gesendet")
end)

-- Abhebung
RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    -- Validierung
    if not amount or amount <= 0 then
        TriggerClientEvent('bank:showNotification', source, GetTranslation('error_invalid_amount', Config.Language), 'error')
        return
    end
    
    local bank = xPlayer.getAccount('bank').money
    if bank < amount then
        TriggerClientEvent('bank:showNotification', source, GetTranslation('error_not_enough_bank', Config.Language), 'error')
        return
    end
    
    -- Abhebung durchführen
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addMoney(amount)
    
    -- Transaktion zur lokalen Verwaltung hinzufügen
    local transaction = AddTransaction(xPlayer.identifier, {
        type = 'withdraw',
        amount = amount,
        description = 'Abhebung'
    })
    
    print("^2[ZS Banking]^7 === ABHEBUNG ABGESCHLOSSEN ===")
    print("^2[ZS Banking]^7 Spieler:", xPlayer.getName())
    print("^2[ZS Banking]^7 Betrag:", amount)
    print("^2[ZS Banking]^7 Transaktion hinzugefügt:", transaction)
    
    -- Neue Transaktionen laden
    local playerTransactions = GetPlayerTransactions(xPlayer.identifier)
    print("^2[ZS Banking]^7 Alle Transaktionen für Spieler:", #playerTransactions)
    
    -- Spielerdaten aktualisieren (nur ein Event senden)
    local playerData = {
        cash = xPlayer.getMoney(),
        bank = xPlayer.getAccount('bank').money,
        name = xPlayer.getName(),
        transactions = playerTransactions
    }
    
    print("^2[ZS Banking]^7 Sende updatePlayerData an Client:", source)
    print("^2[ZS Banking]^7 PlayerData Details:")
    print("^2[ZS Banking]^7 - Cash:", playerData.cash)
    print("^2[ZS Banking]^7 - Bank:", playerData.bank)
    print("^2[ZS Banking]^7 - Name:", playerData.name)
    print("^2[ZS Banking]^7 - Transactions Count:", #playerData.transactions)
    
    TriggerClientEvent('bank:updatePlayerData', source, playerData)
    print("^2[ZS Banking]^7 updatePlayerData Event gesendet")
end)

-- Einfache Überweisung - Funktioniert garantiert!
RegisterServerEvent('bank:simpleTransfer')
AddEventHandler('bank:simpleTransfer', function(targetId, amount)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local tPlayer = ESX.GetPlayerFromId(targetId)
    local money = tonumber(amount)

    print("^2[ZS Banking]^7 === EINFACHE ÜBERWEISUNG START ===")
    print("^2[ZS Banking]^7 Von: " .. src .. " (Name: " .. xPlayer.getName() .. ")")
    print("^2[ZS Banking]^7 An: " .. targetId)
    print("^2[ZS Banking]^7 Betrag: $" .. money)

    -- Grundlegende Validierung
    if not xPlayer then
        print("^1[ZS Banking ERROR]^7 Sender nicht gefunden!")
        TriggerClientEvent('bank:showNotification', src, '❌ Fehler: Sender nicht gefunden!', 'error')
        return
    end

    if not tPlayer then
        print("^1[ZS Banking ERROR]^7 Zielspieler nicht gefunden!")
        TriggerClientEvent('bank:showNotification', src, '❌ Fehler: Zielspieler nicht gefunden!', 'error')
        return
    end

    if not money or money <= 0 then
        print("^1[ZS Banking ERROR]^7 Ungültiger Betrag!")
        TriggerClientEvent('bank:showNotification', src, '❌ Fehler: Ungültiger Betrag!', 'error')
        return
    end

    -- Prüfen ob Spieler genug Geld hat
    if xPlayer.getAccount('bank').money < money then
        print("^1[ZS Banking ERROR]^7 Nicht genug Geld auf dem Konto!")
        TriggerClientEvent('bank:showNotification', src, '❌ Du hast nicht genug Geld auf dem Konto!', 'error')
        return
    end

    -- Prüfen ob Spieler nicht an sich selbst überweist
    if src == targetId then
        print("^1[ZS Banking ERROR]^7 Du kannst nicht an dich selbst überweisen!")
        TriggerClientEvent('bank:showNotification', src, '❌ Du kannst nicht an dich selbst überweisen!', 'error')
        return
    end

    -- Überweisung durchführen
    print("^2[ZS Banking]^7 Führe Überweisung durch...")
    
    -- Geld vom Sender abziehen
    xPlayer.removeAccountMoney('bank', money)
    
    -- Geld dem Empfänger geben
    tPlayer.addAccountMoney('bank', money)
    
    print("^2[ZS Banking SUCCESS]^7 Überweisung erfolgreich!")
    print("^2[ZS Banking]^7 Sender Bank: " .. xPlayer.getAccount('bank').money)
    print("^2[ZS Banking]^7 Empfänger Bank: " .. tPlayer.getAccount('bank').money)
    
    -- Transaktionen hinzufügen
    AddTransaction(xPlayer.identifier, {
        type = 'transfer_sent',
        amount = money,
        description = 'Überweisung an ' .. tPlayer.getName(),
        date = os.date('%d.%m.%Y %H:%M'),
        target = tPlayer.getName()
    })
    
    AddTransaction(tPlayer.identifier, {
        type = 'transfer_received',
        amount = money,
        description = 'Überweisung von ' .. xPlayer.getName(),
        date = os.date('%d.%m.%Y %H:%M'),
        sender = xPlayer.getName()
    })
    
    -- Erfolgsmeldungen
    TriggerClientEvent('bank:showNotification', src, '🔄 Überweisung erfolgreich! $' .. money .. ' an ' .. tPlayer.getName(), 'success')
    TriggerClientEvent('bank:showNotification', targetId, '✅ Überweisung erhalten! $' .. money .. ' von ' .. xPlayer.getName(), 'success')
    
    -- Events senden
    TriggerClientEvent('bank:transferCompleted', src, true, money, tPlayer.getName())
    TriggerClientEvent('bank:transferCompleted', targetId, false, money, xPlayer.getName())
    
    -- UI aktualisieren
    local sourceTransactions = GetPlayerTransactions(xPlayer.identifier)
    local targetTransactions = GetPlayerTransactions(tPlayer.identifier)
    
    TriggerClientEvent('bank:updatePlayerData', src, {
        cash = xPlayer.getMoney(),
        bank = xPlayer.getAccount('bank').money,
        name = xPlayer.getName(),
        transactions = sourceTransactions
    })
    
    TriggerClientEvent('bank:updatePlayerData', targetId, {
        cash = tPlayer.getMoney(),
        bank = tPlayer.getAccount('bank').money,
        name = tPlayer.getName(),
        transactions = targetTransactions
    })
    
    print("^2[ZS Banking]^7 === EINFACHE ÜBERWEISUNG ERFOLGREICH ABGESCHLOSSEN ===")
end)

-- ========================================
-- TEST FUNCTIONS
-- ========================================

-- Test-Überweisung für Debugging
RegisterCommand('testtransfer', function(source, args, rawCommand)
    if source == 0 then -- Nur von Konsole
        local sourceId = tonumber(args[1])
        local targetId = tonumber(args[2])
        local amount = tonumber(args[3])
        
        if sourceId and targetId and amount then
            print("^3[ZS Banking TEST]^7 Test-Überweisung: $" .. amount .. " von " .. sourceId .. " an " .. targetId)
            
            local xPlayer = ESX.GetPlayerFromId(sourceId)
            local xTarget = ESX.GetPlayerFromId(targetId)
            
            if xPlayer and xTarget then
                local oldSourceBank = xPlayer.getAccount('bank').money
                local oldTargetBank = xTarget.getAccount('bank').money
                
                print("^3[ZS Banking TEST]^7 Sender Bank alt: $" .. oldSourceBank)
                print("^3[ZS Banking TEST]^7 Empfänger Bank alt: $" .. oldTargetBank)
                
                -- Test-Überweisung
                xPlayer.removeAccountMoney('bank', amount)
                xTarget.addAccountMoney('bank', amount)
                
                local newSourceBank = xPlayer.getAccount('bank').money
                local newTargetBank = xTarget.getAccount('bank').money
                
                print("^3[ZS Banking TEST]^7 Sender Bank neu: $" .. newSourceBank)
                print("^3[ZS Banking TEST]^7 Empfänger Bank neu: $" .. newTargetBank)
                print("^3[ZS Banking TEST]^7 Überweisung erfolgreich: " .. (newSourceBank == oldSourceBank - amount and newTargetBank == oldTargetBank + amount and "JA" or "NEIN"))
            else
                print("^1[ZS Banking TEST]^7 Spieler nicht gefunden!")
            end
        else
            print("^1[ZS Banking TEST]^7 Verwendung: testtransfer [sourceId] [targetId] [amount]")
        end
    end
end, false)

-- Set Account Money Command
RegisterCommand('setaccountmoney', function(source, args, rawCommand)
    if source == 0 then -- Nur von Konsole
        local playerId = tonumber(args[1])
        local accountType = args[2]
        local amount = tonumber(args[3])
        
        if playerId and accountType and amount then
            print("^3[ZS Banking SETACCOUNT]^7 Setze " .. accountType .. " auf $" .. amount .. " für Spieler " .. playerId)
            
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                local oldAmount = 0
                
                -- Aktuellen Betrag abrufen
                if accountType == 'bank' then
                    oldAmount = xPlayer.getAccount('bank').money
                    xPlayer.setAccountMoney('bank', amount)
                elseif accountType == 'money' then
                    oldAmount = xPlayer.getMoney()
                    xPlayer.setMoney(amount)
                elseif accountType == 'black_money' then
                    oldAmount = xPlayer.getAccount('black_money').money
                    xPlayer.setAccountMoney('black_money', amount)
                else
                    print("^1[ZS Banking ERROR]^7 Ungültiger Account-Typ: " .. accountType)
                    print("^1[ZS Banking ERROR]^7 Verfügbare Typen: bank, money, black_money")
                    return
                end
                
                -- Neuen Betrag abrufen
                local newAmount = 0
                if accountType == 'bank' then
                    newAmount = xPlayer.getAccount('bank').money
                elseif accountType == 'money' then
                    newAmount = xPlayer.getMoney()
                elseif accountType == 'black_money' then
                    newAmount = xPlayer.getAccount('black_money').money
                end
                
                print("^2[ZS Banking SUCCESS]^7 " .. accountType .. " für " .. xPlayer.getName() .. " geändert:")
                print("^2[ZS Banking SUCCESS]^7 Alt: $" .. oldAmount .. " -> Neu: $" .. newAmount)
                
                -- Transaktion zur lokalen Verwaltung hinzufügen (nur für Bank)
                if accountType == 'bank' then
                    local transaction = AddTransaction(xPlayer.identifier, {
                        type = 'admin_set',
                        amount = amount,
                        description = 'Admin: Konto auf $' .. amount .. ' gesetzt'
                    })
                    print("^2[ZS Banking]^7 Transaktion hinzugefügt:", transaction)
                end
                
                -- Spielerdaten aktualisieren
                local playerData = {
                    cash = xPlayer.getMoney(),
                    bank = xPlayer.getAccount('bank').money,
                    name = xPlayer.getName(),
                    transactions = GetPlayerTransactions(xPlayer.identifier)
                }
                TriggerClientEvent('bank:updatePlayerData', playerId, playerData)
                
            else
                print("^1[ZS Banking ERROR]^7 Spieler mit ID " .. playerId .. " nicht gefunden!")
            end
        else
            print("^1[ZS Banking ERROR]^7 Verwendung: setaccountmoney [playerId] [accountType] [amount]")
            print("^1[ZS Banking ERROR]^7 Account-Typen: bank, money, black_money")
            print("^1[ZS Banking ERROR]^7 Beispiel: setaccountmoney 1 bank 50000")
        end
    else
        print("^1[ZS Banking ERROR]^7 Dieser Befehl kann nur von der Konsole ausgeführt werden!")
    end
end, false)

-- Add Account Money Command
RegisterCommand('addaccountmoney', function(source, args, rawCommand)
    if source == 0 then -- Nur von Konsole
        local playerId = tonumber(args[1])
        local accountType = args[2]
        local amount = tonumber(args[3])
        
        if playerId and accountType and amount then
            print("^3[ZS Banking ADDACCOUNT]^7 Füge $" .. amount .. " zu " .. accountType .. " für Spieler " .. playerId .. " hinzu")
            
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                local oldAmount = 0
                
                -- Aktuellen Betrag abrufen
                if accountType == 'bank' then
                    oldAmount = xPlayer.getAccount('bank').money
                    xPlayer.addAccountMoney('bank', amount)
                elseif accountType == 'money' then
                    oldAmount = xPlayer.getMoney()
                    xPlayer.addMoney(amount)
                elseif accountType == 'black_money' then
                    oldAmount = xPlayer.getAccount('black_money').money
                    xPlayer.addAccountMoney('black_money', amount)
                else
                    print("^1[ZS Banking ERROR]^7 Ungültiger Account-Typ: " .. accountType)
                    print("^1[ZS Banking ERROR]^7 Verfügbare Typen: bank, money, black_money")
                    return
                end
                
                -- Neuen Betrag abrufen
                local newAmount = 0
                if accountType == 'bank' then
                    newAmount = xPlayer.getAccount('bank').money
                elseif accountType == 'money' then
                    newAmount = xPlayer.getMoney()
                elseif accountType == 'black_money' then
                    newAmount = xPlayer.getAccount('black_money').money
                end
                
                print("^2[ZS Banking SUCCESS]^7 $" .. amount .. " zu " .. accountType .. " für " .. xPlayer.getName() .. " hinzugefügt:")
                print("^2[ZS Banking SUCCESS]^7 Alt: $" .. oldAmount .. " -> Neu: $" .. newAmount)
                
                -- Transaktion zur lokalen Verwaltung hinzufügen (nur für Bank)
                if accountType == 'bank' then
                    local transaction = AddTransaction(xPlayer.identifier, {
                        type = 'admin_add',
                        amount = amount,
                        description = 'Admin: $' .. amount .. ' hinzugefügt'
                    })
                    print("^2[ZS Banking]^7 Transaktion hinzugefügt:", transaction)
                end
                
                -- Spielerdaten aktualisieren
                local playerData = {
                    cash = xPlayer.getMoney(),
                    bank = xPlayer.getAccount('bank').money,
                    name = xPlayer.getName(),
                    transactions = GetPlayerTransactions(xPlayer.identifier)
                }
                TriggerClientEvent('bank:updatePlayerData', playerId, playerData)
                
            else
                print("^1[ZS Banking ERROR]^7 Spieler mit ID " .. playerId .. " nicht gefunden!")
            end
        else
            print("^1[ZS Banking ERROR]^7 Verwendung: addaccountmoney [playerId] [accountType] [amount]")
            print("^1[ZS Banking ERROR]^7 Account-Typen: bank, money, black_money")
            print("^1[ZS Banking ERROR]^7 Beispiel: addaccountmoney 1 bank 10000")
        end
    else
        print("^1[ZS Banking ERROR]^7 Dieser Befehl kann nur von der Konsole ausgeführt werden!")
    end
end, false)

-- Remove Account Money Command
RegisterCommand('removeaccountmoney', function(source, args, rawCommand)
    if source == 0 then -- Nur von Konsole
        local playerId = tonumber(args[1])
        local accountType = args[2]
        local amount = tonumber(args[3])
        
        if playerId and accountType and amount then
            print("^3[ZS Banking REMOVEACCOUNT]^7 Entferne $" .. amount .. " von " .. accountType .. " für Spieler " .. playerId)
            
            local xPlayer = ESX.GetPlayerFromId(playerId)
            if xPlayer then
                local oldAmount = 0
                
                -- Aktuellen Betrag abrufen
                if accountType == 'bank' then
                    oldAmount = xPlayer.getAccount('bank').money
                    xPlayer.removeAccountMoney('bank', amount)
                elseif accountType == 'money' then
                    oldAmount = xPlayer.getMoney()
                    xPlayer.removeMoney(amount)
                elseif accountType == 'black_money' then
                    oldAmount = xPlayer.getAccount('black_money').money
                    xPlayer.removeAccountMoney('black_money', amount)
                else
                    print("^1[ZS Banking ERROR]^7 Ungültiger Account-Typ: " .. accountType)
                    print("^1[ZS Banking ERROR]^7 Verfügbare Typen: bank, money, black_money")
                    return
                end
                
                -- Neuen Betrag abrufen
                local newAmount = 0
                if accountType == 'bank' then
                    newAmount = xPlayer.getAccount('bank').money
                elseif accountType == 'money' then
                    newAmount = xPlayer.getMoney()
                elseif accountType == 'black_money' then
                    newAmount = xPlayer.getAccount('black_money').money
                end
                
                print("^2[ZS Banking SUCCESS]^7 $" .. amount .. " von " .. accountType .. " für " .. xPlayer.getName() .. " entfernt:")
                print("^2[ZS Banking SUCCESS]^7 Alt: $" .. oldAmount .. " -> Neu: $" .. newAmount)
                
                -- Transaktion zur lokalen Verwaltung hinzufügen (nur für Bank)
                if accountType == 'bank' then
                    local transaction = AddTransaction(xPlayer.identifier, {
                        type = 'admin_remove',
                        amount = amount,
                        description = 'Admin: $' .. amount .. ' entfernt'
                    })
                    print("^2[ZS Banking]^7 Transaktion hinzugefügt:", transaction)
                end
                
                -- Spielerdaten aktualisieren
                local playerData = {
                    cash = xPlayer.getMoney(),
                    bank = xPlayer.getAccount('bank').money,
                    name = xPlayer.getName(),
                    transactions = GetPlayerTransactions(xPlayer.identifier)
                }
                TriggerClientEvent('bank:updatePlayerData', playerId, playerData)
                
            else
                print("^1[ZS Banking ERROR]^7 Spieler mit ID " .. playerId .. " nicht gefunden!")
            end
        else
            print("^1[ZS Banking ERROR]^7 Verwendung: removeaccountmoney [playerId] [accountType] [amount]")
            print("^1[ZS Banking ERROR]^7 Account-Typen: bank, money, black_money")
            print("^1[ZS Banking ERROR]^7 Beispiel: removeaccountmoney 1 bank 5000")
        end
    else
        print("^1[ZS Banking ERROR]^7 Dieser Befehl kann nur von der Konsole ausgeführt werden!")
    end
end, false)

-- ========================================
-- PLAYER DATA REQUESTS
-- ========================================

-- Spieler fordert aktuelle Daten an
RegisterNetEvent('zs_banking:requestPlayerData')
AddEventHandler('zs_banking:requestPlayerData', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then
        print("^1[ZS Banking ERROR]^7 Spieler nicht gefunden:", source)
        return
    end
    
    local playerData = {
        cash = xPlayer.getMoney(),
        bank = xPlayer.getAccount('bank').money,
        name = xPlayer.getName(),
        transactions = {} -- Leere Transaktionen für lokale Daten
    }
    
    print("^2[ZS Banking]^7 Sende Spielerdaten an Client:", source)
    print("^2[ZS Banking]^7 - Name:", playerData.name)
    print("^2[ZS Banking]^7 - Cash:", playerData.cash)
    print("^2[ZS Banking]^7 - Bank:", playerData.bank)
    
    TriggerClientEvent('zs_banking:receivePlayerData', source, playerData)
end)

-- ========================================
-- CRYPTO ADDON INTEGRATION
-- ========================================

-- Prüfe ob das zs_crypto Addon verfügbar ist
local function IsCryptoAddonAvailable()
    -- Prüfe zuerst die Config
    if not Config.AddonIntegration or not Config.AddonIntegration.zs_crypto then
        return false
    end
    
    -- Dann prüfe ob das Addon läuft (korrigierter Name)
    if GetResourceState('zs_cryptoaddon') ~= 'started' then
        return false
    end
    
    -- Prüfe ob die Exports verfügbar sind
    local success, result = pcall(function()
        return exports['zs_cryptoaddon']:IsCryptoEnabled()
    end)
    
    return success and result
end

-- Erweiterte Crypto-Addon-Überprüfung
local function ValidateCryptoAddon()
    local status = {
        config = Config.AddonIntegration and Config.AddonIntegration.zs_crypto or false,
        resource = GetResourceState('zs_cryptoaddon'),
        exports = false,
        functions = {}
    }
    
    -- Prüfe alle verfügbaren Exports
    if status.resource == 'started' then
        local exports = {
            'IsCryptoEnabled',
            'GetPlayerWallet',
            'BuyCrypto',
            'SellCrypto',
            'GetCryptoPrices'
        }
        
        for _, exportName in ipairs(exports) do
            local success, _ = pcall(function()
                return exports['zs_cryptoaddon'][exportName]
            end)
            if success then
                status.functions[exportName] = true
            else
                status.functions[exportName] = false
            end
        end
        
        -- Prüfe ob mindestens die wichtigsten Exports verfügbar sind
        status.exports = status.functions['IsCryptoEnabled'] and status.functions['GetPlayerWallet']
    end
    
    return status
end

-- Crypto-Addon Status beim Server-Start loggen
Citizen.CreateThread(function()
    Citizen.Wait(5000) -- 5 Sekunden warten bis alle Resources geladen sind
    
    if IsCryptoAddonAvailable() then
        print("^2[ZS Banking]^7 zs_cryptoaddon Addon gefunden und aktiviert")
    else
        if Config.AddonIntegration and Config.AddonIntegration.zs_crypto then
            print("^3[ZS Banking]^7 zs_cryptoaddon Addon in Config aktiviert, aber Resource läuft nicht")
        else
            print("^3[ZS Banking]^7 zs_cryptoaddon Addon in Config deaktiviert")
        end
    end
end)

-- ========================================
-- HEARTBEAT SYNCHRONISATION
-- ========================================

-- Regelmäßige Überprüfung der Crypto-Addon-Verfügbarkeit
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000) -- Alle 30 Sekunden
        
        local status = ValidateCryptoAddon()
        
        if status.config and status.resource == 'started' and status.exports then
            -- Alles funktioniert
            if not status.lastHeartbeat or (os.time() - status.lastHeartbeat) > 60 then
                print("^2[ZS Banking]^7 Crypto-Addon Heartbeat: OK")
                status.lastHeartbeat = os.time()
            end
        else
            -- Probleme gefunden
            if status.config then
                if status.resource ~= 'started' then
                    print("^1[ZS Banking]^7 CRITICAL: zs_cryptoaddon Resource läuft nicht!")
                elseif not status.exports then
                    print("^1[ZS Banking]^7 CRITICAL: zs_cryptoaddon Exports nicht verfügbar!")
                    print("^1[ZS Banking]^7 Verfügbare Exports:")
                    for func, available in pairs(status.functions) do
                        print(string.format("  - %s: %s", func, available and "^2✓^7" or "^1✗^7"))
                    end
                end
            end
        end
    end
end)

-- ========================================
-- CRYPTO ADDON STATUS EVENTS
-- ========================================

-- Banking fragt Crypto-Addon-Status ab
RegisterNetEvent('zs_banking:getCryptoStatus')
AddEventHandler('zs_banking:getCryptoStatus', function()
    local source = source
    local status = ValidateCryptoAddon()
    
    TriggerClientEvent('zs_banking:receiveCryptoStatus', source, {
        available = status.config and status.resource == 'started' and status.exports,
        resource = status.resource,
        exports = status.exports,
        functions = status.functions,
        message = status.config and status.resource == 'started' and status.exports and "Crypto-System verfügbar" or "Crypto-System nicht verfügbar"
    })
end)

-- ========================================
-- CRYPTO SERVER EVENTS (zs_cryptoaddon Integration)
-- ========================================

-- WICHTIG: Das Banking implementiert KEINE Crypto-Logik!
-- Es leitet nur Events an das zs_cryptoaddon weiter!

-- Banking ist nur ein "Proxy" für das Crypto-Addon
-- Alle Crypto-Funktionen sind im zs_cryptoaddon implementiert

-- Banking prüft Kauf-Möglichkeit
RegisterNetEvent('zs_banking:validateCryptoBuy')
AddEventHandler('zs_banking:validateCryptoBuy', function(cryptoType, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Prüfe ob genug Bargeld vorhanden ist
    if xPlayer.getMoney() < amount then
        TriggerClientEvent('bank:showNotification', source, 'Nicht genug Bargeld für den Kauf!', 'error')
        return
    end
    
    -- Leite an zs_cryptoaddon weiter (das macht die echte Validierung)
    TriggerEvent('zs_cryptoaddon:validateBuy', source, xPlayer.identifier, cryptoType, amount)
end)

-- Banking leitet Crypto-Verkauf-Validierung an zs_cryptoaddon weiter
RegisterNetEvent('zs_banking:validateCryptoSell')
AddEventHandler('zs_banking:validateCryptoSell', function(cryptoType, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Einfache Parameter-Validierung
    if not cryptoType or not amount or amount <= 0 then
        TriggerClientEvent('zs_banking:cryptoValidationResult', source, {success = false, message = 'Ungültige Parameter'})
        return
    end
    
    -- Leite an zs_cryptoaddon weiter (das macht die echte Validierung)
    TriggerEvent('zs_cryptoaddon:validateSell', source, xPlayer.identifier, cryptoType, amount)
end)

-- Banking führt Krypto-Verkauf durch
RegisterNetEvent('zs_banking:executeCryptoSell')
AddEventHandler('zs_banking:executeCryptoSell', function(cryptoType, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Leite den Verkauf an das zs_cryptoaddon weiter
    TriggerServerEvent('zs_cryptoaddon:executeSell', source, xPlayer.identifier, cryptoType, amount)
end)

-- Banking führt Krypto-Kauf durch
RegisterNetEvent('zs_banking:executeCryptoBuy')
AddEventHandler('zs_banking:executeCryptoBuy', function(cryptoType, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Leite den Kauf an das zs_cryptoaddon weiter
    TriggerServerEvent('zs_cryptoaddon:executeBuy', source, xPlayer.identifier, cryptoType, amount)
end)

-- Banking lädt alle Krypto-Daten
RegisterNetEvent('zs_banking:requestAllCryptoData')
AddEventHandler('zs_banking:requestAllCryptoData', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Leite die Anfrage an das zs_cryptoaddon weiter
    TriggerServerEvent('zs_cryptoaddon:requestAllCryptoData', source)
end)

-- Banking aktualisiert Crypto-Daten
RegisterNetEvent('zs_banking:refreshCryptoData')
AddEventHandler('zs_banking:refreshCryptoData', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Leite die Anfrage an das zs_cryptoaddon weiter
    TriggerServerEvent('zs_cryptoaddon:requestAllCryptoData', source)
end)

-- Banking fragt ab, ob Krypto verfügbar ist
RegisterNetEvent('zs_banking:checkCryptoAvailable')
AddEventHandler('zs_banking:checkCryptoAvailable', function()
    local source = source
    
    -- Sende den Status zurück
    TriggerClientEvent('zs_banking:cryptoAvailableResponse', source, IsCryptoAddonAvailable())
end)

-- ========================================
-- CRYPTO SERVER CALLBACKS (zs_crypto Integration)
-- ========================================

-- Crypto-Daten abrufen (über zs_crypto)
ESX.RegisterServerCallback('bank:getCryptoData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        cb(nil)
        return
    end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        cb(nil)
        return
    end
    
    -- Hole Crypto-Daten über das zs_cryptoaddon Addon
    local success, result = pcall(function()
        local wallet = exports['zs_cryptoaddon']:GetPlayerWallet(xPlayer.identifier)
        local prices = exports['zs_cryptoaddon']:GetCryptoPrices()
        
        if wallet and prices then
            local cryptoData = {
                success = true,
                enabled = true,
                wallet = wallet,
                prices = prices,
                currencies = Config.Crypto.currencies or {}
            }
            cb(cryptoData)
        else
            cb({success = false, error = 'Daten konnten nicht geladen werden'})
        end
    end)
    
    if not success then
        cb({success = false, error = 'Crypto-System nicht verfügbar'})
    end
end)

-- Crypto verkaufen
RegisterNetEvent('bank:sellCrypto')
AddEventHandler('bank:sellCrypto', function(amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob Crypto aktiviert ist
    if not Config.Crypto or not Config.Crypto.enabled then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist deaktiviert', 'error')
        return
    end
    
    local cryptoData = GetPlayerCryptoData(xPlayer.identifier)
    
    -- Prüfe ob genug Crypto vorhanden ist
    if cryptoData.balance < amount then
        TriggerClientEvent('bank:showNotification', source, 'Nicht genug Crypto zum Verkaufen!', 'error')
        return
    end
    
    local usdAmount = amount * cryptoData.price
    
    -- Crypto abziehen
    cryptoData.balance = cryptoData.balance - amount
    
    -- Bargeld hinzufügen
    xPlayer.addMoney(usdAmount)
    
    -- Transaktion hinzufügen
    AddCryptoTransaction(xPlayer.identifier, {
        type = 'sell',
        amount = amount,
        price = cryptoData.price,
        description = 'Crypto verkauft für $' .. usdAmount
    })
    
    -- Erfolgsmeldung
    TriggerClientEvent('bank:showNotification', source, 'Crypto erfolgreich verkauft!', 'success')
    
    -- Spielerdaten aktualisieren
    local playerData = {
        cash = xPlayer.getMoney(),
        bank = xPlayer.getAccount('bank').money,
        name = xPlayer.getName(),
        transactions = GetPlayerTransactions(xPlayer.identifier)
    }
    TriggerClientEvent('bank:updatePlayerData', source, playerData)
    
    if Config.Debug and Config.Debug.enabled and Config.Debug.logging and Config.Debug.logging.banking then
        print("^2[ZS Banking Crypto]^7 " .. xPlayer.getName() .. " hat " .. amount .. " Crypto für $" .. usdAmount .. " verkauft")
    end
end)

-- ========================================
-- INITIALIZATION
-- ========================================

if Config.Debug and Config.Debug.enabled and Config.Debug.logging and Config.Debug.logging.banking then
    print("^2[ZS Banking]^7 Server-System geladen")
    print("^2[ZS Banking]^7 Verfügbare Features:")
    print("^2[ZS Banking]^7 - Einzahlen/Auszahlen (Gebührenfrei)")
    print("^2[ZS Banking]^7 - Überweisungen (3% Gebühr)")
    print("^2[ZS Banking]^7 - Transaktions-System")
    if IsCryptoAddonAvailable() then
        print("^2[ZS Banking]^7 - zs_crypto Integration (AKTIVIERT)")
    else
        if Config.AddonIntegration and Config.AddonIntegration.zs_crypto then
            print("^3[ZS Banking]^7 - zs_crypto Integration (CONFIG AKTIVIERT, RESOURCE LÄUFT NICHT)")
        else
            print("^3[ZS Banking]^7 - zs_crypto Integration (CONFIG DEAKTIVIERT)")
        end
    end
end

-- ========================================
-- CRYPTO TRANSACTION DATABASE FUNCTIONS  
-- ========================================

-- Funktion zum Speichern einer Crypto-Transaktion
function SaveCryptoTransaction(identifier, playerName, transactionType, cryptoCurrency, cryptoAmount, usdAmount, exchangeRate, feeAmount, totalAmount, success, errorMessage)
    if not identifier then
        print("^1[ZS Banking]^7 Fehler: Keine Identifier für Crypto-Transaktion")
        return false
    end
    
    MySQL.Async.execute('INSERT INTO banking_crypto_transactions (identifier, player_name, transaction_type, crypto_currency, crypto_amount, usd_amount, exchange_rate, fee_amount, total_amount, success, error_message, server_id) VALUES (@identifier, @player_name, @transaction_type, @crypto_currency, @crypto_amount, @usd_amount, @exchange_rate, @fee_amount, @total_amount, @success, @error_message, @server_id)', {
        ['@identifier'] = identifier,
        ['@player_name'] = playerName or 'Unknown',
        ['@transaction_type'] = transactionType,
        ['@crypto_currency'] = cryptoCurrency,
        ['@crypto_amount'] = cryptoAmount,
        ['@usd_amount'] = usdAmount,
        ['@exchange_rate'] = exchangeRate,
        ['@fee_amount'] = feeAmount or 0.0,
        ['@total_amount'] = totalAmount,
        ['@success'] = success and 1 or 0,
        ['@error_message'] = errorMessage,
        ['@server_id'] = GetConvar('sv_hostname', 'ZS-Server')
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print(string.format("^2[ZS Banking]^7 Crypto-Transaktion gespeichert: %s %s %s %s für %s", playerName, transactionType, cryptoAmount, cryptoCurrency, identifier))
        else
            print(string.format("^1[ZS Banking]^7 Fehler beim Speichern der Crypto-Transaktion für %s", identifier))
        end
    end)
    
    return true
end

-- Funktion zum Abrufen der Crypto-Transaktionen eines Spielers
function GetPlayerCryptoTransactions(identifier, callback)
    if not identifier then
        callback({})
        return
    end
    
    MySQL.Async.fetchAll('SELECT * FROM banking_crypto_player_history WHERE identifier = @identifier ORDER BY transaction_date DESC LIMIT 50', {
        ['@identifier'] = identifier
    }, function(result)
        callback(result or {})
    end)
end

-- Event-Handler für Crypto-Transaktions-Logging
RegisterNetEvent('zs_banking:logCryptoTransaction')
AddEventHandler('zs_banking:logCryptoTransaction', function(transactionData)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        print("^1[ZS Banking]^7 Fehler: Spieler nicht gefunden für Crypto-Transaktion-Logging")
        return
    end
    
    local identifier = xPlayer.identifier
    local playerName = xPlayer.getName()
    
    SaveCryptoTransaction(
        identifier,
        playerName,
        transactionData.type,
        transactionData.currency,
        transactionData.cryptoAmount,
        transactionData.usdAmount,
        transactionData.exchangeRate,
        transactionData.feeAmount,
        transactionData.totalAmount,
        transactionData.success,
        transactionData.errorMessage
    )
end)

-- Event-Handler für Crypto-Transaktions-Historie
RegisterNetEvent('zs_banking:requestCryptoHistory')
AddEventHandler('zs_banking:requestCryptoHistory', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if not xPlayer then
        return
    end
    
    GetPlayerCryptoTransactions(xPlayer.identifier, function(transactions)
        TriggerClientEvent('zs_banking:receiveCryptoHistory', src, transactions)
    end)
end)

-- ========================================
-- CRYPTO ADDON INTEGRATION EVENTS
-- ========================================

-- Empfange Crypto-Status vom Addon
RegisterNetEvent('zs_cryptoaddon:receiveCryptoStatus')
AddEventHandler('zs_cryptoaddon:receiveCryptoStatus', function(status)
    local source = source
    TriggerClientEvent('zs_banking:receiveCryptoStatus', source, status)
end)

-- Empfange Crypto-Wallet vom Addon
RegisterNetEvent('zs_cryptoaddon:updateCryptoWallet')
AddEventHandler('zs_cryptoaddon:updateCryptoWallet', function(wallet)
    local source = source
    TriggerClientEvent('zs_banking:updateCryptoWallet', source, wallet)
end)

-- Empfange Crypto-Transaktionsergebnis vom Addon
RegisterNetEvent('zs_cryptoaddon:cryptoTransactionResult')
AddEventHandler('zs_cryptoaddon:cryptoTransactionResult', function(result)
    local source = source
    TriggerClientEvent('zs_banking:cryptoTransactionResult', source, result)
end)

-- Empfange alle Crypto-Daten vom Addon
RegisterNetEvent('zs_cryptoaddon:receiveAllCryptoData')
AddEventHandler('zs_cryptoaddon:receiveAllCryptoData', function(data)
    local source = source
    TriggerClientEvent('zs_banking:receiveAllCryptoData', source, data)
end)

-- Empfange Crypto-Preise vom Addon
RegisterNetEvent('zs_cryptoaddon:receiveCryptoPrices')
AddEventHandler('zs_cryptoaddon:receiveCryptoPrices', function(prices)
    local source = source
    
    -- Log der empfangenen Preise (optional, für Debug)
    if source == -1 then -- Broadcast an alle Clients
        print("^3[ZS Banking]^7 Preise vom Crypto-Addon empfangen: " .. json.encode(prices))
    end
    
    TriggerClientEvent('zs_banking:receiveCryptoPrices', source, prices)
end)

-- Empfange Crypto-Wettbewerbe vom Addon
RegisterNetEvent('zs_cryptoaddon:receiveCryptoContests')
AddEventHandler('zs_cryptoaddon:receiveCryptoContests', function(contests)
    local source = source
    TriggerClientEvent('zs_banking:receiveCryptoContests', source, contests)
end)

-- Empfange Wettbewerb-Beitrittsergebnis vom Addon
RegisterNetEvent('zs_cryptoaddon:contestJoinResult')
AddEventHandler('zs_cryptoaddon:contestJoinResult', function(result)
    local source = source
    TriggerClientEvent('zs_banking:contestJoinResult', source, result)
end)

-- ========================================
-- CRYPTO VALIDATION EVENTS
-- ========================================

-- Banking validiert Crypto-Kauf
RegisterNetEvent('zs_banking:validateCryptoBuy')
AddEventHandler('zs_banking:validateCryptoBuy', function(cryptoType, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Leite die Validierung an das zs_cryptoaddon weiter
    TriggerServerEvent('zs_cryptoaddon:validateBuy', source, xPlayer.identifier, cryptoType, amount)
end)

-- Banking validiert Crypto-Verkauf
RegisterNetEvent('zs_banking:validateCryptoSell')
AddEventHandler('zs_banking:validateCryptoSell', function(cryptoType, amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Leite die Validierung an das zs_cryptoaddon weiter
    TriggerServerEvent('zs_cryptoaddon:validateSell', source, xPlayer.identifier, cryptoType, amount)
end)

-- ========================================
-- CRYPTO CONTEST EVENTS
-- ========================================

-- Banking fragt aktuelle Wettbewerbe ab
RegisterNetEvent('zs_banking:requestCryptoContests')
AddEventHandler('zs_banking:requestCryptoContests', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Leite die Anfrage an das zs_cryptoaddon weiter
    TriggerServerEvent('zs_cryptoaddon:requestCryptoContests', source)
end)

-- Banking tritt Wettbewerb bei
RegisterNetEvent('zs_banking:joinCryptoContest')
AddEventHandler('zs_banking:joinCryptoContest', function(contestId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Leite die Anfrage an das zs_cryptoaddon weiter
    TriggerServerEvent('zs_cryptoaddon:joinContest', source, contestId)
end)

-- Banking erstellt neuen Wettbewerb
RegisterNetEvent('zs_banking:createContest')
AddEventHandler('zs_banking:createContest', function(contestType, duration, prizePool)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe Admin-Berechtigung
    if xPlayer.getGroup() ~= 'admin' then
        TriggerClientEvent('bank:showNotification', source, 'Du hast keine Berechtigung für diese Aktion', 'error')
        return
    end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Leite die Anfrage an das zs_cryptoaddon weiter
    TriggerServerEvent('zs_cryptoaddon:createContest', source, contestType, duration, prizePool)
end)

-- ========================================
-- CRYPTO DATA REFRESH EVENTS
-- ========================================

-- Banking fragt aktuelle Preise ab
RegisterNetEvent('zs_banking:requestCryptoPrices')
AddEventHandler('zs_banking:requestCryptoPrices', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Leite die Anfrage an das zs_cryptoaddon weiter
    TriggerServerEvent('zs_cryptoaddon:requestCryptoPrices', source)
end)

-- Banking fragt Wallet ab
RegisterNetEvent('zs_banking:requestCryptoWallet')
AddEventHandler('zs_banking:requestCryptoWallet', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if not xPlayer then return end
    
    -- Prüfe ob das Crypto-Addon verfügbar ist
    if not IsCryptoAddonAvailable() then
        TriggerClientEvent('bank:showNotification', source, 'Crypto-System ist nicht verfügbar', 'error')
        return
    end
    
    -- Leite die Anfrage an das zs_cryptoaddon weiter
    TriggerServerEvent('zs_cryptoaddon:requestCryptoWallet', source)
end)

-- ========================================
-- CRYPTO HEARTBEAT SYSTEM
-- ========================================

-- Regelmäßige Status-Updates an alle Clients
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000) -- Alle 30 Sekunden
        
        if IsCryptoAddonAvailable() then
            local status = {
                available = true,
                resource = GetResourceState('zs_cryptoaddon'),
                exports = true,
                message = "Crypto-System verfügbar"
            }
            
            TriggerClientEvent('zs_banking:receiveCryptoStatus', -1, status)
        end
    end
end)

-- ========================================
-- CRYPTO NOTIFICATION SYSTEM
-- ========================================

-- Sende Benachrichtigungen an alle Clients
function SendCryptoNotificationToAll(message, type)
    TriggerClientEvent('bank:showNotification', -1, message, type or 'info')
end

-- Sende Benachrichtigung an spezifischen Client
function SendCryptoNotificationToPlayer(source, message, type)
    TriggerClientEvent('bank:showNotification', source, message, type or 'info')
end




