-- ========================================
-- ZS BANKING CLIENT - KOMPLETT NEU
-- ========================================
-- Einfacher Banking-Client ohne Überweisungen

-- Config wird aus config.lua geladen

-- Locales werden aus den separaten Dateien geladen
-- Locales = {} -- Diese Zeile wurde entfernt, da sie die geladenen Übersetzungen überschreibt

-- Übersetzungen werden von der init.lua geladen

-- Sichere Debug-Funktion
function isDebugEnabled(category)
    return Config.Debug and Config.Debug.enabled and Config.Debug.logging and Config.Debug.logging[category]
end

-- Config geladen
if isDebugEnabled('banking') then
    print("^2[ZS Banking]^7 Config geladen - " .. #Config.MainBanks .. " Hauptbanken, " .. #Config.ATMs .. " ATMs")
end

-- Übersetzungen direkt hier definieren, da die init.lua nicht funktioniert
local BankingLocales = {
    ['de'] = {
        ['overview'] = '📊 ÜBERSICHT',
        ['deposit_tab'] = '💰 EINZAHLEN',
        ['withdraw_tab'] = '💸 ABHEBEN',
        ['transfer_tab'] = '🔄 ÜBERWEISEN',
        ['transactions_tab'] = '📜 VERLAUF',
        ['bank_name'] = '🏦 ZS BANKING SYSTEM',
        ['player_name'] = '👤 SPIELER NAME',
        ['player_label'] = 'SPIELER',
        ['last_transaction'] = 'LETZTE TRANSAKTION',
        ['quick_actions'] = '⚡ SCHNELLAKTIONEN',
        ['deposit_title'] = '💰 GELD EINZAHLEN',
        ['withdraw_title'] = '💸 GELD ABHEBEN',
        ['transfer_title'] = '🔄 GELD ÜBERWEISEN',
        ['amount'] = '💵 BETRAG:',
        ['player_id'] = '👤 SPIELER ID:',
        ['deposit_btn'] = '💰 EINZAHLEN',
        ['withdraw_btn'] = '💸 ABHEBEN',
        ['transfer_btn'] = '🔄 ÜBERWEISEN',
        ['transactions_title'] = '📜 TRANSAKTIONSVERLAUF',
        ['no_transactions_text'] = '📝 KEINE TRANSAKTIONEN VERFÜGBAR',
        ['amount_placeholder'] = 'BETRAG EINGEBEN',
        ['player_id_placeholder'] = 'SPIELER ID EINGEBEN',
        ['error_invalid_amount'] = 'BITTE GEBEN SIE EINEN GÜLTIGEN BETRAG EIN!',
        ['error_invalid_player_id'] = 'BITTE GEBEN SIE EINE GÜLTIGE SPIELER-ID EIN!',
        ['error_unknown'] = 'UNBEKANNTER FEHLER',
        ['success_deposit'] = '💰 EINZAHLUNG ERFOLGREICH!',
        ['success_withdraw'] = '💸 ABHEBUNG ERFOLGREICH!',
        ['success_transfer'] = '🔄 ÜBERWEISUNG ERFOLGREICH!',
        ['error_deposit_failed'] = '❌ EINZAHLUNG FEHLGESCHLAGEN',
        ['error_withdraw_failed'] = '❌ ABHEBUNG FEHLGESCHLAGEN',
        ['error_transfer_failed'] = '❌ ÜBERWEISUNG FEHLGESCHLAGEN',
        ['deposit_success'] = '💰 EINZAHLUNG ERFOLGREICH!',
        ['withdraw_success'] = '💸 ABHEBUNG ERFOLGREICH!',
        ['transfer_success'] = '🔄 ÜBERWEISUNG ERFOLGREICH!',
        ['transfer_received'] = '✅ ÜBERWEISUNG ERHALTEN',
        ['cash_text'] = 'BARGELD',
        ['bank_text'] = 'BANKKONTO',
        ['page_title'] = 'ZS Banking System',
        -- Benachrichtigungen (automatisches Öffnen beim Marker)
        ['auto_bank_open'] = 'Banking wird automatisch geöffnet',
        ['auto_atm_open'] = 'ATM wird automatisch geöffnet',
        ['error_not_at_bank'] = 'Du musst an einer Bank oder einem ATM sein!',
        ['success_deposit_free'] = 'Einzahlung erfolgreich!',
        ['success_withdraw_free'] = 'Abhebung erfolgreich!',
        ['success_transfer_fee'] = 'Überweisung erfolgreich! Gebühr: $',
        ['success_transfer_received'] = 'Du hast $ erhalten!',
        ['deposit_type'] = 'Einzahlung',
        ['withdraw_type'] = 'Abhebung',
        ['transfer_sent_type'] = 'Überweisung gesendet',
        ['transfer_received_type'] = 'Überweisung erhalten',
        ['error_invalid_subscription'] = 'Ungültiger Abonnement-Typ!',
        ['error_not_enough_money_upgrade'] = 'Nicht genug Geld für Upgrade!',
        ['error_invalid_amount_server'] = 'Ungültiger Betrag!',
        ['error_not_enough_cash'] = 'Du hast nicht genug Bargeld!',
        ['error_not_enough_bank'] = 'Du hast nicht genug Geld auf dem Konto!',
        ['error_player_not_found'] = 'Spieler nicht gefunden!',
        ['error_transfers_disabled'] = 'Überweisungen sind deaktiviert!',
        ['error_not_enough_money_fee'] = 'Du hast nicht genug Geld für den Betrag + Gebühr!',
        -- Neue Übersetzungen für Überweisungen
        ['transfer_info'] = '💡 ÜBERWEISUNGS-INFO',
        ['transfer_fee_info'] = '💸 Gebühr: $',
        ['transfer_total_cost'] = '💰 Gesamtkosten: $',
        ['transfer_confirm'] = '✅ Überweisung bestätigen',
        ['transfer_cancel'] = '❌ Abbrechen',
        ['transfer_success_title'] = '🔄 ÜBERWEISUNG ERFOLGREICH',
        ['transfer_success_message'] = 'Überweisung wurde erfolgreich durchgeführt',
        ['transfer_error_title'] = '❌ ÜBERWEISUNG FEHLGESCHLAGEN',
        ['transfer_error_message'] = 'Überweisung konnte nicht durchgeführt werden',
        ['transfer_insufficient_funds'] = 'Nicht genug Geld für Überweisung + Gebühr',
        ['transfer_player_not_found'] = 'Zielspieler nicht gefunden',
        ['transfer_invalid_amount'] = 'Ungültiger Betrag für Überweisung',
        ['transfer_self_transfer'] = 'Du kannst nicht an dich selbst überweisen',
        -- Crypto Tab Übersetzungen
        ['crypto_tab'] = '₿ CRYPTO',
        ['crypto_title'] = '₿ CRYPTO VERWALTUNG',
        ['crypto_balance'] = 'CRYPTO PORTFOLIO',
        ['crypto_profit'] = 'GEWINN/VERLUST',
        ['crypto_select_currency'] = 'KRYPTOWÄHRUNG WÄHLEN',
        ['crypto_current_price'] = 'Aktueller Preis:',
        ['crypto_your_holdings'] = 'Ihre Bestände:',
        ['crypto_buy'] = 'CRYPTO KAUFEN',
        ['crypto_sell'] = 'CRYPTO VERKAUFEN',
        ['crypto_amount'] = '💵 BETRAG IN USD:',
        ['crypto_amount_crypto'] = '💎 CRYPTO BETRAG:',
        ['crypto_buy_btn'] = '💰 KAUFEN',
        ['crypto_sell_btn'] = '💵 VERKAUFEN',
        ['crypto_fee'] = 'Gebühr:',
        ['crypto_total'] = 'Gesamt:',
        ['crypto_value'] = 'Wert:',
        ['crypto_history'] = 'CRYPTO VERLAUF',
        ['no_crypto_transactions_text'] = '📝 Keine Crypto-Transaktionen vorhanden'
    },
    ['en'] = {
        ['overview'] = '📊 OVERVIEW',
        ['deposit_tab'] = '💰 DEPOSIT',
        ['withdraw_tab'] = '💸 WITHDRAW',
        ['transfer_tab'] = '🔄 TRANSFER',
        ['transactions_tab'] = '📜 HISTORY',
        ['bank_name'] = '🏦 ZS BANKING SYSTEM',
        ['player_name'] = '👤 PLAYER NAME',
        ['player_label'] = 'PLAYER',
        ['last_transaction'] = 'LAST TRANSACTION',
        ['quick_actions'] = '⚡ QUICK ACTIONS',
        ['deposit_title'] = '💰 DEPOSIT MONEY',
        ['withdraw_title'] = '💸 WITHDRAW MONEY',
        ['transfer_title'] = '🔄 TRANSFER MONEY',
        ['amount'] = '💵 AMOUNT:',
        ['player_id'] = '👤 PLAYER ID:',
        ['deposit_btn'] = '💰 DEPOSIT',
        ['withdraw_btn'] = '💸 WITHDRAW',
        ['transfer_btn'] = '🔄 TRANSFER',
        ['transactions_title'] = '📜 TRANSACTION HISTORY',
        ['no_transactions_text'] = '📝 NO TRANSACTIONS AVAILABLE',
        ['amount_placeholder'] = 'ENTER AMOUNT',
        ['player_id_placeholder'] = 'ENTER PLAYER ID',
        ['error_invalid_amount'] = 'PLEASE ENTER A VALID AMOUNT!',
        ['error_invalid_player_id'] = 'PLEASE ENTER A VALID PLAYER ID!',
        ['error_unknown'] = 'UNKNOWN ERROR',
        ['success_deposit'] = '💰 DEPOSIT SUCCESSFUL!',
        ['success_withdraw'] = '💸 WITHDRAWAL SUCCESSFUL!',
        ['success_transfer'] = '🔄 TRANSFER SUCCESSFUL!',
        ['error_deposit_failed'] = '❌ DEPOSIT FAILED',
        ['error_withdraw_failed'] = '❌ WITHDRAWAL FAILED',
        ['error_transfer_failed'] = '❌ TRANSFER FAILED',
        ['deposit_success'] = '💰 DEPOSIT SUCCESSFUL!',
        ['withdraw_success'] = '💸 WITHDRAWAL SUCCESSFUL!',
        ['transfer_success'] = '🔄 TRANSFER SUCCESSFUL!',
        ['transfer_received'] = '✅ TRANSFER RECEIVED',
        ['cash_text'] = 'CASH',
        ['bank_text'] = 'BANK ACCOUNT',
        ['page_title'] = 'ZS Banking System',
        -- Benachrichtigungen
        ['help_bank_open'] = 'Press ~b~E~w~ to open banking',
        ['help_bank_context'] = 'Press ~INPUT_CONTEXT~ to open the bank',
        ['help_atm_context'] = 'Press ~INPUT_CONTEXT~ to use the ATM',
        ['help_banking_context'] = 'Press ~INPUT_CONTEXT~ to open banking',
        ['error_not_at_bank'] = 'You must be at a bank or ATM!',
        ['success_deposit_free'] = 'Deposit successful! (No fees!)',
        ['success_withdraw_free'] = 'Withdrawal successful! (No fees!)',
        ['success_transfer_fee'] = 'Transfer successful! Fee: $',
        ['success_transfer_received'] = 'You received $!',
        ['error_invalid_subscription'] = 'Invalid subscription type!',
        ['error_not_enough_money_upgrade'] = 'Not enough money for upgrade!',
        ['error_invalid_amount_server'] = 'Invalid amount!',
        ['error_not_enough_cash'] = 'You don\'t have enough cash!',
        ['error_not_enough_bank'] = 'You don\'t have enough money in your account!',
        ['error_player_not_found'] = 'Player not found!',
        ['error_transfers_disabled'] = 'Transfers are disabled!',
        ['error_not_enough_money_fee'] = 'You don\'t have enough money for the amount + fee!',
        -- New translations for transfers
        ['transfer_info'] = '💡 TRANSFER INFO',
        ['transfer_fee_info'] = '💸 Fee: $',
        ['transfer_total_cost'] = '💰 Total cost: $',
        ['transfer_confirm'] = '✅ Confirm transfer',
        ['transfer_cancel'] = '❌ Cancel',
        ['transfer_success_title'] = '🔄 TRANSFER SUCCESSFUL',
        ['transfer_success_message'] = 'Transfer was completed successfully',
        ['transfer_error_title'] = '❌ TRANSFER FAILED',
        ['transfer_error_message'] = 'Transfer could not be completed',
        ['transfer_insufficient_funds'] = 'Not enough money for transfer + fee',
        ['transfer_player_not_found'] = 'Target player not found',
        ['transfer_invalid_amount'] = 'Invalid amount for transfer',
        ['transfer_self_transfer'] = 'You cannot transfer to yourself',
        -- Crypto Tab Übersetzungen
        ['crypto_tab'] = '₿ CRYPTO',
        ['crypto_title'] = '₿ CRYPTO MANAGEMENT',
        ['crypto_balance'] = 'CRYPTO PORTFOLIO',
        ['crypto_profit'] = 'PROFIT/LOSS',
        ['crypto_select_currency'] = 'SELECT CRYPTOCURRENCY',
        ['crypto_current_price'] = 'Current Price:',
        ['crypto_your_holdings'] = 'Your Holdings:',
        ['crypto_buy'] = 'BUY CRYPTO',
        ['crypto_sell'] = 'SELL CRYPTO',
        ['crypto_amount'] = '💵 AMOUNT IN USD:',
        ['crypto_amount_crypto'] = '💎 CRYPTO AMOUNT:',
        ['crypto_buy_btn'] = '💰 BUY',
        ['crypto_sell_btn'] = '💵 SELL',
        ['crypto_fee'] = 'Fee:',
        ['crypto_total'] = 'Total:',
        ['crypto_value'] = 'Value:',
        ['crypto_history'] = 'CRYPTO HISTORY',
        ['no_crypto_transactions_text'] = '📝 No crypto transactions available'
    }
}

ESX = nil
local PlayerData = {}
local isNearBank = false
local isNearATM = false
local currentBank = nil
local currentATM = nil
local isBankOpen = false
local stockAddonAvailable = false
local createdBlips = {} -- Tabelle für alle erstellten Blips

-- Banking System
local nuiActive = false

-- ESX Initialization
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
    
    -- Prüfe ob Aktien-Addon verfügbar ist
    CheckStockAddon()
end)

