-- =======================================
-- ZENESX FRAMEWORK BACKUP SYSTEM
-- Automatische Datenbank-Backups
-- =======================================

local BackupSystem = {}
BackupSystem.Config = {
    -- Backup Settings
    EnableBackups = true,
    BackupInterval = 3600000, -- 1 Stunde in Millisekunden
    BackupPath = "backups/",
    MaxBackups = 24, -- Maximale Anzahl von Backups
    
    -- Database Settings
    DatabaseHost = GetConvar("mysql_connection_string", ""),
    BackupTables = {
        'users',
        'jobs',
        'job_grades',
        'owned_vehicles',
        'society',
        'addon_account_data',
        'banking_crypto_transactions',
        'banking_transfers',
        'banking_history'
    },
    
    -- Compression
    CompressBackups = true,
    
    -- Notifications
    NotifyAdmins = true,
    DiscordWebhook = "", -- Discord Webhook für Backup-Notifications
    
    -- FTP Upload (Optional)
    FTPEnabled = false,
    FTPHost = "",
    FTPUser = "",
    FTPPassword = "",
    FTPPath = "/backups/"
}

BackupSystem.Stats = {
    LastBackup = 0,
    TotalBackups = 0,
    BackupHistory = {}
}

-- =======================================
-- BACKUP FUNCTIONS
-- =======================================

function BackupSystem:CreateBackup()
    if not self.Config.EnableBackups then return end
    
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local backupName = string.format("zenesx_backup_%s", timestamp)
    local backupFile = self.Config.BackupPath .. backupName .. ".sql"
    
    print("^3[ZenESX Backup] ^7Erstelle Backup: " .. backupName)
    
    -- Create backup directory if it doesn't exist
    self:EnsureBackupDirectory()
    
    -- Generate SQL Dump
    local sqlDump = self:GenerateSQLDump()
    
    if sqlDump then
        -- Write to file
        local success = self:WriteBackupFile(backupFile, sqlDump)
        
        if success then
            -- Compress if enabled
            if self.Config.CompressBackups then
                self:CompressBackup(backupFile)
            end
            
            -- Update stats
            self.Stats.LastBackup = os.time()
            self.Stats.TotalBackups = self.Stats.TotalBackups + 1
            
            table.insert(self.Stats.BackupHistory, {
                timestamp = os.time(),
                filename = backupName,
                size = self:GetFileSize(backupFile)
            })
            
            -- Cleanup old backups
            self:CleanupOldBackups()
            
            -- Notifications
            self:SendBackupNotification(backupName, true)
            
            -- FTP Upload
            if self.Config.FTPEnabled then
                self:UploadToFTP(backupFile)
            end
            
            print("^2[ZenESX Backup] ^7Backup erfolgreich erstellt: " .. backupName)
        else
            print("^1[ZenESX Backup] ^7Fehler beim Schreiben der Backup-Datei!")
            self:SendBackupNotification(backupName, false)
        end
    else
        print("^1[ZenESX Backup] ^7Fehler beim Erstellen des SQL-Dumps!")
        self:SendBackupNotification(backupName, false)
    end
end

function BackupSystem:GenerateSQLDump()
    local sqlDump = {}
    
    -- Header
    table.insert(sqlDump, "-- =======================================")
    table.insert(sqlDump, "-- ZENESX FRAMEWORK BACKUP")
    table.insert(sqlDump, "-- Erstellt am: " .. os.date("%Y-%m-%d %H:%M:%S"))
    table.insert(sqlDump, "-- =======================================")
    table.insert(sqlDump, "")
    table.insert(sqlDump, "SET SQL_MODE = \"NO_AUTO_VALUE_ON_ZERO\";")
    table.insert(sqlDump, "START TRANSACTION;")
    table.insert(sqlDump, "SET time_zone = \"+00:00\";")
    table.insert(sqlDump, "")
    
    -- Backup each table
    for _, tableName in ipairs(self.Config.BackupTables) do
        local tableData = self:BackupTable(tableName)
        if tableData then
            for _, line in ipairs(tableData) do
                table.insert(sqlDump, line)
            end
            table.insert(sqlDump, "")
        end
    end
    
    -- Footer
    table.insert(sqlDump, "COMMIT;")
    
    return table.concat(sqlDump, "\n")
