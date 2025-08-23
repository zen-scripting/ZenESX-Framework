-- =======================================
-- ZENESX FRAMEWORK CLIENT UPDATE NOTIFICATIONS
-- =======================================

local UpdateNotifications = {}
UpdateNotifications.Config = {
    -- Notification Settings
    ShowNotifications = true,
    NotificationDuration = 15000, -- 15 Sekunden
    PlaySound = true,
    
    -- UI Settings
    NotificationPosition = "top-right",
    UseNativeNotifications = false, -- true = GTA Native, false = Custom UI
    
    -- Sound Settings
    SoundName = "CHECKPOINT_PERFECT",
    SoundSet = "HUD_MINI_GAME_SOUNDSET"
}

-- =======================================
-- CLIENT EVENTS
-- =======================================

RegisterNetEvent('zenesx:updateNotification')
AddEventHandler('zenesx:updateNotification', function(updateData)
    if not UpdateNotifications.Config.ShowNotifications then return end
    
    UpdateNotifications:ShowUpdateNotification(updateData)
end)

-- =======================================
-- NOTIFICATION FUNCTIONS
-- =======================================

function UpdateNotifications:ShowUpdateNotification(updateData)
    local message = string.format(
        "🚀 ZenESX Framework Update verfügbar!\n\n" ..
        "📦 Neue Version: v%s\n" ..
        "📋 Aktuelle Version: v%s\n\n" ..
        "💡 Drücke F1 für txAdmin um das Update zu installieren",
        updateData.latestVersion,
        updateData.currentVersion
    )
    
    if self.Config.UseNativeNotifications then
        self:ShowNativeNotification(message)
    else
        self:ShowCustomNotification(updateData)
    end
    
    -- Sound abspielen
    if self.Config.PlaySound then
        PlaySoundFrontend(-1, self.Config.SoundName, self.Config.SoundSet, true)
    end
    
    -- Chat-Nachricht
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 127},
        multiline = true,
        args = {"🚀 ZenESX Update", "Neue Version v" .. updateData.latestVersion .. " verfügbar! Besuche: " .. updateData.downloadUrl}
    })
end

function UpdateNotifications:ShowNativeNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

function UpdateNotifications:ShowCustomNotification(updateData)
    -- Custom NUI Notification (wenn implementiert)
    SendNUIMessage({
        type = "updateNotification",
        data = {
            title = "ZenESX Framework Update",
            message = string.format("Neue Version v%s verfügbar!", updateData.latestVersion),
            currentVersion = updateData.currentVersion,
            latestVersion = updateData.latestVersion,
            downloadUrl = updateData.downloadUrl,
            duration = self.Config.NotificationDuration,
            position = self.Config.NotificationPosition
        }
    })
end

-- =======================================
-- COMMANDS
-- =======================================

RegisterCommand('zenesx:updates', function(source, args, rawCommand)
    TriggerServerEvent('zenesx:requestUpdateCheck')
end, false)

-- Hilfemenü
RegisterCommand('zenesx:help', function(source, args, rawCommand)
    local helpMessage = {
        "^2========================================^7",
        "^2     ZenESX Framework - Befehle       ^7",
        "^2========================================^7",
        "^3/zenesx:updates^7 - Update-Status prüfen",
        "^3/zenesx:version^7 - Aktuelle Version anzeigen",
        "^3/zenesx:help^7 - Diese Hilfe anzeigen",
        "^2========================================^7"
    }
    
    for _, line in ipairs(helpMessage) do
        TriggerEvent('chat:addMessage', {
            color = {255, 255, 255},
            multiline = false,
            args = {"", line}
        })
    end
end, false)

-- =======================================
-- STARTUP MESSAGE
-- =======================================

Citizen.CreateThread(function()
    Wait(5000) -- Warte bis der Spieler vollständig geladen ist
    
    -- Willkommensnachricht
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 127},
        multiline = true,
        args = {
            "🚀 ZenESX Framework", 
            "Willkommen! Verwende /zenesx:help für verfügbare Befehle."
        }
    })
end)
