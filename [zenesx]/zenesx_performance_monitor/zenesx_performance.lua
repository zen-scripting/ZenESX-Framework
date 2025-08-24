-- =======================================
-- ZENESX FRAMEWORK PERFORMANCE MONITOR
-- Server Performance & Monitoring System
-- =======================================

local PerformanceMonitor = {}
PerformanceMonitor.Config = {
    -- Monitoring Settings
    EnableMonitoring = true,
    MonitorInterval = 30000, -- 30 Sekunden
    LogPerformance = true,
    
    -- Alert Thresholds
    MaxTickTime = 10.0, -- ms
    MaxMemoryUsage = 512, -- MB
    MaxPlayers = 64,
    
    -- Discord Webhook für Alerts
    AlertWebhook = "", -- Discord Webhook URL
    
    -- Resource Monitoring
    MonitorResources = true,
    ResourceBlacklist = {
        'hardcap',
        'rconlog',
        'sessionmanager'
    }
}

PerformanceMonitor.Stats = {
    ServerStartTime = os.time(),
    TotalPlayers = 0,
    PeakPlayers = 0,
    AverageTickTime = 0,
    MemoryUsage = 0,
    ResourceCount = 0,
    PerformanceHistory = {}
}

-- =======================================
-- MONITORING FUNCTIONS
-- =======================================

function PerformanceMonitor:CollectStats()
    local currentTime = os.time()
    local playerCount = GetNumPlayerIndices()
    local tickTime = GetAverageServerTickTime()
    local memoryUsage = collectgarbage("count") / 1024 -- MB
    
    -- Update Stats
    self.Stats.TotalPlayers = playerCount
    if playerCount > self.Stats.PeakPlayers then
        self.Stats.PeakPlayers = playerCount
    end
    
    self.Stats.AverageTickTime = tickTime
    self.Stats.MemoryUsage = memoryUsage
    self.Stats.ResourceCount = GetNumResources()
    
    -- Performance History
    local statsEntry = {
        timestamp = currentTime,
        players = playerCount,
        tickTime = tickTime,
        memory = memoryUsage,
        resources = self.Stats.ResourceCount
    }
    
    table.insert(self.Stats.PerformanceHistory, statsEntry)
    
    -- Keep only last 100 entries
    if #self.Stats.PerformanceHistory > 100 then
        table.remove(self.Stats.PerformanceHistory, 1)
    end
    
    -- Check for Alerts
    self:CheckAlerts(statsEntry)
    
    -- Log Performance
    if self.Config.LogPerformance then
        self:LogPerformance(statsEntry)
    end
end

function PerformanceMonitor:CheckAlerts(stats)
    local alerts = {}
    
    -- High Tick Time
    if stats.tickTime > self.Config.MaxTickTime then
        table.insert(alerts, {
            type = "HIGH_TICK_TIME",
            message = string.format("Hohe Tick-Zeit: %.2fms (Limit: %.2fms)", stats.tickTime, self.Config.MaxTickTime),
            severity = "warning"
        })
    end
    
    -- High Memory Usage
    if stats.memory > self.Config.MaxMemoryUsage then
        table.insert(alerts, {
            type = "HIGH_MEMORY",
            message = string.format("Hoher Speicherverbrauch: %.2fMB (Limit: %dMB)", stats.memory, self.Config.MaxMemoryUsage),
            severity = "warning"
        })
    end
    
    -- Player Limit
    if stats.players >= self.Config.MaxPlayers then
        table.insert(alerts, {
            type = "PLAYER_LIMIT",
            message = string.format("Spielerlimit erreicht: %d/%d", stats.players, self.Config.MaxPlayers),
            severity = "info"
        })
    end
    
    -- Send Alerts
    for _, alert in ipairs(alerts) do
        self:SendAlert(alert)
    end
end

function PerformanceMonitor:SendAlert(alert)
    local alertMessage = string.format(
        "^3[ZenESX Performance] ^1%s^7 - %s",
        alert.type,
        alert.message
    )
    
    print(alertMessage)
    
    -- Discord Webhook
    if self.Config.AlertWebhook and self.Config.AlertWebhook ~= "" then
        self:SendDiscordAlert(alert)
    end
    
    -- Notify Admins
    self:NotifyAdmins(alert)
end

function PerformanceMonitor:SendDiscordAlert(alert)
    local color = 15158332 -- Red
    if alert.severity == "warning" then
        color = 15105570 -- Orange
    elseif alert.severity == "info" then
        color = 3447003 -- Blue
    end
    
    local embed = {
        {
            ["title"] = "ZenESX Performance Alert",
            ["description"] = string.format("**%s**\n%s", alert.type, alert.message),
            ["color"] = color,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            ["fields"] = {
                {
                    ["name"] = "Server Info",
                    ["value"] = string.format(
                        "Spieler: %d\nTick-Zeit: %.2fms\nSpeicher: %.2fMB\nRessourcen: %d",
                        self.Stats.TotalPlayers,
                        self.Stats.AverageTickTime,
                        self.Stats.MemoryUsage,
                        self.Stats.ResourceCount
                    ),
                    ["inline"] = true
                }
            }
        }
    }
    
    PerformHttpRequest(self.Config.AlertWebhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = embed,
        username = "ZenESX Performance Monitor"
    }), { ['Content-Type'] = 'application/json' })
