# ZenESX Framework - Installation Guide

Vollständige Installationsanleitung für das ZenESX Framework mit allen Features.

## 📋 Systemanforderungen

### **Server-Hardware:**
- **CPU:** Minimum 4 Kerne (empfohlen: 8+ Kerne)
- **RAM:** Minimum 4GB (empfohlen: 8GB+)
- **Storage:** 10GB freier Speicherplatz
- **Bandbreite:** 100 Mbit/s für 64 Spieler

### **Software:**
- **FiveM Server** (Build 2545+)
- **MySQL/MariaDB** (5.7+ / 10.3+)
- **Node.js** (für txAdmin)
- **Git** (für Updates)

## 🚀 Installationsmethoden

### **Methode 1: txAdmin (Empfohlen)**

1. **txAdmin öffnen**
   ```
   Navigiere zu deinem txAdmin Panel
   ```

2. **Server Deployer starten**
   ```
   Servers → Add Server → Popular Templates
   ```

3. **ZenESX Recipe verwenden**
   ```
   Suche nach "ZenESX Framework" oder verwende die Recipe-URL:
   https://github.com/zenscripts/zenesx-framework/raw/main/recipe.yaml
   ```

4. **Konfiguration**
   - Server Name eingeben
   - Datenbank-Einstellungen konfigurieren
   - Admin-Passwort festlegen
   - Installation starten

### **Methode 2: Manuelle Installation**

1. **Repository klonen**
   ```bash
   git clone https://github.com/zenscripts/zenesx-framework.git
   cd zenesx-framework
   ```

2. **Dateien kopieren**
   ```bash
   # Framework-Dateien in resources kopieren
   cp -r . /path/to/your/fivem/resources/zenesx_core/
   
   # Loading Screen kopieren
   cp -r loading_screen /path/to/your/fivem/resources/
   
   # ZS Banking kopieren
   cp -r zs_banking /path/to/your/fivem/resources/
   
   # Cayo Mods kopieren
   cp -r [cayo] /path/to/your/fivem/resources/
   ```

3. **Datenbank Setup**
   ```sql
   # Datenbank erstellen
   CREATE DATABASE zenesx CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   
   # Schema importieren
   mysql -u username -p zenesx < zen.sql
   ```

4. **server.cfg konfigurieren**
   ```bash
   # Kopiere die mitgelieferte server.cfg
   cp server.cfg /path/to/your/server/
   
   # Bearbeite die Einstellungen:
   # - Database Connection String
   # - License Key
   # - Steam API Key
   # - Admin ACE Permissions
   ```

## ⚙️ Konfiguration

### **Datenbank-Verbindung**

In der `server.cfg`:
```cfg
# MySQL/MariaDB Connection
set mysql_connection_string "mysql://username:password@localhost/zenesx?charset=utf8mb4"
```

### **Admin-Berechtigungen**

```cfg
# Haupt-Admin (alle Rechte)
add_principal identifier.steam:YOUR_STEAM_ID group.admin
add_ace group.admin zenesx.god allow

# Moderatoren
add_principal identifier.steam:MODERATOR_STEAM_ID group.moderator  
add_ace group.moderator zenesx.mod allow

# Helper
add_principal identifier.steam:HELPER_STEAM_ID group.helper
add_ace group.helper zenesx.helper allow
```

### **GitHub Updates konfigurieren**

In `update_checker.lua`:
```lua
UpdateChecker.Config = {
    GitHubUser = "zenscripts",
    GitHubRepo = "zenesx-framework", 
    EnableAutoCheck = true,
    CheckInterval = 3600000, -- 1 Stunde
    NotifyAdmins = true
}
```

### **Backup-System konfigurieren**

In `zenesx_backup.lua`:
```lua
BackupSystem.Config = {
    EnableBackups = true,
    BackupInterval = 3600000, -- 1 Stunde
    MaxBackups = 24,
    BackupPath = "backups/",
    CompressBackups = true
}
```

## 🔧 Erweiterte Konfiguration

### **Discord Webhooks einrichten**

1. **Discord Server → Server Settings → Integrations → Webhooks**
2. **Webhook URL kopieren**
3. **In den Lua-Dateien einfügen:**

```lua
-- Admin Logs
ZenAdmin.Config.LogWebhook = "YOUR_WEBHOOK_URL"

-- Performance Alerts  
PerformanceMonitor.Config.AlertWebhook = "YOUR_WEBHOOK_URL"

-- Backup Notifications
BackupSystem.Config.DiscordWebhook = "YOUR_WEBHOOK_URL"
```