-- Player Data Updates
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

-- Debug-Funktion
function debugLog(message, data)
    if isDebugEnabled('banking') then
        if data then
            print("^2[ZS Banking Debug]^7 " .. tostring(message) .. ": " .. tostring(data))
        else
            print("^2[ZS Banking Debug]^7 " .. tostring(message))
        end
    end
end

-- Aktien Addon Erkennung (deaktiviert in einfacher Config)
function CheckStockAddon()
    -- Aktien-Addon-Erkennung ist in der einfachen Config deaktiviert
    stockAddonAvailable = false
    if isDebugEnabled('banking') then
        print("^3[ZS Banking]^7 Aktien-Addon-Erkennung ist deaktiviert")
    end
end

-- Main Thread for Bank/ATM Detection
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        isNearBank = false
        isNearATM = false
        currentBank = nil
        
        -- Check Main Banks (mit Crypto)
        for i, bank in pairs(Config.Banks) do
            local distance = #(coords - vector3(bank[1], bank[2], bank[3]))
            if distance < Config.Markerbank.Marker.DrawDistance then
                if not isNearBank then
                    isNearBank = true
                    currentBank = {location = bank, type = 'mainBank'}
                end
                break
            end
        end
        
        -- Check ATMs (ohne Crypto)
        for i, atm in pairs(Config.SmallBanks) do
            local distance = #(coords - vector3(atm[1], atm[2], atm[3]))
            if distance < Config.Markeratm.Marker.DrawDistance then
                if not isNearATM then
                    isNearATM = true
                    currentATM = {location = atm, type = 'atm'}
                end
                break
            end
        end
        
        -- Reset Bank status if not near any bank
        if not isNearBank and currentBank then
            isNearBank = false
            currentBank = nil
        end
        
        -- Reset ATM status if not near any ATM
        if not isNearATM and currentATM then
            isNearATM = false
            currentATM = nil
        end
    end
