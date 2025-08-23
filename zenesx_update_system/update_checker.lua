-- =======================================
-- ZENESX FRAMEWORK UPDATE CHECKER
-- GitHub Integration für automatische Updates
-- =======================================

local UpdateChecker = {}
UpdateChecker.Config = {
    -- GitHub Repository Information
    GitHubUser = "zenscripts",
    GitHubRepo = "zenesx-framework",
    GitHubBranch = "main",
    
    -- Current Version (wird automatisch aus fxmanifest.lua gelesen)
    CurrentVersion = "1.0.0",
    
    -- Update Check Settings
    CheckInterval = 3600000, -- 1 Stunde in Millisekunden
    EnableAutoCheck = true,
    EnableNotifications = true,
    
    -- txAdmin Integration
    TxAdminIntegration = true,
    NotifyAdmins = true,
    
    -- URLs
    GitHubAPI = "https://api.github.com/repos/%s/%s/releases/latest",
    GitHubReleases = "https://github.com/%s/%s/releases",
    DownloadURL = "https://github.com/%s/%s/archive/refs/heads/%s.zip"
}

-- =======================================
-- UPDATE CHECKER FUNCTIONS
-- =======================================

function UpdateChecker:GetCurrentVersion()
    local manifestPath = GetResourcePath(GetCurrentResourceName()) .. "/fxmanifest.lua"
    local file = io.open(manifestPath, "r")
    
    if file then
        local content = file:read("*a")
        file:close()
        
        local version = content:match("version%s+['\"]([^'\"]+)['\"]")
        return version or self.Config.CurrentVersion
    end
    
    return self.Config.CurrentVersion
end

function UpdateChecker:CheckForUpdates()
    local apiUrl = string.format(
        self.Config.GitHubAPI,
        self.Config.GitHubUser,
        self.Config.GitHubRepo
    )
    
    PerformHttpRequest(apiUrl, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            if data and data.tag_name then
                self:CompareVersions(data)
            end
        else
            print("^3[ZenESX Update] ^7Fehler beim Abrufen der GitHub-Daten: " .. statusCode)
        end
    end, "GET", "", {
        ["User-Agent"] = "ZenESX-Framework-UpdateChecker"
    })
end

function UpdateChecker:CompareVersions(releaseData)
    local currentVersion = self:GetCurrentVersion()
    local latestVersion = releaseData.tag_name:gsub("^v", "") -- Entferne 'v' prefix
    
    if self:IsNewerVersion(latestVersion, currentVersion) then
        self:NotifyUpdate(releaseData, currentVersion, latestVersion)
    else
        print("^2[ZenESX Update] ^7Framework ist auf dem neuesten Stand (v" .. currentVersion .. ")")
    end
end

