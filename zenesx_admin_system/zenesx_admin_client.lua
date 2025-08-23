-- =======================================
-- ZENESX FRAMEWORK ADMIN CLIENT
-- Client-seitige Admin-Funktionen
-- =======================================

local AdminClient = {}
AdminClient.Config = {
    AdminMenuKey = 166, -- F5
    NoclipSpeed = 2.0,
    IsNoclipActive = false,
    IsInvisible = false,
    AdminMenuOpen = false
}

-- =======================================
-- ADMIN MENU
-- =======================================

function AdminClient:OpenAdminMenu(adminLevel)
    if self.Config.AdminMenuOpen then return end
    
    self.Config.AdminMenuOpen = true
    
    local elements = {}
    
    -- Helper+ Commands
    if adminLevel >= 2 then
        table.insert(elements, {label = '👤 Spieler heilen', value = 'heal'})
        table.insert(elements, {label = '💀 Spieler wiederbeleben', value = 'revive'})
        table.insert(elements, {label = '📋 Spielerliste', value = 'players'})
    end
    
    -- Moderator+ Commands
    if adminLevel >= 3 then
        table.insert(elements, {label = '🚀 Teleportieren', value = 'teleport'})
        table.insert(elements, {label = '📞 Spieler zu mir', value = 'bring'})
        table.insert(elements, {label = '👻 Noclip', value = 'noclip'})
        table.insert(elements, {label = '🫥 Unsichtbar', value = 'invisible'})
        table.insert(elements, {label = '👢 Spieler kicken', value = 'kick'})
    end
    
    -- Admin+ Commands
    if adminLevel >= 4 then
        table.insert(elements, {label = '💰 Geld geben', value = 'givemoney'})
        table.insert(elements, {label = '💼 Job setzen', value = 'setjob'})
        table.insert(elements, {label = '🔧 Server Management', value = 'server'})
    end
    
    -- God Commands
    if adminLevel >= 5 then
        table.insert(elements, {label = '⚡ God Mode', value = 'god'})
        table.insert(elements, {label = '🌍 World Management', value = 'world'})
    end
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'admin_menu', {
        title = 'ZenESX Admin Menu',
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        self:HandleMenuAction(data.current.value, adminLevel)
    end, function(data, menu)
        menu.close()
        self.Config.AdminMenuOpen = false
    end)
end

function AdminClient:HandleMenuAction(action, adminLevel)
    if action == 'heal' then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'heal_player', {
            title = 'Spieler ID zum Heilen (leer = selbst)'
        }, function(data, menu)
            local playerId = tonumber(data.value) or GetPlayerId()
            ExecuteCommand('heal ' .. playerId)
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
        
    elseif action == 'revive' then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'revive_player', {
            title = 'Spieler ID zum Wiederbeleben'
        }, function(data, menu)
            if data.value and data.value ~= '' then
                ExecuteCommand('revive ' .. data.value)
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
        
    elseif action == 'teleport' then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'teleport_player', {
            title = 'Spieler ID (zu dem teleportiert werden soll)'
        }, function(data, menu)
            if data.value and data.value ~= '' then
                ExecuteCommand('tp ' .. data.value)
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
        
    elseif action == 'bring' then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'bring_player', {
            title = 'Spieler ID (der zu dir teleportiert werden soll)'
        }, function(data, menu)
            if data.value and data.value ~= '' then
                ExecuteCommand('bring ' .. data.value)
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
        
    elseif action == 'kick' then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'kick_player', {
            title = 'Format: PlayerID Grund'
        }, function(data, menu)
            if data.value and data.value ~= '' then
                ExecuteCommand('zkick ' .. data.value)
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
        
    elseif action == 'givemoney' then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'give_money', {
            title = 'Format: PlayerID Account Amount (z.B. 1 bank 5000)'
        }, function(data, menu)
            if data.value and data.value ~= '' then
                ExecuteCommand('givemoney ' .. data.value)
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
        
    elseif action == 'setjob' then
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'set_job', {
            title = 'Format: PlayerID Job Grade (z.B. 1 police 2)'
        }, function(data, menu)
            if data.value and data.value ~= '' then
                ExecuteCommand('setjob ' .. data.value)
            end
            menu.close()
        end, function(data, menu)
            menu.close()
        end)
        
    elseif action == 'noclip' then
        ExecuteCommand('noclip')
        
    elseif action == 'invisible' then
        ExecuteCommand('invisible')
        
    elseif action == 'players' then
        ExecuteCommand('players')
        
    end
    
    -- Menu nach Aktion schließen
    ESX.UI.Menu.CloseAll()
    self.Config.AdminMenuOpen = false
end

-- =======================================
-- NOCLIP SYSTEM
-- =======================================