end)

-- Draw Markers and Blips
Citizen.CreateThread(function()
    -- Tabelle für erstellte Blips
    local createdBlips = {}
    
    -- Lösche alle existierenden Banking-Blips zuerst
    local existingBlips = {}
    for i = 1, 100 do -- Durchsuche alle möglichen Blip-IDs
        if DoesBlipExist(i) then
            local blipCoords = GetBlipCoords(i)
            local blipName = GetBlipNameFromPlayerString(i)
            if blipName and (blipName:find("Bank") or blipName:find("ATM")) then
                RemoveBlip(i)
                if isDebugEnabled('blips') then
                    print("^3[ZS Banking]^7 Alten Blip gelöscht: " .. tostring(blipName))
                end
            end
        end
    end

-- Create Main Bank Blips (Grüne Blips für Hauptbanken)
if Config.blipbankon then
    for i, bank in pairs(Config.Banks) do
        local blip = AddBlipForCoord(bank[1], bank[2], bank[3])
        SetBlipSprite(blip, Config.Blipbank.Blip.Sprite or 108) -- Bank Symbol
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blipbank.Blip.Scale or 1.0) -- Größe aus Config
        SetBlipColour(blip, Config.Blipbank.Blip.Colour or 0) -- Farbe aus Config
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blipbank.Blip.Name or "BANK") -- Name aus Config
        EndTextCommandSetBlipName(blip)
        
        -- Speichere Blip-ID
        table.insert(createdBlips, blip)
    end
        if isDebugEnabled('blips') then
            print("^2[ZS Banking]^7 Hauptbank-Blips erstellt: " .. #Config.Banks .. " Hauptbanken")
        end
else
        if isDebugEnabled('blips') then
            print("^3[ZS Banking]^7 Bank-Blips sind deaktiviert")
        end
end

-- Create ATM Blips (Blaue Blips für ATMs)
if Config.blipatmon then
    for i, atm in pairs(Config.SmallBanks) do
        local blip = AddBlipForCoord(atm[1], atm[2], atm[3])
        SetBlipSprite(blip, Config.Blipatm.Blip.Sprite or 277) -- ATM Symbol
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blipatm.Blip.Scale or 1.0) -- Größe aus Config
        SetBlipColour(blip, Config.Blipatm.Blip.Colour or 0) -- Farbe aus Config
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blipatm.Blip.Name or "ATM") -- Name aus Config
        EndTextCommandSetBlipName(blip)
        
        -- Speichere Blip-ID
        table.insert(createdBlips, blip)
    end
        if isDebugEnabled('blips') then
            print("^2[ZS Banking]^7 ATM-Blips erstellt: " .. #Config.SmallBanks .. " ATMs")
        end
else
        if isDebugEnabled('blips') then
            print("^3[ZS Banking]^7 ATM-Blips sind deaktiviert")
        end
end
end)

