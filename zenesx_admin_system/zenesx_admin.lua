-- =======================================
-- ZENESX FRAMEWORK ADMIN SYSTEM
-- Erweiterte Admin-Funktionen
-- =======================================

local ZenAdmin = {}
ZenAdmin.Config = {
    -- Admin Levels
    AdminLevels = {
        ['god'] = 5,        -- Vollzugriff
        ['admin'] = 4,      -- Administrative Befehle
        ['mod'] = 3,        -- Moderator Befehle
        ['helper'] = 2,     -- Hilfs-Befehle
        ['user'] = 1        -- Standard-Spieler
    },
    
    -- Logging
    EnableLogging = true,
    LogWebhook = "", -- Discord Webhook für Admin-Logs
    
    -- UI Settings
    AdminMenuKey = 166, -- F5
    ShowNotifications = true,
    
    -- Security
    AntiCheatIntegration = true,
    LogAllCommands = true
}

-- =======================================
-- ADMIN FUNCTIONS
-- =======================================

function ZenAdmin:GetPlayerAdminLevel(playerId)
    local identifier = ESX.GetPlayerFromId(playerId).identifier
    
    -- Check ACE permissions
    if IsPlayerAceAllowed(playerId, "zenesx.god") then
        return 5
    elseif IsPlayerAceAllowed(playerId, "zenesx.admin") then
        return 4
    elseif IsPlayerAceAllowed(playerId, "zenesx.mod") then
        return 3
    elseif IsPlayerAceAllowed(playerId, "zenesx.helper") then
        return 2
    else
        return 1
    end
end

function ZenAdmin:HasPermission(playerId, requiredLevel)
    local playerLevel = self:GetPlayerAdminLevel(playerId)
    return playerLevel >= requiredLevel
end

function ZenAdmin:LogAction(playerId, action, target, reason)
    if not self.Config.EnableLogging then return end
    
    local playerName = GetPlayerName(playerId)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local targetName = target and GetPlayerName(target) or "N/A"
    
    local logMessage = string.format(
        "[%s] %s (%s) - %s - Target: %s (%s) - Reason: %s",
        timestamp,
        playerName,
        playerId,
        action,
        targetName,
        target or "N/A",
        reason or "Kein Grund angegeben"
    )
    
    print("^3[ZenESX Admin] " .. logMessage .. "^7")
    
    -- Discord Webhook (wenn konfiguriert)
    if self.Config.LogWebhook and self.Config.LogWebhook ~= "" then
        self:SendDiscordLog(logMessage)
    end
end

function ZenAdmin:SendDiscordLog(message)
    local embed = {
        {
            ["title"] = "ZenESX Admin Log",
            ["description"] = message,
            ["color"] = 3447003,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    
    PerformHttpRequest(self.Config.LogWebhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = embed,
        username = "ZenESX Framework"
    }), { ['Content-Type'] = 'application/json' })
end

-- =======================================
-- ADMIN COMMANDS
-- =======================================

-- Teleport Commands
RegisterCommand('tp', function(source, args, rawCommand)
    if not ZenAdmin:HasPermission(source, 3) then
        TriggerClientEvent('esx:showNotification', source, '~r~Keine Berechtigung!')
        return
    end
    
    if args[1] then
        local targetId = tonumber(args[1])
        if GetPlayerPed(targetId) then
            TriggerClientEvent('zenesx:teleportToPlayer', source, targetId)
            ZenAdmin:LogAction(source, "TELEPORT_TO_PLAYER", targetId)
            TriggerClientEvent('esx:showNotification', source, '~g~Zu Spieler teleportiert!')
        else
            TriggerClientEvent('esx:showNotification', source, '~r~Spieler nicht gefunden!')
        end
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Verwendung: /tp [PlayerID]')
    end
end, false)