end

function PerformanceMonitor:NotifyAdmins(alert)
    local players = ESX.GetPlayers()
    
    for i=1, #players, 1 do
        if IsPlayerAceAllowed(players[i], "zenesx.admin") then
            TriggerClientEvent('esx:showNotification', players[i], 
                '~y~Performance Alert: ~s~' .. alert.message)
        end
    end
end

function PerformanceMonitor:LogPerformance(stats)
    local logMessage = string.format(
        "[%s] Spieler: %d | Tick: %.2fms | RAM: %.2fMB | Ressourcen: %d",
        os.date("%H:%M:%S"),
        stats.players,
        stats.tickTime,
        stats.memory,
        stats.resources
    )
    
    print("^2[ZenESX Performance] " .. logMessage .. "^7")
end

function PerformanceMonitor:GetResourcePerformance()
    local resources = {}
    
    for i = 0, GetNumResources() - 1 do
        local resourceName = GetResourceByFindIndex(i)
        
        if resourceName and GetResourceState(resourceName) == "started" then
            -- Skip blacklisted resources
            local skip = false
            for _, blacklisted in ipairs(self.Config.ResourceBlacklist) do
                if resourceName == blacklisted then
                    skip = true
                    break
                end
            end
            
            if not skip then
                local memoryUsage = GetResourceMemoryUsage(resourceName, 0) / 1024 -- KB to MB
                table.insert(resources, {
                    name = resourceName,
                    memory = memoryUsage
                })
            end
        end
    end
    
    -- Sort by memory usage
    table.sort(resources, function(a, b) return a.memory > b.memory end)
    
    return resources
end

function PerformanceMonitor:GetServerInfo()
    local uptime = os.time() - self.Stats.ServerStartTime
    local uptimeFormatted = string.format(
        "%dd %dh %dm %ds",
        math.floor(uptime / 86400),
        math.floor((uptime % 86400) / 3600),
        math.floor((uptime % 3600) / 60),
        uptime % 60
    )
    
    return {
        uptime = uptimeFormatted,
        players = self.Stats.TotalPlayers,
        peakPlayers = self.Stats.PeakPlayers,
        tickTime = self.Stats.AverageTickTime,
        memory = self.Stats.MemoryUsage,
        resources = self.Stats.ResourceCount,
        version = GetConvar("version", "Unknown")
    }
end

-- =======================================
-- COMMANDS
-- =======================================

RegisterCommand('perf', function(source, args, rawCommand)
    if source ~= 0 and not IsPlayerAceAllowed(source, "zenesx.admin") then
        return
    end
    
    local info = PerformanceMonitor:GetServerInfo()
    local message = string.format(
        "^2=== ZenESX Performance ===^7\n" ..
        "^3Uptime:^7 %s\n" ..
        "^3Spieler:^7 %d (Peak: %d)\n" ..
        "^3Tick-Zeit:^7 %.2fms\n" ..
        "^3Speicher:^7 %.2fMB\n" ..
        "^3Ressourcen:^7 %d\n" ..
        "^3FiveM Version:^7 %s",
        info.uptime,
        info.players,
        info.peakPlayers,
        info.tickTime,
        info.memory,
        info.resources,
        info.version
    )
    
    if source == 0 then
        print(message)
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 255},
            multiline = true,
            args = {"", message}
        })
    end
end, true)

RegisterCommand('resources', function(source, args, rawCommand)
    if source ~= 0 and not IsPlayerAceAllowed(source, "zenesx.admin") then
        return
    end
    
    local resources = PerformanceMonitor:GetResourcePerformance()
    local message = "^2=== Top Ressourcen (Speicherverbrauch) ===^7\n"
    
    for i = 1, math.min(10, #resources) do
        local resource = resources[i]
        message = message .. string.format(
            "^3%d.^7 %s - %.2fMB\n",
            i,
            resource.name,
            resource.memory
        )
    end
    
    if source == 0 then
        print(message)
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 255, 255},
            multiline = true,
            args = {"", message}
        })
    end
end, true)

-- =======================================
-- EXPORTS
-- =======================================

exports('getServerStats', function()
    return PerformanceMonitor.Stats
end)

exports('getServerInfo', function()
    return PerformanceMonitor:GetServerInfo()
end)

exports('getResourcePerformance', function()
    return PerformanceMonitor:GetResourcePerformance()
end)

-- =======================================
-- INITIALIZATION
-- =======================================

Citizen.CreateThread(function()
    if not PerformanceMonitor.Config.EnableMonitoring then
        print("^3[ZenESX Performance] ^7Performance-Monitoring deaktiviert")
        return
    end
    
    print("^2[ZenESX Performance] ^7Performance-Monitor gestartet")
    print("^3[ZenESX Performance] ^7Befehle: /perf, /resources")
    
    -- Initial Stats Collection
    Wait(5000)
    PerformanceMonitor:CollectStats()
    
    -- Regular Monitoring
    while true do
        Wait(PerformanceMonitor.Config.MonitorInterval)
        PerformanceMonitor:CollectStats()
    end
end)

