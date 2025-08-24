# ZenESX Backup System

## 🎯 Overview
The ZenESX Backup System provides automatic and manual database backups with advanced security features.

## 🚀 Features
- **Automatic Backups** - Daily, weekly, monthly
- **Manual Backups** - On-demand backup creation
- **Cloud Upload** - Automatic upload to cloud storage
- **Backup Management** - Overview and restoration
- **Email Notifications** - Backup status updates

## ⌨️ Commands & Keybinds

### **Backup Creation**
- **/backup create** - Create manual backup
- **/backup now** - Start immediate backup
- **/backup full** - Complete system backup

### **Backup Management**
- **/backup list** - Show all available backups
- **/backup info [ID]** - Show backup details
- **/backup download [ID]** - Download backup

### **Backup Restoration**
- **/backup restore [ID]** - Restore backup
- **/backup test [ID]** - Test backup integrity
- **/backup verify [ID]** - Verify backup data

### **Admin Commands**
- **/backup schedule [daily/weekly/monthly]** - Change backup schedule
- **/backup retention [days]** - Change retention time
- **/backup cleanup** - Clean old backups

## 🔧 Configuration

### **Backup Schedule**
```lua
-- Configurable in configuration
BackupSchedule = {
    daily = "02:00",      -- Daily at 2:00 AM
    weekly = "sunday 03:00", -- Weekly on Sunday at 3:00 AM
    monthly = "1 04:00"   -- Monthly on 1st at 4:00 AM
}
```

### **Backup Settings**
```lua
-- Backup configuration
BackupConfig = {
    retention_days = 30,  -- Keep backups for 30 days
    max_backups = 100,    -- Maximum 100 backups
    compression = true,    -- Enable compression
    encryption = true     -- Enable encryption
}
```

## 📋 Installation
1. **Include resource in server.cfg:**
   ```cfg
   ensure zenesx_backup_system
   ```

2. **Database permissions:**
   ```sql
   GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'backup_user'@'localhost';
   ```

3. **Adjust configuration:**
   ```lua
   -- In config.lua
   DatabaseConfig = {
       host = "localhost",
       user = "backup_user",
       password = "your_password",
       database = "zenesx_db"
   }
   ```

## 🎮 Usage

### **As Admin:**
1. **Create backup:** `/backup create`
2. **Manage backups:** `/backup list`
3. **Restore backup:** `/backup restore [ID]`

### **As Moderator:**
- Only view backup status
- No restoration possible
- Backup download allowed

## 🔒 Security
- **Encryption** of all backup files
- **Authentication** for admin functions
- **Audit logging** of all backup actions
- **Integrity check** before restoration

## 📊 Backup Status
- **Green** - Backup successful
- **Yellow** - Backup running
- **Red** - Backup failed
- **Blue** - Backup processing

## 📞 Support
- **Discord:** discord.gg/zenscripts
- **GitHub:** github.com/zenscripts/zenesx-framework
- **Version:** 1.0.0

## 📄 License
© 2025 ZenESX Framework - All rights reserved