end

function BackupSystem:BackupTable(tableName)
    local result = {}
    
    table.insert(result, "-- =======================================")
    table.insert(result, "-- TABLE: " .. tableName)
    table.insert(result, "-- =======================================")
    
    -- Get table structure
    MySQL.Async.fetchAll('SHOW CREATE TABLE ' .. tableName, {}, function(createResult)
        if createResult and createResult[1] then
            table.insert(result, createResult[1]['Create Table'] .. ";")
            table.insert(result, "")
        end
    end)
    
    -- Get table data
    MySQL.Async.fetchAll('SELECT * FROM ' .. tableName, {}, function(data)
        if data and #data > 0 then
            table.insert(result, "-- Data for table: " .. tableName)
            
            for _, row in ipairs(data) do
                local columns = {}
                local values = {}
                
                for column, value in pairs(row) do
                    table.insert(columns, "`" .. column .. "`")
                    
                    if value == nil then
                        table.insert(values, "NULL")
                    elseif type(value) == "string" then
                        table.insert(values, "'" .. MySQL.Async.escape(value) .. "'")
                    else
                        table.insert(values, tostring(value))
                    end
                end
                
                local insertSQL = string.format(
                    "INSERT INTO `%s` (%s) VALUES (%s);",
                    tableName,
                    table.concat(columns, ", "),
                    table.concat(values, ", ")
                )
                
                table.insert(result, insertSQL)
            end
        end
    end)
    
    return result
end

function BackupSystem:WriteBackupFile(filename, content)
    local file = io.open(filename, "w")
    if file then
        file:write(content)
        file:close()
        return true
    end
    return false
end

function BackupSystem:EnsureBackupDirectory()
    -- Create backup directory (platform specific)
    if os.getenv("OS") == "Windows_NT" then
        os.execute('mkdir "' .. self.Config.BackupPath .. '" >nul 2>&1')
    else
        os.execute('mkdir -p "' .. self.Config.BackupPath .. '"')
    end
end

function BackupSystem:CompressBackup(filename)
    -- Simple compression using gzip if available
    local compressCommand
    if os.getenv("OS") == "Windows_NT" then
        -- Windows: Use built-in PowerShell compression
        compressCommand = string.format(
            'powershell -command "Compress-Archive -Path \'%s\' -DestinationPath \'%s.zip\'"',
            filename,
            filename
        )
    else
        -- Linux/Unix: Use gzip
        compressCommand = string.format('gzip "%s"', filename)
    end
    
    local success = os.execute(compressCommand)
    if success == 0 then
        print("^2[ZenESX Backup] ^7Backup komprimiert")
        -- Delete original file after compression
        os.remove(filename)
    end
end

function BackupSystem:GetFileSize(filename)
    local file = io.open(filename, "r")
    if file then
        local size = file:seek("end")
        file:close()
        return size
    end
    return 0
end

function BackupSystem:CleanupOldBackups()
    if #self.Stats.BackupHistory > self.Config.MaxBackups then
        local toRemove = #self.Stats.BackupHistory - self.Config.MaxBackups
        
        for i = 1, toRemove do
            local oldBackup = table.remove(self.Stats.BackupHistory, 1)
            local filename = self.Config.BackupPath .. oldBackup.filename .. ".sql"
            
            -- Try both .sql and .gz extensions
            if os.remove(filename) then
                print("^3[ZenESX Backup] ^7Altes Backup gelöscht: " .. oldBackup.filename)
            elseif os.remove(filename .. ".gz") then
                print("^3[ZenESX Backup] ^7Altes Backup gelöscht: " .. oldBackup.filename .. ".gz")
            end
        end
    end
end