### **ZS Banking konfigurieren**

In `zs_banking/config.lua`:
```lua
Config.BankName = "Dein Server Name Banking"
Config.Transfer.fee = 0.0  -- Keine Überweisungsgebühren
Config.Transfer.maxAmount = 10000000
```

### **Cayo Perico aktivieren/deaktivieren**

In `server.cfg`:
```cfg
# Alle Cayo Mods aktivieren
ensure "[cayo]/cayo minimap"
ensure "[cayo]/cayo resurces" 
ensure "[cayo]/cayo shops"
ensure "[cayo]/cayo tor"
ensure "[cayo]/Cayo_Bridge"

# Oder einzeln deaktivieren mit #
# ensure "[cayo]/Cayo_Bridge"
```

## 🎮 Erste Schritte nach Installation

### **1. Server starten**
```bash
# Linux
./run.sh +exec server.cfg

# Windows  
FXServer.exe +exec server.cfg
```

### **2. Admin-Account erstellen**
```sql
# In der Datenbank
UPDATE users SET `group` = 'admin' WHERE identifier = 'steam:YOUR_STEAM_ID';
```

### **3. Framework testen**
- Verbinde mit dem Server
- Drücke F5 für das Admin-Menü
- Teste `/zenesx:version` und `/perf`
- Prüfe ZS Banking mit `/banking`

### **4. Updates prüfen**
```
/zenesx:checkupdate - Manuelle Update-Prüfung
/zenesx:help - Alle verfügbaren Befehle
```

## 🔍 Fehlerbehebung

### **Häufige Probleme:**

#### **"Resource could not be started"**
```bash
# Prüfe fxmanifest.lua Syntax
# Stelle sicher, dass alle Dateien vorhanden sind
# Prüfe Server-Logs für detaillierte Fehlermeldungen
```

#### **Datenbank-Verbindungsfehler**
```bash
# Prüfe MySQL Connection String
# Stelle sicher, dass die Datenbank existiert
# Prüfe Benutzerrechte
```

#### **Admin-Menu funktioniert nicht**
```bash
# Prüfe ACE Permissions in server.cfg
# Stelle sicher, dass Steam ID korrekt ist
# Restart des Servers nach ACE-Änderungen
```

#### **Updates funktionieren nicht**
```bash
# Prüfe Internet-Verbindung des Servers
# GitHub API Rate Limits beachten
# Webhook URLs korrekt konfiguriert
```

### **Debug-Befehle:**
```
/perf - Server Performance anzeigen
/resources - Resource-Speicherverbrauch
/backup status - Backup-Status prüfen
/players - Online-Spieler anzeigen
```

## 📊 Performance-Optimierung

### **Empfohlene server.cfg Einstellungen:**
```cfg
# OneSync
set onesync on

# Performance
set sv_maxUploadMbps 50
set sv_maxDownloadMbps 100
set sv_authMaxVariance 1  
set sv_authMinTrust 5

# Script Timeout
set sv_scriptHookAllowed 0
set sv_enforceGameBuild 2545
```

### **Resource-Prioritäten:**
```cfg
# Hohe Priorität
start zenesx_core
start loading_screen

# Mittlere Priorität
start zs_banking
start es_extended

# Niedrige Priorität (falls Performance-Probleme)
# start "[cayo]/Cayo_Bridge"
```

## 🔄 Update-Prozess

### **Automatische Updates:**
- Framework prüft automatisch alle 60 Minuten
- Admins erhalten Benachrichtigungen bei neuen Versionen
- Discord-Notifications (falls konfiguriert)

### **Manuelle Updates:**
```bash
# 1. Backup erstellen
/backup create

# 2. Git Pull
cd /path/to/zenesx-framework
git pull origin main

# 3. Server neu starten
restart zenesx_core
```

## 📞 Support

### **Bei Problemen:**
1. **Server-Logs prüfen** - Konsole und txAdmin Logs
2. **Framework-Commands** - `/zenesx:help`, `/perf`
3. **Community fragen** - Discord Server
4. **GitHub Issues** - Bug Reports & Feature Requests

### **Support-Kanäle:**
- **Discord:** [discord.gg/zenscripts](https://discord.gg/zenscripts)
- **GitHub:** [github.com/zenscripts/zenesx-framework](https://github.com/zenscripts/zenesx-framework)
- **Website:** [zenscripts.de](https://zenscripts.de)

---

**Viel Erfolg mit deinem ZenESX Server! 🎮✨**