-- Draw Markers
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if isNearBank or isNearATM then
            local coords = GetEntityCoords(PlayerPedId())
            local drawCoords = nil
            local markerType = nil
            
            if isNearBank and currentBank then
                drawCoords = vector3(currentBank[1], currentBank[2], currentBank[3])
                markerType = "bank"
            elseif isNearATM and currentATM then
                drawCoords = vector3(currentATM[1], currentATM[2], currentATM[3])
                markerType = "atm"
            end
            
            if drawCoords and markerType then
                -- Marker anzeigen basierend auf Typ
                if markerType == "bank" and Config.ShowBankMarkers then
                    DrawMarker(
                        Config.Markerbank.Marker.Type or 1, -- Marker-Typ aus Config
                        drawCoords[1], drawCoords[2], drawCoords[3] - 0.95,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        Config.Markerbank.Marker.Size.x, Config.Markerbank.Marker.Size.y, Config.Markerbank.Marker.Size.z,
                        Config.Markerbank.Marker.Color.r, Config.Markerbank.Marker.Color.g, Config.Markerbank.Marker.Color.b, Config.Markerbank.Marker.Color.a,
                        false, true, 2, false, nil, nil, false
                    )
                end
                
                if markerType == "atm" and Config.ShowATMMarkers then
                    DrawMarker(
                        Config.Markeratm.Marker.Type or 1, -- Marker-Typ aus Config
                        drawCoords[1], drawCoords[2], drawCoords[3] - 0.95,
                        0.0, 0.0, 0.0,
                        0.0, 0.0, 0.0,
                        Config.Markeratm.Marker.Size.x, Config.Markeratm.Marker.Size.y, Config.Markeratm.Marker.Size.z,
                        Config.Markeratm.Marker.Color.r, Config.Markeratm.Marker.Color.g, Config.Markeratm.Marker.Color.b, Config.Markeratm.Marker.Color.a,
                        false, true, 2, false, nil, nil, false
                    )
                end
            end
        end
    end
end)

-- Marker Interaction Thread (E-Taste nur für lokalen Spieler am Marker)
local helpTextShown = false -- Variable um zu tracken ob der Hilfe-Text bereits angezeigt wird

Citizen.CreateThread(function()
    local lastInteractionTime = 0
    local interactionCooldown = 1000 -- 1 Sekunde Cooldown
    
    while true do
        Citizen.Wait(0) -- Reduziert für bessere E-Taste Erkennung
        
        if isNearBank or isNearATM then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local drawCoords = nil
            
            if isNearBank and currentBank then
                drawCoords = vector3(currentBank[1], currentBank[2], currentBank[3])
            elseif isNearATM and currentATM then
                drawCoords = vector3(currentATM[1], currentATM[2], currentATM[3])
            end
            
            if drawCoords then
                local distance = #(coords - drawCoords)
                
                if distance < 1.2 then -- Größere Interaktionsdistanz
                    -- Hilfe-Text nur einmal anzeigen
                    if not helpTextShown then
                        ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um Banking zu öffnen")
                        helpTextShown = true
                    end
                    
                    -- E-Taste überwachen mit Cooldown
                    local currentTime = GetGameTimer()
                    if IsControlJustReleased(0, 38) and (currentTime - lastInteractionTime) > interactionCooldown then -- E key
                        print("^2[ZS Banking]^7 === E-Taste gedrückt ===")
                        print("^2[ZS Banking]^7 isBankOpen:", isBankOpen)
                        print("^2[ZS Banking]^7 nuiActive:", nuiActive)
                        print("^2[ZS Banking]^7 ESX verfügbar:", ESX ~= nil)
                        
                        lastInteractionTime = currentTime
                        
                        if not isBankOpen and not nuiActive then
                            print("^2[ZS Banking]^7 Öffne Banking...")
                            OpenBanking()
                        else
                            print("^3[ZS Banking]^7 Banking bereits geöffnet - schließe...")
                            CloseBanking()
                        end
                    end
                else
                    -- Reset Hilfe-Text wenn zu weit entfernt
                    if helpTextShown then
                        helpTextShown = false
                    end
                end
            else
                -- Reset Hilfe-Text wenn keine Koordinaten
                if helpTextShown then
                    helpTextShown = false
                end
            end
        else
            -- Reset Hilfe-Text wenn nicht in der Nähe
            if helpTextShown then
                helpTextShown = false
            end
            Citizen.Wait(200) -- Weniger häufig prüfen wenn nicht in der Nähe
        end
    end
end)