function UpdateChecker:IsNewerVersion(latest, current)
    local function parseVersion(version)
        local parts = {}
        for part in version:gmatch("(%d+)") do
            table.insert(parts, tonumber(part))
        end
        return parts
    end
    
    local latestParts = parseVersion(latest)
    local currentParts = parseVersion(current)
    
    for i = 1, math.max(#latestParts, #currentParts) do
        local latestPart = latestParts[i] or 0
        local currentPart = currentParts[i] or 0
        
        if latestPart > currentPart then
            return true
        elseif latestPart < currentPart then
            return false
        end
    end
    
    return false
end

function UpdateChecker:NotifyUpdate(releaseData, currentVersion, latestVersion)
    local updateMessage = string.format(
        "^3[ZenESX Update] ^2Neue Version verfügbar!^7\n" ..
        "^7Aktuelle Version: ^1v%s^7\n" ..
        "^7Neue Version: ^2v%s^7\n" ..
        "^7Veröffentlicht: ^3%s^7\n" ..
        "^7Download: ^4%s^7",
        currentVersion,
        latestVersion,
        releaseData.published_at:gsub("T", " "):gsub("Z", ""),
        string.format(self.Config.GitHubReleases, self.Config.GitHubUser, self.Config.GitHubRepo)
    )
    
    print(updateMessage)
    
    -- txAdmin Benachrichtigung
    if self.Config.TxAdminIntegration then
        self:SendTxAdminNotification(releaseData, currentVersion, latestVersion)
    end
    
    -- Admin Benachrichtigungen
    if self.Config.NotifyAdmins then
        self:NotifyAdmins(releaseData, currentVersion, latestVersion)
    end
end

function UpdateChecker:SendTxAdminNotification(releaseData, currentVersion, latestVersion)
    -- txAdmin Event für Update-Benachrichtigung
    TriggerEvent('txAdmin:events:announcement', {
        type = 'info',
        title = 'ZenESX Framework Update',
        message = string.format(
            'Neue Version v%s verfügbar! (Aktuelle: v%s)\n\n%s\n\nDownload: %s',
            latestVersion,
            currentVersion,
            releaseData.body or 'Keine Beschreibung verfügbar.',
            string.format(self.Config.GitHubReleases, self.Config.GitHubUser, self.Config.GitHubRepo)
        ),
        author = 'ZenESX Update Checker'
    })
end

function UpdateChecker:NotifyAdmins(releaseData, currentVersion, latestVersion)
    local admins = GetPlayers()
    
    for _, playerId in ipairs(admins) do
        if IsPlayerAceAllowed(playerId, "command.txadmin") then
            TriggerClientEvent('zenesx:updateNotification', playerId, {
                currentVersion = currentVersion,
                latestVersion = latestVersion,
                releaseData = releaseData,
                downloadUrl = string.format(self.Config.GitHubReleases, self.Config.GitHubUser, self.Config.GitHubRepo)
            })
        end
    end
end

function UpdateChecker:StartAutoCheck()
    if not self.Config.EnableAutoCheck then return end
    
    print("^2[ZenESX Update] ^7Update-Checker gestartet (Intervall: " .. (self.Config.CheckInterval / 1000 / 60) .. " Minuten)")
    
    -- Erster Check nach 30 Sekunden
    SetTimeout(30000, function()
        self:CheckForUpdates()
    end)
    
    -- Dann regelmäßige Checks
    SetInterval(function()
        self:CheckForUpdates()
    end, self.Config.CheckInterval)
end

-- =======================================
-- CONSOLE COMMANDS
-- =======================================

RegisterCommand('zenesx:checkupdate', function(source, args, rawCommand)
    if source ~= 0 and not IsPlayerAceAllowed(source, "command.txadmin") then
        return
    end
    
    print("^3[ZenESX Update] ^7Manuelle Update-Prüfung gestartet...")
    UpdateChecker:CheckForUpdates()
end, true)

RegisterCommand('zenesx:version', function(source, args, rawCommand)
    local currentVersion = UpdateChecker:GetCurrentVersion()
    local message = "^2[ZenESX Framework] ^7Version: ^3v" .. currentVersion
    
    if source == 0 then
        print(message)
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 255},
            multiline = true,
            args = {"ZenESX", "Version: v" .. currentVersion}
        })
    end
end, false)

-- =======================================
-- INITIALIZATION
-- =======================================

Citizen.CreateThread(function()
    -- Warte bis der Server vollständig geladen ist
    Wait(5000)
    
    print("^2========================================^7")
    print("^2     ZenESX Framework Update Checker  ^7")
    print("^2     GitHub Integration Active        ^7")
    print("^2     Version: " .. UpdateChecker:GetCurrentVersion() .. "                    ^7")
    print("^2========================================^7")
    
    -- Starte automatische Update-Checks
    UpdateChecker:StartAutoCheck()
end)

-- Export für andere Resources
exports('checkForUpdates', function()
    UpdateChecker:CheckForUpdates()
end)

exports('getCurrentVersion', function()
    return UpdateChecker:GetCurrentVersion()
end)
