# ZenESX Backup System

## 🎯 Übersicht
Das ZenESX Backup System sorgt für automatische und manuelle Datenbank-Backups mit erweiterten Sicherheitsfunktionen.

## 🚀 Features
- **Automatische Backups** - Täglich, wöchentlich, monatlich
- **Manuelle Backups** - On-Demand Backup-Erstellung
- **Cloud-Upload** - Automatischer Upload zu Cloud-Speichern
- **Backup-Verwaltung** - Übersicht und Wiederherstellung
- **E-Mail-Benachrichtigungen** - Backup-Status-Updates

## ⌨️ Commands & Keybinds

### **Backup-Erstellung**
- **/backup create** - Manuelles Backup erstellen
- **/backup now** - Sofortiges Backup starten
- **/backup full** - Vollständiges System-Backup

### **Backup-Verwaltung**
- **/backup list** - Alle verfügbaren Backups anzeigen
- **/backup info [ID]** - Backup-Details anzeigen
- **/backup download [ID]** - Backup herunterladen

### **Backup-Wiederherstellung**
- **/backup restore [ID]** - Backup wiederherstellen
- **/backup test [ID]** - Backup-Integrität testen
- **/backup verify [ID]** - Backup-Daten verifizieren

### **Admin-Commands**
- **/backup schedule [daily/weekly/monthly]** - Backup-Zeitplan ändern
- **/backup retention [days]** - Aufbewahrungszeit ändern
- **/backup cleanup** - Alte Backups bereinigen

## 🔧 Konfiguration

### **Backup-Zeitplan**
```lua
-- In der Konfiguration einstellbar
BackupSchedule = {
    daily = "02:00",      -- Täglich um 2:00 Uhr
    weekly = "sunday 03:00", -- Wöchentlich Sonntag 3:00 Uhr
    monthly = "1 04:00"   -- Monatlich am 1. um 4:00 Uhr
}
```

### **Backup-Einstellungen**
```lua
-- Backup-Konfiguration
BackupConfig = {
    retention_days = 30,  -- Backups 30 Tage aufbewahren
    max_backups = 100,    -- Maximal 100 Backups speichern
    compression = true,    -- Komprimierung aktivieren
    encryption = true     -- Verschlüsselung aktivieren
}
```

## 📋 Installation
1. **Resource in server.cfg einbinden:**
   ```cfg
   ensure zenesx_backup_system
   ```

2. **Datenbank-Berechtigungen:**
   ```sql
   GRANT SELECT, INSERT, UPDATE, DELETE ON *.* TO 'backup_user'@'localhost';
   ```

3. **Konfiguration anpassen:**
   ```lua
   -- In config.lua
   DatabaseConfig = {
       host = "localhost",
       user = "backup_user",
       password = "your_password",
       database = "zenesx_db"
   }
   ```

## 🎮 Verwendung

### **Als Admin:**
1. **Backup erstellen:** `/backup create`
2. **Backups verwalten:** `/backup list`
3. **Wiederherstellung:** `/backup restore [ID]`

### **Als Moderator:**
- Nur Backup-Status einsehen
- Keine Wiederherstellung möglich
- Backup-Download erlaubt

## 🔒 Sicherheit
- **Verschlüsselung** aller Backup-Dateien
- **Authentifizierung** für Admin-Funktionen
- **Audit-Logging** aller Backup-Aktionen
- **Integritätsprüfung** vor Wiederherstellung

## 📊 Backup-Status
- **Grün** - Backup erfolgreich
- **Gelb** - Backup läuft
- **Rot** - Backup fehlgeschlagen
- **Blau** - Backup wird verarbeitet

## 📞 Support
- **Discord:** discord.gg/zenscripts
- **GitHub:** github.com/zenscripts/zenesx-framework
- **Version:** 1.0.0

## 📄 Lizenz
© 2025 ZenESX Framework - Alle Rechte vorbehalten