-- Open Banking Function
function OpenBanking()
    if isBankOpen then 
        print("^3[ZS Banking]^7 Banking ist bereits geöffnet!")
        return 
    end
    
    print("^2[ZS Banking]^7 === OpenBanking aufgerufen ===")
    print("^2[ZS Banking]^7 ESX verfügbar:", ESX ~= nil)
    print("^2[ZS Banking]^7 PlayerData verfügbar:", PlayerData ~= nil)
    
    -- Versuche zuerst lokale ESX-Daten zu verwenden
    if ESX and PlayerData then
        print("^2[ZS Banking]^7 Verwende lokale ESX-Daten...")
        
        -- Lokale Spielerdaten verwenden
        local localData = {
            cash = PlayerData.money or 0,
            bank = PlayerData.accounts and PlayerData.accounts.bank and PlayerData.accounts.bank.money or 0,
            name = PlayerData.name or "Unbekannt",
            transactions = {} -- Leere Transaktionen für lokale Daten
        }
        
        -- Debug: Bankdaten überprüfen
        print("^2[ZS Banking]^7 PlayerData.accounts:", PlayerData.accounts)
        if PlayerData.accounts then
            print("^2[ZS Banking]^7 PlayerData.accounts.bank:", PlayerData.accounts.bank)
            if PlayerData.accounts.bank then
                print("^2[ZS Banking]^7 PlayerData.accounts.bank.money:", PlayerData.accounts.bank.money)
            end
        end
        
        print("^2[ZS Banking]^7 Lokale Daten geladen:")
        print("^2[ZS Banking]^7 - Name:", localData.name)
        print("^2[ZS Banking]^7 - Cash:", localData.cash)
        print("^2[ZS Banking]^7 - Bank:", localData.bank)
        
        -- Banking öffnen mit lokalen Daten
        OpenBankingWithData(localData)
        
        -- Parallel versuchen, aktuelle Daten vom Server zu holen
        TryGetServerData()
        
    else
        print("^3[ZS Banking]^7 Keine lokalen ESX-Daten verfügbar, versuche Server-Callback...")
        TryGetServerData()
    end
end