-- Bring Command
RegisterCommand('bring', function(source, args, rawCommand)
    if not ZenAdmin:HasPermission(source, 3) then
        TriggerClientEvent('esx:showNotification', source, '~r~Keine Berechtigung!')
        return
    end
    
    if args[1] then
        local targetId = tonumber(args[1])
        if GetPlayerPed(targetId) then
            TriggerClientEvent('zenesx:teleportToPlayer', targetId, source)
            ZenAdmin:LogAction(source, "BRING_PLAYER", targetId)
            TriggerClientEvent('esx:showNotification', source, '~g~Spieler zu dir teleportiert!')
            TriggerClientEvent('esx:showNotification', targetId, '~y~Du wurdest zu einem Admin teleportiert!')
        else
            TriggerClientEvent('esx:showNotification', source, '~r~Spieler nicht gefunden!')
        end
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Verwendung: /bring [PlayerID]')
    end
end, false)

-- Kick Command
RegisterCommand('zkick', function(source, args, rawCommand)
    if not ZenAdmin:HasPermission(source, 3) then
        TriggerClientEvent('esx:showNotification', source, '~r~Keine Berechtigung!')
        return
    end
    
    if args[1] then
        local targetId = tonumber(args[1])
        local reason = table.concat(args, " ", 2) or "Kein Grund angegeben"
        
        if GetPlayerPed(targetId) then
            DropPlayer(targetId, "Du wurdest vom Server gekickt. Grund: " .. reason)
            ZenAdmin:LogAction(source, "KICK", targetId, reason)
            TriggerClientEvent('esx:showNotification', source, '~g~Spieler gekickt!')
        else
            TriggerClientEvent('esx:showNotification', source, '~r~Spieler nicht gefunden!')
        end
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Verwendung: /zkick [PlayerID] [Grund]')
    end
end, false)

-- Heal Command
RegisterCommand('heal', function(source, args, rawCommand)
    if not ZenAdmin:HasPermission(source, 2) then
        TriggerClientEvent('esx:showNotification', source, '~r~Keine Berechtigung!')
        return
    end
    
    if args[1] then
        local targetId = tonumber(args[1])
        if GetPlayerPed(targetId) then
            TriggerClientEvent('zenesx:healPlayer', targetId)
            ZenAdmin:LogAction(source, "HEAL_PLAYER", targetId)
            TriggerClientEvent('esx:showNotification', source, '~g~Spieler geheilt!')
            TriggerClientEvent('esx:showNotification', targetId, '~g~Du wurdest von einem Admin geheilt!')
        else
            TriggerClientEvent('esx:showNotification', source, '~r~Spieler nicht gefunden!')
        end
    else
        -- Heile sich selbst
        TriggerClientEvent('zenesx:healPlayer', source)
        ZenAdmin:LogAction(source, "HEAL_SELF", source)
        TriggerClientEvent('esx:showNotification', source, '~g~Du hast dich selbst geheilt!')
    end
end, false)

-- Revive Command
RegisterCommand('revive', function(source, args, rawCommand)
    if not ZenAdmin:HasPermission(source, 2) then
        TriggerClientEvent('esx:showNotification', source, '~r~Keine Berechtigung!')
        return
    end
    
    if args[1] then
        local targetId = tonumber(args[1])
        if GetPlayerPed(targetId) then
            TriggerClientEvent('esx_ambulancejob:revive', targetId)
            ZenAdmin:LogAction(source, "REVIVE_PLAYER", targetId)
            TriggerClientEvent('esx:showNotification', source, '~g~Spieler wiederbelebt!')
            TriggerClientEvent('esx:showNotification', targetId, '~g~Du wurdest von einem Admin wiederbelebt!')
        else
            TriggerClientEvent('esx:showNotification', source, '~r~Spieler nicht gefunden!')
        end
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Verwendung: /revive [PlayerID]')
    end
end, false)

-- Give Money Command
RegisterCommand('givemoney', function(source, args, rawCommand)
    if not ZenAdmin:HasPermission(source, 4) then
        TriggerClientEvent('esx:showNotification', source, '~r~Keine Berechtigung!')
        return
    end
    
    if args[1] and args[2] and args[3] then
        local targetId = tonumber(args[1])
        local account = args[2] -- money, bank, black_money
        local amount = tonumber(args[3])
        
        if GetPlayerPed(targetId) and amount > 0 then
            local xTarget = ESX.GetPlayerFromId(targetId)
            if xTarget then
                xTarget.addAccountMoney(account, amount)
                ZenAdmin:LogAction(source, "GIVE_MONEY", targetId, account .. ": $" .. amount)
                TriggerClientEvent('esx:showNotification', source, '~g~Geld gegeben: $' .. amount .. ' (' .. account .. ')')
                TriggerClientEvent('esx:showNotification', targetId, '~g~Du hast $' .. amount .. ' erhalten!')
            end
        else
            TriggerClientEvent('esx:showNotification', source, '~r~Ungültige Parameter!')
        end
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Verwendung: /givemoney [PlayerID] [Account] [Amount]')
    end
end, false)