function AdminClient:ToggleNoclip()
    self.Config.IsNoclipActive = not self.Config.IsNoclipActive
    local ped = PlayerPedId()
    
    if self.Config.IsNoclipActive then
        SetEntityCollision(ped, false, false)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetPedCanRagdoll(ped, false)
        ESX.ShowNotification('~g~Noclip aktiviert')
        
        -- Noclip Thread
        Citizen.CreateThread(function()
            while self.Config.IsNoclipActive do
                Citizen.Wait(0)
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local heading = GetEntityHeading(ped)
                
                -- Movement
                if IsControlPressed(0, 32) then -- W
                    local newCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, self.Config.NoclipSpeed, 0.0)
                    SetEntityCoordsNoOffset(ped, newCoords.x, newCoords.y, newCoords.z, true, true, true)
                end
                
                if IsControlPressed(0, 33) then -- S
                    local newCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, -self.Config.NoclipSpeed, 0.0)
                    SetEntityCoordsNoOffset(ped, newCoords.x, newCoords.y, newCoords.z, true, true, true)
                end
                
                if IsControlPressed(0, 34) then -- A
                    local newCoords = GetOffsetFromEntityInWorldCoords(ped, -self.Config.NoclipSpeed, 0.0, 0.0)
                    SetEntityCoordsNoOffset(ped, newCoords.x, newCoords.y, newCoords.z, true, true, true)
                end
                
                if IsControlPressed(0, 35) then -- D
                    local newCoords = GetOffsetFromEntityInWorldCoords(ped, self.Config.NoclipSpeed, 0.0, 0.0)
                    SetEntityCoordsNoOffset(ped, newCoords.x, newCoords.y, newCoords.z, true, true, true)
                end
                
                -- Up/Down
                if IsControlPressed(0, 21) then -- Shift (Up)
                    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z + self.Config.NoclipSpeed, true, true, true)
                end
                
                if IsControlPressed(0, 36) then -- Ctrl (Down)
                    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z - self.Config.NoclipSpeed, true, true, true)
                end
                
                -- Speed Control
                if IsControlPressed(0, 19) then -- Alt (Fast)
                    self.Config.NoclipSpeed = 5.0
                else
                    self.Config.NoclipSpeed = 2.0
                end
            end
        end)
        
    else
        SetEntityCollision(ped, true, true)
        FreezeEntityPosition(ped, false)
        SetEntityInvincible(ped, false)
        SetPedCanRagdoll(ped, true)
        ESX.ShowNotification('~r~Noclip deaktiviert')
    end
end

-- =======================================
-- INVISIBLE SYSTEM
-- =======================================

function AdminClient:ToggleInvisible()
    self.Config.IsInvisible = not self.Config.IsInvisible
    local ped = PlayerPedId()
    
    if self.Config.IsInvisible then
        SetEntityVisible(ped, false, false)
        SetLocalPlayerVisibleLocally(true)
        ESX.ShowNotification('~g~Unsichtbar aktiviert')
    else
        SetEntityVisible(ped, true, false)
        ESX.ShowNotification('~r~Unsichtbar deaktiviert')
    end
end

-- =======================================
-- HEAL PLAYER
-- =======================================

function AdminClient:HealPlayer()
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    SetPedArmour(ped, 100)
    ClearPedBloodDamage(ped)
    ESX.ShowNotification('~g~Du wurdest geheilt!')
end

-- =======================================
-- TELEPORT SYSTEM
-- =======================================

function AdminClient:TeleportToPlayer(targetId)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    if targetPed and targetPed ~= 0 then
        local coords = GetEntityCoords(targetPed)
        SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z + 1.0, true, true, true)
    end
end

-- =======================================
-- EVENTS
-- =======================================

RegisterNetEvent('zenesx:openAdminMenu')
AddEventHandler('zenesx:openAdminMenu', function(adminLevel)
    AdminClient:OpenAdminMenu(adminLevel)
end)

RegisterNetEvent('zenesx:toggleNoclip')
AddEventHandler('zenesx:toggleNoclip', function()
    AdminClient:ToggleNoclip()
end)

RegisterNetEvent('zenesx:toggleInvisible')
AddEventHandler('zenesx:toggleInvisible', function()
    AdminClient:ToggleInvisible()
end)

RegisterNetEvent('zenesx:healPlayer')
AddEventHandler('zenesx:healPlayer', function()
    AdminClient:HealPlayer()
end)

RegisterNetEvent('zenesx:teleportToPlayer')
AddEventHandler('zenesx:teleportToPlayer', function(targetId)
    AdminClient:TeleportToPlayer(targetId)
end)

-- =======================================
-- KEY BINDINGS
-- =======================================

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- F5 für Admin Menu
        if IsControlJustPressed(0, AdminClient.Config.AdminMenuKey) then
            TriggerServerEvent('zenesx:requestAdminMenu')
        end
    end
end)

-- =======================================
-- INITIALIZATION
-- =======================================

Citizen.CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Citizen.Wait(100)
    end
    
    print("^2[ZenESX Admin Client] ^7Admin-Client geladen! Drücke F5 für das Admin-Menü.")
end)