function BackupSystem:SendBackupNotification(backupName, success)
    local message = success and 
        "Backup erfolgreich erstellt: " .. backupName or
        "Backup fehlgeschlagen: " .. backupName
    
    print("^2[ZenESX Backup] " .. message .. "^7")
    
    -- Notify admins
    if self.Config.NotifyAdmins then
        local players = ESX.GetPlayers()
        for i=1, #players, 1 do
            if IsPlayerAceAllowed(players[i], "zenesx.admin") then
                local notificationColor = success and "~g~" or "~r~"
                TriggerClientEvent('esx:showNotification', players[i], 
                    notificationColor .. "Backup: ~s~" .. message)
            end
        end
    end
    
    -- Discord notification
    if self.Config.DiscordWebhook and self.Config.DiscordWebhook ~= "" then
        self:SendDiscordNotification(backupName, success)
    end
end

function BackupSystem:SendDiscordNotification(backupName, success)
    local color = success and 65280 or 16711680 -- Green or Red
    local status = success and "✅ Erfolgreich" or "❌ Fehlgeschlagen"
    
    local embed = {
        {
            ["title"] = "ZenESX Backup Status",
            ["description"] = string.format("**%s**\nBackup: %s", status, backupName),
            ["color"] = color,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            ["fields"] = {
                {
                    ["name"] = "Server Info",
                    ["value"] = string.format(
                        "Spieler Online: %d\nTotal Backups: %d\nLetztes Backup: %s",
                        GetNumPlayerIndices(),
                        self.Stats.TotalBackups,
                        os.date("%H:%M:%S", self.Stats.LastBackup)
                    ),
                    ["inline"] = true
                }
            }
        }
    }
    
    PerformHttpRequest(self.Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = embed,
        username = "ZenESX Backup System"
    }), { ['Content-Type'] = 'application/json' })
end

-- =======================================
-- COMMANDS
-- =======================================

RegisterCommand('backup', function(source, args, rawCommand)
    if source ~= 0 and not IsPlayerAceAllowed(source, "zenesx.admin") then
        return
    end
    
    if args[1] == "create" then
        BackupSystem:CreateBackup()
    elseif args[1] == "status" then
        local message = string.format(
            "^2=== ZenESX Backup Status ===^7\n" ..
            "^3Backups aktiviert:^7 %s\n" ..
            "^3Letztes Backup:^7 %s\n" ..
            "^3Total Backups:^7 %d\n" ..
            "^3Backup Interval:^7 %d Minuten\n" ..
            "^3Max Backups:^7 %d",
            self.Config.EnableBackups and "Ja" or "Nein",
            self.Stats.LastBackup > 0 and os.date("%Y-%m-%d %H:%M:%S", self.Stats.LastBackup) or "Noch nie",
            self.Stats.TotalBackups,
            self.Config.BackupInterval / 60000,
            self.Config.MaxBackups
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
    else
        local helpMessage = "^3Verwendung:^7 /backup [create|status]"
        if source == 0 then
            print(helpMessage)
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = {"", helpMessage}
            })
        end
    end
end, true)

-- =======================================
-- EXPORTS
-- =======================================

exports('createBackup', function()
    BackupSystem:CreateBackup()
end)

exports('getBackupStats', function()
    return BackupSystem.Stats
end)

-- =======================================
-- INITIALIZATION
-- =======================================

Citizen.CreateThread(function()
    if not BackupSystem.Config.EnableBackups then
        print("^3[ZenESX Backup] ^7Backup-System deaktiviert")
        return
    end
    
    print("^2[ZenESX Backup] ^7Backup-System gestartet")
    print("^3[ZenESX Backup] ^7Intervall: " .. (BackupSystem.Config.BackupInterval / 60000) .. " Minuten")
    print("^3[ZenESX Backup] ^7Befehle: /backup create, /backup status")
    
    -- Initial backup after 5 minutes
    Wait(300000)
    BackupSystem:CreateBackup()
    
    -- Regular backups
    while true do
        Wait(BackupSystem.Config.BackupInterval)
        BackupSystem:CreateBackup()
    end
end)