-- Funktion zum Öffnen des Banking mit Daten
function OpenBankingWithData(data)
    if not data then
        print("^1[ZS Banking ERROR]^7 Keine Daten zum Öffnen des Banking!")
        return
    end
    
    -- Status setzen
    isBankOpen = true
    nuiActive = true
    
    -- Ensure transactions is always an array
    local transactions = data.transactions or {}
    if not transactions or type(transactions) ~= 'table' then
        transactions = {}
        print("^3[ZS Banking]^7 Transaktionen auf leeres Array gesetzt")
    end
    
    print("^2[ZS Banking]^7 Transaktionen verarbeitet:", #transactions)
    
    -- Open NUI
    print("^2[ZS Banking]^7 Öffne NUI...")
    SetNuiFocus(true, true)
    
    -- Prüfe ob das zs_crypto Addon verfügbar ist (Config + Resource-Status)
    local cryptoAddonAvailable = false
    if Config.AddonIntegration and Config.AddonIntegration.zs_crypto then
        -- Prüfe ob das zs_cryptoaddon Resource läuft
        local resourceState = GetResourceState('zs_cryptoaddon')
        if resourceState == 'started' then
            cryptoAddonAvailable = true
            print("^2[ZS Banking]^7 Crypto-Addon verfügbar (Config: true, Resource: started)")
        else
            print("^3[ZS Banking]^7 Crypto-Addon in Config aktiviert, aber Resource nicht gestartet:", resourceState)
        end
    else
        print("^3[ZS Banking]^7 Crypto-Addon in Config deaktiviert")
    end
    
    -- NUI Message mit allen Daten senden
    local nuiData = {
        action = 'openBanking',
        cash = data.cash or 0,
        bank = data.bank or 0,
        name = data.name or "Unbekannt",
        transactions = transactions,
        bankName = Config.BankName,
        language = Config.Language,
        locales = BankingLocales, -- Direkt definierte Übersetzungen
        debug = Config.Debug, -- Debug-Config an NUI senden
        config = Config, -- Vollständige Config an NUI senden
        cryptoAddonAvailable = cryptoAddonAvailable -- Crypto-Addon Status
    }
    
    print("^2[ZS Banking]^7 Sende NUI-Daten:")
    print("^2[ZS Banking]^7 - Name:", nuiData.name)
    print("^2[ZS Banking]^7 - Cash:", nuiData.cash)
    print("^2[ZS Banking]^7 - Bank:", nuiData.bank)
    print("^2[ZS Banking]^7 - Transactions:", #nuiData.transactions)
    print("^2[ZS Banking]^7 - Crypto verfügbar:", nuiData.cryptoAddonAvailable)
    
    SendNUIMessage(nuiData)
    print("^2[ZS Banking]^7 NUI-Daten gesendet - Banking geöffnet!")
end

-- Funktion zum Versuchen, Server-Daten zu holen
function TryGetServerData()
    if not ESX then
        print("^1[ZS Banking ERROR]^7 ESX nicht verfügbar!")
        return
    end
    
    print("^3[ZS Banking]^7 Versuche Server-Daten zu holen...")
    
    -- Trigger Server Event um aktuelle Spielerdaten zu holen
    TriggerServerEvent('zs_banking:requestPlayerData')
end

-- Close Banking Function
function CloseBanking()
    if not isBankOpen then return end
    
    isBankOpen = false
    nuiActive = false
    SetNuiFocus(false, false)
end

-- NUI Callbacks
RegisterNUICallback('closeBanking', function(data, cb)
    CloseBanking()
    cb('ok')
end)

-- AntiFreeze Callback
RegisterNUICallback('ping', function(data, cb)
    lastPing = GetGameTimer()
    cb('pong')
end)

RegisterNUICallback('deposit', function(data, cb)
    local amount = tonumber(data.amount)
    if amount and amount > 0 then
        TriggerServerEvent('bank:deposit', amount)
        cb('ok')
    else
        cb('error')
    end
end)

RegisterNUICallback('withdraw', function(data, cb)
    local amount = tonumber(data.amount)
    if amount and amount > 0 then
        TriggerServerEvent('bank:withdraw', amount)
        cb('ok')
    else
        cb('error')
    end
end)

-- EINFACHER ÜBERWEISUNGSCODE
RegisterNUICallback('transfer', function(data, cb)
    local target = tonumber(data.target)
    local amount = tonumber(data.amount)
    
    if target and amount and amount > 0 then
        -- Einfache Überweisung an Server senden
        TriggerServerEvent('bank:simpleTransfer', target, amount)
        cb('ok')
    else
        cb('error')
    end
end)

-- CRYPTO CALLBACKS (zs_cryptoaddon Integration)
RegisterNUICallback('getCryptoData', function(data, cb)
    -- Erweiterte Crypto-Addon-Überprüfung
    local cryptoStatus = ValidateCryptoAddonClient()
    
    if cryptoStatus.available then
        print("^2[ZS Banking]^7 Crypto-Daten angefordert - leite an zs_cryptoaddon weiter")
        -- Lade alle Crypto-Daten vom echten Addon
        TriggerServerEvent('zs_banking:requestAllCryptoData')
        cb({success = true, message = 'Crypto-Daten werden geladen...'})
    else
        print("^3[ZS Banking]^7 Crypto-Addon nicht verfügbar für getCryptoData")
        print("^3[ZS Banking]^7 - Status:", cryptoStatus.message)
        print("^3[ZS Banking]^7 - Resource State:", cryptoStatus.resource)
        cb({success = false, message = cryptoStatus.message})
    end
end)

-- Client-seitige Crypto-Addon-Validierung
function ValidateCryptoAddonClient()
    local status = {
        available = false,
        resource = GetResourceState('zs_cryptoaddon'),
        message = '',
        details = {}
    }
    
    -- Prüfe Config
    if not Config.AddonIntegration or not Config.AddonIntegration.zs_crypto then
        status.message = 'Crypto-Addon in Config deaktiviert'
        return status
    end
    
    -- Prüfe Resource
    if status.resource ~= 'started' then
        status.message = 'zs_cryptoaddon Resource läuft nicht'
        status.details.resource = false
        return status
    end
    
    -- Prüfe Exports (über Server)
    TriggerServerEvent('zs_banking:getCryptoStatus')
    
    -- Warte auf Server-Response
    local timeout = 0
    while timeout < 50 do -- 5 Sekunden Timeout
        if cryptoStatusResponse then
            status.available = cryptoStatusResponse.available
            status.message = cryptoStatusResponse.message
            status.details = cryptoStatusResponse.functions or {}
            break
        end
        timeout = timeout + 1
        Citizen.Wait(100)
    end
    
    if not cryptoStatusResponse then
        status.message = 'Timeout bei Crypto-Status-Abfrage'
        status.available = false
    end
    
    return status
end

-- Globaler Crypto-Status für Client
local cryptoStatusResponse = nil

RegisterNUICallback('buyCrypto', function(data, cb)
    local amount = tonumber(data.amount)
    local currency = data.cryptoType or 'BTC' -- Standardmäßig Bitcoin
    
    if amount and amount > 0 and currency then
        -- Validiere zuerst den Kauf
        TriggerServerEvent('zs_banking:validateCryptoBuy', currency, amount)
        cb({success = true, message = 'Kauf wird validiert...'})
    else
        cb({success = false, error = 'Ungültige Daten'})
    end
end)

RegisterNUICallback('sellCrypto', function(data, cb)
    local amount = tonumber(data.amount)
    local currency = data.cryptoType or 'BTC' -- Standardmäßig Bitcoin
    
    if amount and amount > 0 and currency then
        -- Validiere zuerst den Verkauf
        TriggerServerEvent('zs_banking:validateCryptoSell', currency, amount)
        cb({success = true, message = 'Verkauf wird validiert...'})
    else
        cb({success = false, error = 'Ungültige Daten'})
    end
end)

-- Server Events
RegisterNetEvent('bank:updateBalances')
AddEventHandler('bank:updateBalances', function(cash, bank, portfolio)
    SendNUIMessage({
        action = 'updateBalances',
        cash = cash,
        bank = bank,
        portfolio = portfolio
    })
end)

-- ========================================
-- BANKING EVENTS
-- ========================================

-- Event Handler für Überweisung abgeschlossen
RegisterNetEvent('bank:transferCompleted')
AddEventHandler('bank:transferCompleted', function(isSender, amount, targetName)
    -- UI aktualisieren
    if isBankOpen then
        SendNUIMessage({
            action = 'transferCompleted',
            isSender = isSender,
            amount = amount,
            targetName = targetName
        })
    end
end)

-- Event Handler für komplette Spielerdaten
RegisterNetEvent('bank:updatePlayerData')
AddEventHandler('bank:updatePlayerData', function(data)
    if data then
        -- Update NUI if open
        if isBankOpen then
            SendNUIMessage({
                action = 'updatePlayerData',
                cash = data.cash,
                bank = data.bank,
                name = data.name,
                transactions = data.transactions
            })
        end
    end
end)

RegisterNetEvent('bank:updateTransactions')
AddEventHandler('bank:updateTransactions', function(transactions)
    -- Update NUI if open
    if isBankOpen then
        SendNUIMessage({
            action = 'updateTransactions',
            transactions = transactions
        })
    end
end)

RegisterNetEvent('bank:updatePremium')
AddEventHandler('bank:updatePremium', function(premium)
    SendNUIMessage({
        action = 'updatePremium',
        premium = premium
    })
end)

RegisterNetEvent('bank:showNotification')
AddEventHandler('bank:showNotification', function(message, type)
    -- Übersetzte Nachricht senden
    local translatedMessage = message
    if BankingLocales and BankingLocales[Config.Language] and BankingLocales[Config.Language][message] then
        translatedMessage = BankingLocales[Config.Language][message]
    end
    
    -- Nur NUI-Benachrichtigung senden (keine doppelten ESX-Benachrichtigungen)
    SendNUIMessage({
        action = 'showNotification',
        message = translatedMessage,
        type = type
    })
end)

-- ========================================
-- CRYPTO SYNCHRONISATION EVENTS
-- ========================================

-- Empfange Crypto-Status vom Server
RegisterNetEvent('zs_banking:receiveCryptoStatus')
AddEventHandler('zs_banking:receiveCryptoStatus', function(status)
    cryptoStatusResponse = status
    print("^2[ZS Banking]^7 Crypto-Status empfangen:", json.encode(status))
    
    -- Benachrichtige NUI über Status-Änderung
    if isBankOpen then
        SendNUIMessage({
            action = 'cryptoStatusUpdate',
            status = status
        })
    end
end)

-- Empfange alle Crypto-Daten vom Server
RegisterNetEvent('zs_banking:receiveAllCryptoData')
AddEventHandler('zs_banking:receiveAllCryptoData', function(data)
    print("^2[ZS Banking]^7 Alle Crypto-Daten empfangen:", json.encode(data))
    
    -- Benachrichtige NUI über neue Daten
    if isBankOpen then
        SendNUIMessage({
            action = 'receiveAllCryptoData',
            data = data
        })
    end
end)

-- Empfange Crypto-Wallet vom Server
RegisterNetEvent('zs_banking:updateCryptoWallet')
AddEventHandler('zs_banking:updateCryptoWallet', function(wallet)
    print("^2[ZS Banking]^7 Crypto-Wallet aktualisiert:", json.encode(wallet))
    
    -- Benachrichtige NUI über Wallet-Update
    if isBankOpen then
        SendNUIMessage({
            action = 'updateCryptoWallet',
            wallet = wallet
        })
    end
end)

-- Empfange Crypto-Transaktionsergebnis vom Server
RegisterNetEvent('zs_banking:cryptoTransactionResult')
AddEventHandler('zs_banking:cryptoTransactionResult', function(result)
    print("^2[ZS Banking]^7 Crypto-Transaktionsergebnis:", json.encode(result))
    
    -- Benachrichtige NUI über Transaktionsergebnis
    if isBankOpen then
        SendNUIMessage({
            action = 'cryptoTransactionResult',
            result = result
        })
    end
    
    -- Zeige Benachrichtigung
    if result.success then
        ESX.ShowNotification('^2✓ ' .. result.message)
    else
        ESX.ShowNotification('^1✗ ' .. result.message)
    end
end)

-- Empfange Crypto-Validierungsergebnis vom Server
RegisterNetEvent('zs_banking:cryptoValidationResult')
AddEventHandler('zs_banking:cryptoValidationResult', function(result)
    print("^2[ZS Banking]^7 Crypto-Validierungsergebnis:", json.encode(result))
    
    if result.success then
        -- Wenn Validierung erfolgreich, führe Transaktion aus
        if result.type == 'buy' then
            TriggerServerEvent('zs_banking:executeCryptoBuy', result.currency, result.amount)
        elseif result.type == 'sell' then
            TriggerServerEvent('zs_banking:executeCryptoSell', result.currency, result.amount)
        end
    else
        -- Zeige Fehlermeldung
        ESX.ShowNotification('^1✗ ' .. result.message)
    end
end)

-- Empfange Crypto-Preise vom Server
RegisterNetEvent('zs_banking:receiveCryptoPrices')
AddEventHandler('zs_banking:receiveCryptoPrices', function(prices)
    -- Benachrichtige NUI über Preis-Update
    if isBankOpen then
        SendNUIMessage({
            action = 'receiveCryptoPrices',
            prices = prices
        })
    end
end)

-- Empfange Crypto-Wettbewerbe vom Server
RegisterNetEvent('zs_banking:receiveCryptoContests')
AddEventHandler('zs_banking:receiveCryptoContests', function(contests)
    print("^2[ZS Banking]^7 Crypto-Wettbewerbe aktualisiert:", json.encode(contests))
    
    -- Benachrichtige NUI über Wettbewerbe-Update
    if isBankOpen then
        SendNUIMessage({
            action = 'receiveCryptoContests',
            contests = contests
        })
    end
end)

-- Empfange Wettbewerb-Beitrittsergebnis vom Server
RegisterNetEvent('zs_banking:contestJoinResult')
AddEventHandler('zs_banking:contestJoinResult', function(result)
    print("^2[ZS Banking]^7 Wettbewerb-Beitrittsergebnis:", json.encode(result))
    
    -- Zeige Benachrichtigung
    if result.success then
        ESX.ShowNotification('^2✓ ' .. result.message)
    else
        ESX.ShowNotification('^1✗ ' .. result.message)
    end
end)

-- ========================================
-- CRYPTO UI INTERACTION EVENTS
-- ========================================

-- NUI Callback für Wettbewerb beitreten
RegisterNUICallback('joinContest', function(data, cb)
    local contestId = data.contestId
    
    if contestId then
        TriggerServerEvent('zs_banking:joinCryptoContest', contestId)
        cb({success = true, message = 'Beitreten wird verarbeitet...'})
    else
        cb({success = false, error = 'Ungültige Wettbewerbs-ID'})
    end
end)

-- NUI Callback für Wettbewerbe abrufen
RegisterNUICallback('requestContests', function(data, cb)
    TriggerServerEvent('zs_banking:requestCryptoContests')
    cb({success = true, message = 'Wettbewerbe werden geladen...'})
end)

-- NUI Callback für Crypto-Daten aktualisieren
RegisterNUICallback('refreshCryptoData', function(data, cb)
    TriggerServerEvent('zs_banking:refreshCryptoData')
    cb({success = true, message = 'Daten werden aktualisiert...'})
end)

-- NUI Callback für Crypto-Preise abrufen
RegisterNUICallback('requestCryptoPrices', function(data, cb)
    TriggerServerEvent('zs_banking:requestCryptoPrices')
    cb({success = true, message = 'Preise werden geladen...'})
end)

-- NUI Callback für Crypto-Wallet abrufen
RegisterNUICallback('requestCryptoWallet', function(data, cb)
    TriggerServerEvent('zs_banking:requestCryptoWallet')
    cb({success = true, message = 'Wallet wird geladen...'})
end)

-- NUI Callback für Contest-Erstellung
RegisterNUICallback('createContest', function(data, cb)
    local contestType = data.type
    local duration = tonumber(data.duration)
    local prizePool = tonumber(data.prizePool)
    
    if not contestType or not duration or not prizePool then
        cb({success = false, error = 'Ungültige Contest-Daten'})
        return
    end
    
    -- Sende Contest-Erstellung an Server
    TriggerServerEvent('zs_banking:createContest', contestType, duration, prizePool)
    cb({success = true, message = 'Contest wird erstellt...'})
end)

-- ========================================
-- CRYPTO TRANSACTION HISTORY
-- ========================================

-- Event-Handler für Crypto-Transaktions-Historie
RegisterNetEvent('zs_banking:receiveCryptoHistory')
AddEventHandler('zs_banking:receiveCryptoHistory', function(transactions)
    SendNUIMessage({
        action = 'updateCryptoHistory',
        transactions = transactions
    })
end)

-- NUI Callback für Crypto-Historie anfordern
RegisterNUICallback('requestCryptoHistory', function(data, cb)
    TriggerServerEvent('zs_banking:requestCryptoHistory')
    cb({success = true})
end)

-- Event-Handler für Crypto-Status
RegisterNetEvent('zs_banking:receiveCryptoStatus')
AddEventHandler('zs_banking:receiveCryptoStatus', function(status)
    -- Sende den Status an die NUI
    SendNUIMessage({
        action = 'updateCryptoStatus',
        status = status
    })
end)

-- Event-Handler für Spielerdaten
RegisterNetEvent('zs_banking:receivePlayerData')
AddEventHandler('zs_banking:receivePlayerData', function(data)
    print("^2[ZS Banking]^7 Spielerdaten vom Server empfangen:", json.encode(data))
    
    -- Banking mit den neuen Daten öffnen
    OpenBankingWithData(data)
end)

-- Event-Handler für Crypto-Informationen
RegisterNetEvent('zs_banking:receiveCryptoInfo')
AddEventHandler('zs_banking:receiveCryptoInfo', function(info)
    -- Sende die Informationen an die NUI
    SendNUIMessage({
        action = 'updateCryptoInfo',
        info = info
    })
end)

-- ========================================
-- EXPORT FUNCTIONS
-- ========================================

-- Chat Command für Banking öffnen
RegisterCommand('banking', function()
    if isNearBank or isNearATM then
        OpenBanking()
    else
        ESX.ShowNotification('Du musst an einer Bank oder einem ATM sein!')
    end
end, false)

-- Export Functions
exports('isNearBank', function()
    return isNearBank
end)

exports('isNearATM', function()
    return isNearATM
end)

exports('openBanking', function()
    OpenBanking()
end)

exports('closeBanking', function()
    CloseBanking()
end)

exports('getCurrentBank', function()
    return currentBank
end)

exports('getBankCode', function()
    -- Banking-Codes sind in der einfachen Config deaktiviert
    if currentBank and currentBank.code then
        return {name = currentBank.name, code = currentBank.code, color = "#28a745"}
    end
    return nil
end)

exports('isStockAddonAvailable', function()
    return stockAddonAvailable
end)

-- Resource Stop Event - Alle Blips löschen
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        -- Lösche alle erstellten Blips
        for _, blipId in pairs(createdBlips) do
            if DoesBlipExist(blipId) then
                RemoveBlip(blipId)
            end
        end
        if isDebugEnabled('blips') then
            print("^3[ZS Banking]^7 Alle Blips gelöscht")
        end
    end
end)

-- Utility Functions
function PlayAnimation(animDict, animName)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, -1, 0, 0, false, false, false)
end

-- ========================================
-- DEBUG FUNCTIONS
-- ========================================

-- Debug-Funktion
function isDebugEnabled(type)
    return false -- Debug ist standardmäßig deaktiviert
end

-- ========================================
-- CRYPTO HEARTBEAT SYSTEM
-- ========================================

-- Crypto-Addon Heartbeat (alle 30 Sekunden)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30000) -- 30 Sekunden
        
        if Config.AddonIntegration and Config.AddonIntegration.zs_crypto then
            local resourceState = GetResourceState('zs_cryptoaddon')
            
            if resourceState == 'started' then
                -- Resource läuft - prüfe Exports
                TriggerServerEvent('zs_banking:getCryptoStatus')
            else
                print("^3[ZS Banking]^7 Crypto-Addon Resource nicht verfügbar:", resourceState)
                -- Benachrichtige NUI
                if isBankOpen then
                    SendNUIMessage({
                        action = 'cryptoStatusUpdate',
                        status = {
                            available = false,
                            resource = resourceState,
                            message = 'Crypto-Addon Resource läuft nicht'
                        }
                    })
                end
            end
        end
    end
end)