-- Set Job Command
RegisterCommand('setjob', function(source, args, rawCommand)
    if not ZenAdmin:HasPermission(source, 4) then
        TriggerClientEvent('esx:showNotification', source, '~r~Keine Berechtigung!')
        return
    end
    
    if args[1] and args[2] then
        local targetId = tonumber(args[1])
        local job = args[2]
        local grade = tonumber(args[3]) or 0
        
        if GetPlayerPed(targetId) then
            local xTarget = ESX.GetPlayerFromId(targetId)
            if xTarget then
                xTarget.setJob(job, grade)
                ZenAdmin:LogAction(source, "SET_JOB", targetId, job .. " (Grade: " .. grade .. ")")
                TriggerClientEvent('esx:showNotification', source, '~g~Job gesetzt: ' .. job)
                TriggerClientEvent('esx:showNotification', targetId, '~g~Dein Job wurde geändert: ' .. job)
            end
        else
            TriggerClientEvent('esx:showNotification', source, '~r~Spieler nicht gefunden!')
        end
    else
        TriggerClientEvent('esx:showNotification', source, '~r~Verwendung: /setjob [PlayerID] [Job] [Grade]')
    end
end, false)

-- Noclip Command
RegisterCommand('noclip', function(source, args, rawCommand)
    if not ZenAdmin:HasPermission(source, 3) then
        TriggerClientEvent('esx:showNotification', source, '~r~Keine Berechtigung!')
        return
    end
    
    TriggerClientEvent('zenesx:toggleNoclip', source)
    ZenAdmin:LogAction(source, "TOGGLE_NOCLIP", source)
end, false)

-- Invisible Command
RegisterCommand('invisible', function(source, args, rawCommand)
    if not ZenAdmin:HasPermission(source, 3) then
        TriggerClientEvent('esx:showNotification', source, '~r~Keine Berechtigung!')
        return
    end
    
    TriggerClientEvent('zenesx:toggleInvisible', source)
    ZenAdmin:LogAction(source, "TOGGLE_INVISIBLE", source)
end, false)

-- Player List Command
RegisterCommand('players', function(source, args, rawCommand)
    if not ZenAdmin:HasPermission(source, 2) then
        TriggerClientEvent('esx:showNotification', source, '~r~Keine Berechtigung!')
        return
    end
    
    local players = ESX.GetPlayers()
    local playerList = "^2=== Online Spieler ===^7\n"
    
    for i=1, #players, 1 do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        if xPlayer then
            playerList = playerList .. string.format(
                "^3[%s]^7 %s (Job: %s)\n", 
                players[i], 
                xPlayer.getName(), 
                xPlayer.job.label
            )
        end
    end
    
    TriggerClientEvent('chat:addMessage', source, {
        color = {255, 255, 255},
        multiline = true,
        args = {"", playerList}
    })
end, false)

-- =======================================
-- SERVER EVENTS
-- =======================================

RegisterServerEvent('zenesx:requestAdminMenu')
AddEventHandler('zenesx:requestAdminMenu', function()
    local source = source
    if ZenAdmin:HasPermission(source, 2) then
        local adminLevel = ZenAdmin:GetPlayerAdminLevel(source)
        TriggerClientEvent('zenesx:openAdminMenu', source, adminLevel)
    end
end)

-- =======================================
-- INITIALIZATION
-- =======================================

Citizen.CreateThread(function()
    print("^2[ZenESX Admin] ^7Admin-System geladen!")
    print("^3[ZenESX Admin] ^7Verfügbare Befehle: /tp, /bring, /zkick, /heal, /revive, /givemoney, /setjob, /noclip, /invisible, /players")
end)
