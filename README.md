# ZenESX Framework 🚀

**Languages:** [🇩🇪 Deutsch](README_DE.md) | [🇺🇸 English](README_EN.md)

A complete, extensible ESX-based framework for FiveM servers with modern banking system, custom loading screen, and extensive features.

## 🌟 Key Features

### 🎮 **Core Framework**
- **ESX Legacy Compatibility** - Fully compatible with existing ESX scripts
- **txAdmin Integration** - Easy installation via txAdmin Server Manager
- **Modular Architecture** - Each system as separate resource
- **GitHub Auto-Updates** - Automatic update notifications in txAdmin
- **Professional Documentation** - Complete setup guides

### 🏦 **ZS Banking System**
- **Crypto Trading** - Bitcoin, Ethereum, Cardano and more
- **Player Transfers** - Send money between players
- **Transaction History** - Complete banking records
- **ATM & Bank Networks** - Multiple locations with different features
- **Premium UI** - Modern banking interface with sound effects

### 🎵 **Custom Loading Screen**
- **Background Music** - YouTube-based audio with controls
- **Audio Controls** - Mute/Unmute, Volume Slider
- **Responsive Design** - Works on all screen sizes
- **Framework Showcase** - Display server features
- **Rotating Tips** - Help new players learn

### 👨‍💻 **Enhanced Admin System**
- **F5 Admin Menu** - Modern interface with role-based access
- **Admin Levels** - God (5), Admin (4), Mod (3), Helper (2), User (1)
- **Complete Command Set** - Teleport, Heal, Kick, Money, Jobs, Noclip
- **Full Logging** - All actions logged with Discord integration
- **ACE Permissions** - Secure permission system

### 📊 **Performance Monitoring**
- **Real-time Stats** - Tick time, memory, players, resources
- **Automatic Alerts** - Performance issue notifications
- **Resource Analysis** - Memory usage per resource
- **Discord Integration** - Critical alerts via webhook
- **Admin Commands** - /perf, /resources for quick checks

### 💾 **Automatic Backups**
- **Hourly Backups** - Automatic database backups
- **Smart Compression** - Automatic file compression
- **Backup Rotation** - Keep 24 backups, auto-cleanup old ones
- **Status Notifications** - Discord alerts for backup status
- **Manual Controls** - /backup create, /backup status

### 🏝️ **Cayo Perico Integration**
- **Complete Island Package** - 5 separate mods for full experience
- **Driveable Bridge** - Connect Los Santos to Cayo Perico
- **Island Banking** - Full banking experience on the island
- **Shops & Services** - Complete shopping MLOs
- **Mansion Gate** - El Rubio's mansion with working gate system
- **79 Stream Files** - Detailed island modifications

## 📁 Framework Structure

```
ZenESX Framework/
├── 📄 server.cfg                  # Complete Server Configuration
├── 📄 recipe.yaml                 # txAdmin Deployment Recipe
├── 📄 zen.sql                     # Database Schema + ZS Banking
├── 📄 README_EN.md                # English Documentation
├── 📄 README_DE.md                # German Documentation
├── 📄 INSTALLATION.md             # Detailed Setup Guide
├── 📄 CHANGELOG.md                # Version History
│
├── 🎵 loading_screen/             # Custom Loading Screen
│   ├── 📄 fxmanifest.lua          # Loading Screen Resource
│   ├── 📄 index.html              # Main Loading Interface
│   ├── 📄 style.css               # Modern Styling
│   ├── 📄 script.js               # Interactive Features
│   └── 🎵 music/                  # Background Music
│       └── 🎵 musik.mp3           # Audio File
│
├── 🏦 zs_banking/                 # Premium Banking System
│   ├── 📄 fxmanifest.lua          # Banking Resource
│   ├── 📄 config.lua              # Banking Configuration
│   ├── 📄 client.lua & server.lua # Core Banking Logic
│   ├── 🗃️ database/               # Banking Database Scripts
│   ├── 💰 transactions/           # Transaction Management
│   ├── 🎨 html/                   # Banking UI Interface
│   └── 🔊 sounds/                 # Audio Effects
│
├── 🔄 zenesx_update_system/       # GitHub Integration
│   ├── 📄 fxmanifest.lua          # Update System Resource
│   ├── 📄 update_checker.lua      # Server Update Logic
│   └── 📄 client_update_notifications.lua # Client Notifications
│
├── 👨‍💻 zenesx_admin_system/        # Admin Management
│   ├── 📄 fxmanifest.lua          # Admin System Resource
│   ├── 📄 zenesx_admin.lua        # Server Admin Functions
│   └── 📄 zenesx_admin_client.lua # Client Admin Interface
│
├── 📊 zenesx_performance_monitor/ # Performance Tracking
│   ├── 📄 fxmanifest.lua          # Performance Resource
│   └── 📄 zenesx_performance.lua  # Monitoring Logic
│
├── 💾 zenesx_backup_system/       # Backup Automation
│   ├── 📄 fxmanifest.lua          # Backup System Resource
│   └── 📄 zenesx_backup.lua       # Backup Management
│
└── 🏝️ [cayo]/                    # Cayo Perico Mods
    ├── 📄 README.md               # Cayo Documentation
    ├── 🗺️ cayo minimap/           # Extended Island Map
    ├── 🏗️ cayo resurces/          # Base Island IPLs
    ├── 🏪 cayo shops/             # Shopping & Banking MLOs
    ├── 🚪 cayo tor/               # Mansion Gate System
    └── 🌉 Cayo_Bridge/            # Bridge Connection (79 files)
```

## 🛠️ Quick Installation

### **Method 1: txAdmin (Recommended)**

1. **Open txAdmin Panel**
2. **Go to:** Servers → Add Server → Popular Templates
3. **Search:** "ZenESX Framework" 
4. **Or use Recipe URL:** 
   ```
   https://github.com/zenscripts/zenesx-framework/raw/main/recipe.yaml
   ```
5. **Configure:** Database, Admin settings
6. **Deploy:** Automatic installation

### **Method 2: Manual Setup**

```bash
# Clone the repository
git clone https://github.com/zenscripts/zenesx-framework.git

# Copy resources to your FiveM server
cp -r zenesx_* /path/to/fivem/resources/
cp -r loading_screen /path/to/fivem/resources/
cp -r zs_banking /path/to/fivem/resources/
cp -r [cayo] /path/to/fivem/resources/

# Import database
mysql -u username -p database_name < zen.sql

# Copy server configuration
cp server.cfg /path/to/your/server/
```

## ⚙️ Essential Configuration

### **Database Connection**
```cfg
# In server.cfg
set mysql_connection_string "mysql://user:pass@localhost/zenesx?charset=utf8mb4"
```

### **Admin Permissions**
```cfg
# Main Admin (Level 5 - God)
add_principal identifier.steam:YOUR_STEAM_ID group.admin
add_ace group.admin zenesx.god allow

# Moderator (Level 3)
add_principal identifier.steam:MOD_STEAM_ID group.moderator
add_ace group.moderator zenesx.mod allow

# Helper (Level 2)
add_principal identifier.steam:HELPER_STEAM_ID group.helper
add_ace group.helper zenesx.helper allow
```

### **Discord Integration**
```lua
# Configure webhooks in each system:
# - Admin logs in zenesx_admin_system/zenesx_admin.lua
# - Performance alerts in zenesx_performance_monitor/zenesx_performance.lua
# - Backup notifications in zenesx_backup_system/zenesx_backup.lua
# - Update notifications in zenesx_update_system/update_checker.lua
```

## 🎮 Player Commands

### **General Commands**
```bash
/zenesx:version        # Show framework version
/zenesx:help          # Display available commands
/banking              # Open banking interface (ZS Banking)
```

### **Admin Commands** (F5 Menu or Direct)
```bash
# Teleportation
/tp [PlayerID]        # Teleport to player
/bring [PlayerID]     # Bring player to you

# Player Management
/heal [PlayerID]      # Heal player (empty = self)
/revive [PlayerID]    # Revive dead player
/zkick [PlayerID] [Reason] # Kick player from server

# Economy
/givemoney [PlayerID] [Account] [Amount] # Give money
/setjob [PlayerID] [Job] [Grade]         # Set player job

# Utilities
/noclip              # Toggle noclip mode
/invisible           # Toggle invisible mode
/players             # Show online players list
```

### **Server Management** (Admin Only)
```bash
# Performance
/perf                # Show server performance stats
/resources           # Show resource memory usage

# Backups
/backup create       # Create manual database backup
/backup status       # Show backup system status

# Updates
/zenesx:checkupdate  # Check for framework updates
```

## 🎯 Key Benefits

### **For Server Owners**
- ✅ **Easy Setup** - txAdmin one-click deployment
- ✅ **Automatic Updates** - GitHub integration keeps you updated
- ✅ **Performance Monitoring** - Real-time server health tracking
- ✅ **Automatic Backups** - Never lose your data
- ✅ **Professional Look** - Custom loading screen with music
- ✅ **Advanced Banking** - Crypto trading and modern UI

### **For Administrators**
- ✅ **Powerful Admin Tools** - Complete management interface
- ✅ **Role-based Access** - 5-level permission system
- ✅ **Full Logging** - All actions tracked and logged
- ✅ **Discord Integration** - Real-time notifications
- ✅ **Easy Commands** - Intuitive command structure

### **For Players**
- ✅ **Enhanced Experience** - Modern loading screen with music
- ✅ **Advanced Banking** - Crypto trading and easy transfers
- ✅ **Cayo Perico Access** - Drive to the island via bridge
- ✅ **Island Banking** - Full banking services on Cayo Perico
- ✅ **Stable Performance** - Optimized for smooth gameplay

## 🔧 Technical Specifications

### **Requirements**
- **FiveM Server** Build 2545+
- **ESX Legacy** (Latest recommended)
- **MySQL/MariaDB** 5.7+ / 10.3+
- **Node.js** (for txAdmin)
- **Git** (for updates)

### **Dependencies**
- `es_extended` (ESX Legacy)
- `oxmysql` (Database connector)
- `ox_lib` (Utility library)
- `esx_menu_default` (For admin menus)

### **Performance**
- **Optimized Scripts** - Modern lua54 standards
- **Minimal Impact** - Efficient resource usage
- **Scalable Design** - Supports up to 64+ players
- **Memory Efficient** - Smart resource management

## 📞 Support & Community

### **Get Help**
- 🎮 **Discord:** [discord.gg/zenscripts](https://discord.gg/zenscripts)
- 🌐 **Website:** [zenscripts.de](https://zenscripts.de)
- 📖 **Documentation:** See INSTALLATION.md for detailed setup
- 🐛 **Bug Reports:** GitHub Issues

### **Community**
- 👥 **Active Community** - 24/7 support from users and developers
- 📚 **Wiki & Tutorials** - Step-by-step guides and examples
- 🔄 **Regular Updates** - New features and improvements
- 🤝 **Open Source** - Community contributions welcome

## 📄 License & Credits

### **License**
© 2024 Zen Scripts - ZenESX Framework  
**Custom License:**
- ✅ Use for personal servers
- ✅ Modify for own needs
- ❌ Commercial redistribution prohibited
- ❌ Copyright removal prohibited

### **Credits**
- **Development:** Zen Scripts Team
- **Based on:** ESX Legacy Framework
- **Inspired by:** PlumeESX Template
- **Special Thanks:** ESX Legacy Community & Contributors

---

## 🚀 Ready to Get Started?

1. **📖 Read:** [INSTALLATION.md](INSTALLATION.md) for detailed setup
2. **💬 Join:** [Discord](https://discord.gg/zenscripts) for support
3. **🚀 Deploy:** Use txAdmin for easy installation
4. **🎮 Enjoy:** Your enhanced FiveM server experience!

**Happy Role Playing! 🎮✨**


# ZenESX Framework 🚀

**Sprachen:** [🇩🇪 Deutsch](README_DE.md) | [🇺🇸 English](README_EN.md)

Ein vollständiges, erweiterbares ESX-basiertes Framework für FiveM Server mit modernem Banking-System, Custom Loading Screen und umfangreichen Features.

## 🌟 Hauptfeatures

### 🎮 **Core Framework**
- **ESX Legacy Kompatibilität** - Vollständig kompatibel mit bestehenden ESX Scripts
- **txAdmin Integration** - Einfache Installation über txAdmin Server Manager
- **Modulare Architektur** - Jedes System als separate Resource
- **GitHub Auto-Updates** - Automatische Update-Benachrichtigungen in txAdmin
- **Professionelle Dokumentation** - Vollständige Setup-Anleitungen

### 🏦 **ZS Banking System**
- **Spieler Überweisungen** - Geld zwischen Spielern senden
- **Transaktions-Historie** - Komplette Banking-Aufzeichnungen
- **ATM & Bank Netzwerke** - Mehrere Standorte mit verschiedenen Features
- **Premium UI** - Moderne Banking-Oberfläche mit Sound-Effekten

### 🎵 **Custom Loading Screen**
- **Hintergrundmusik** - YouTube-basierte Audio-Steuerung
- **Audio-Controls** - Stumm/Laut, Lautstärkeregler
- **Responsive Design** - Funktioniert auf allen Bildschirmgrößen
- **Framework Showcase** - Server-Features anzeigen
- **Rotierende Tipps** - Helfen neuen Spielern beim Lernen

### 👨‍💻 **Erweiterte Admin-System**
- **F5 Admin-Menü** - Moderne Oberfläche mit rollenbasiertem Zugriff
- **Admin-Level** - God (5), Admin (4), Mod (3), Helper (2), User (1)
- **Vollständiger Befehlssatz** - Teleport, Heal, Kick, Money, Jobs, Noclip
- **Vollständige Protokollierung** - Alle Aktionen mit Discord-Integration geloggt
- **ACE Berechtigungen** - Sicheres Berechtigungssystem

### 📊 **Performance-Monitoring**
- **Echtzeit-Statistiken** - Tick-Zeit, Speicher, Spieler, Resources
- **Automatische Warnungen** - Performance-Problem Benachrichtigungen
- **Resource-Analyse** - Speicherverbrauch pro Resource
- **Discord Integration** - Kritische Alerts via Webhook
- **Admin-Befehle** - /perf, /resources für schnelle Checks

### 💾 **Automatische Backups**
- **Stündliche Backups** - Automatische Datenbank-Backups
- **Intelligente Komprimierung** - Automatische Dateikomprimierung
- **Backup-Rotation** - 24 Backups behalten, alte automatisch löschen
- **Status-Benachrichtigungen** - Discord-Alerts für Backup-Status
- **Manuelle Kontrollen** - /backup create, /backup status

### 🏝️ **Cayo Perico Integration**
- **Komplettes Insel-Paket** - 5 separate Mods für vollständige Erfahrung
- **Fahrbare Brücke** - Los Santos mit Cayo Perico verbinden
- **Insel-Banking** - Vollständige Banking-Erfahrung auf der Insel
- **Shops & Services** - Komplette Shopping-MLOs
- **Mansion Gate** - El Rubio's Mansion mit funktionierendem Tor-System
- **79 Stream-Dateien** - Detaillierte Insel-Modifikationen

## 📁 Framework-Struktur

```
ZenESX Framework/
├── 📄 server.cfg                  # Vollständige Server-Konfiguration
├── 📄 recipe.yaml                 # txAdmin Deployment-Recipe
├── 📄 zen.sql                     # Datenbank-Schema + ZS Banking
├── 📄 README_DE.md                # Deutsche Dokumentation
├── 📄 README_EN.md                # Englische Dokumentation
├── 📄 INSTALLATION.md             # Detaillierte Setup-Anleitung
├── 📄 CHANGELOG.md                # Versions-Historie
│
├── 🎵 loading_screen/             # Custom Loading Screen
│   ├── 📄 fxmanifest.lua          # Loading Screen Resource
│   ├── 📄 index.html              # Haupt-Loading Interface
│   ├── 📄 style.css               # Modernes Styling
│   ├── 📄 script.js               # Interaktive Features
│   └── 🎵 music/                  # Hintergrundmusik
│       └── 🎵 musik.mp3           # Audio-Datei
│
├── 🏦 zs_banking/                 # Premium Banking System
│   ├── 📄 fxmanifest.lua          # Banking Resource
│   ├── 📄 config.lua              # Banking-Konfiguration
│   ├── 📄 client.lua & server.lua # Core Banking-Logik
│   ├── 🗃️ database/               # Banking Datenbank-Scripts
│   ├── 💰 transactions/           # Transaktions-Management
│   ├── 🎨 html/                   # Banking UI Interface
│   └── 🔊 sounds/                 # Audio-Effekte
│
├── 🔄 zenesx_update_system/       # GitHub Integration
│   ├── 📄 fxmanifest.lua          # Update System Resource
│   ├── 📄 update_checker.lua      # Server Update-Logik
│   └── 📄 client_update_notifications.lua # Client-Benachrichtigungen
│
├── 👨‍💻 zenesx_admin_system/        # Admin-Management
│   ├── 📄 fxmanifest.lua          # Admin System Resource
│   ├── 📄 zenesx_admin.lua        # Server Admin-Funktionen
│   └── 📄 zenesx_admin_client.lua # Client Admin-Interface
│
├── 📊 zenesx_performance_monitor/ # Performance-Tracking
│   ├── 📄 fxmanifest.lua          # Performance Resource
│   └── 📄 zenesx_performance.lua  # Monitoring-Logik
│
├── 💾 zenesx_backup_system/       # Backup-Automatisierung
│   ├── 📄 fxmanifest.lua          # Backup System Resource
│   └── 📄 zenesx_backup.lua       # Backup-Management
│
└── 🏝️ [cayo]/                    # Cayo Perico Mods
    ├── 📄 README.md               # Cayo Dokumentation
    ├── 🗺️ cayo minimap/           # Erweiterte Insel-Karte
    ├── 🏗️ cayo resurces/          # Basis Insel-IPLs
    ├── 🏪 cayo shops/             # Shopping & Banking MLOs
    ├── 🚪 cayo tor/               # Mansion Gate System
    └── 🌉 Cayo_Bridge/            # Brücken-Verbindung (79 Dateien)
```

## 🛠️ Schnell-Installation

### **Methode 1: txAdmin (Empfohlen)**

1. **txAdmin Panel öffnen**
2. **Navigiere zu:** Servers → Add Server → Popular Templates
3. **Suche:** "ZenESX Framework" 
4. **Oder Recipe-URL verwenden:** 
   ```
   https://github.com/zenscripts/zenesx-framework/raw/main/recipe.yaml
   ```
5. **Konfigurieren:** Datenbank, Admin-Einstellungen
6. **Deployen:** Automatische Installation

### **Methode 2: Manuelle Installation**

```bash
# Repository klonen
git clone https://github.com/zenscripts/zenesx-framework.git

# Resources in FiveM Server kopieren
cp -r zenesx_* /pfad/zu/fivem/resources/
cp -r loading_screen /pfad/zu/fivem/resources/
cp -r zs_banking /pfad/zu/fivem/resources/
cp -r [cayo] /pfad/zu/fivem/resources/

# Datenbank importieren
mysql -u benutzername -p datenbankname < zen.sql

# Server-Konfiguration kopieren
cp server.cfg /pfad/zu/deinem/server/
```

## ⚙️ Grundkonfiguration

### **Datenbank-Verbindung**
```cfg
# In server.cfg
set mysql_connection_string "mysql://benutzer:passwort@localhost/zenesx?charset=utf8mb4"
```

### **Admin-Berechtigungen**
```cfg
# Haupt-Admin (Level 5 - God)
add_principal identifier.steam:DEINE_STEAM_ID group.admin
add_ace group.admin zenesx.god allow

# Moderator (Level 3)
add_principal identifier.steam:MOD_STEAM_ID group.moderator
add_ace group.moderator zenesx.mod allow

# Helper (Level 2)
add_principal identifier.steam:HELPER_STEAM_ID group.helper
add_ace group.helper zenesx.helper allow
```

### **Discord Integration**
```lua
# Webhooks in jedem System konfigurieren:
# - Admin-Logs in zenesx_admin_system/zenesx_admin.lua
# - Performance-Alerts in zenesx_performance_monitor/zenesx_performance.lua
# - Backup-Benachrichtigungen in zenesx_backup_system/zenesx_backup.lua
# - Update-Benachrichtigungen in zenesx_update_system/update_checker.lua
```

## 🎮 Spieler-Befehle

### **Allgemeine Befehle**
```bash
/zenesx:version        # Framework-Version anzeigen
/zenesx:help          # Verfügbare Befehle anzeigen
/banking              # Banking-Interface öffnen (ZS Banking)
```

### **Admin-Befehle** (F5-Menü oder Direkt)
```bash
# Teleportation
/tp [SpielerID]       # Zu Spieler teleportieren
/bring [SpielerID]    # Spieler zu dir holen

# Spieler-Management
/heal [SpielerID]     # Spieler heilen (leer = selbst)
/revive [SpielerID]   # Toten Spieler wiederbeleben
/zkick [SpielerID] [Grund] # Spieler vom Server kicken

# Wirtschaft
/givemoney [SpielerID] [Konto] [Betrag] # Geld geben
/setjob [SpielerID] [Job] [Grad]        # Spieler-Job setzen

# Utilities
/noclip              # Noclip-Modus umschalten
/invisible           # Unsichtbar-Modus umschalten
/players             # Online-Spieler Liste anzeigen
```

### **Server-Management** (Nur Admins)
```bash
# Performance
/perf                # Server-Performance Statistiken anzeigen
/resources           # Resource-Speicherverbrauch anzeigen

# Backups
/backup create       # Manuelles Datenbank-Backup erstellen
/backup status       # Backup-System Status anzeigen

# Updates
/zenesx:checkupdate  # Framework-Updates prüfen
```

## 🎯 Hauptvorteile

### **Für Server-Owner**
- ✅ **Einfache Installation** - txAdmin Ein-Klick Deployment
- ✅ **Automatische Updates** - GitHub-Integration hält dich auf dem Laufenden
- ✅ **Performance-Monitoring** - Echtzeit Server-Gesundheits-Tracking
- ✅ **Automatische Backups** - Verliere niemals deine Daten
- ✅ **Professioneller Look** - Custom Loading Screen mit Musik
- ✅ **Erweiterte Banking** - Crypto-Trading und moderne UI

### **Für Administratoren**
- ✅ **Mächtige Admin-Tools** - Komplette Management-Oberfläche
- ✅ **Rollenbasierter Zugriff** - 5-Level Berechtigungssystem
- ✅ **Vollständige Protokollierung** - Alle Aktionen verfolgt und geloggt
- ✅ **Discord Integration** - Echtzeit-Benachrichtigungen
- ✅ **Einfache Befehle** - Intuitive Befehlsstruktur

### **Für Spieler**
- ✅ **Verbesserte Erfahrung** - Moderner Loading Screen mit Musik
- ✅ **Erweiterte Banking** - Crypto-Trading und einfache Überweisungen
- ✅ **Cayo Perico Zugang** - Zur Insel über Brücke fahren
- ✅ **Insel-Banking** - Vollständige Banking-Services auf Cayo Perico
- ✅ **Stabile Performance** - Optimiert für flüssiges Gameplay

## 🔧 Technische Spezifikationen

### **Anforderungen**
- **FiveM Server** Build 2545+
- **ESX Legacy** (Neueste empfohlen)
- **MySQL/MariaDB** 5.7+ / 10.3+
- **Node.js** (für txAdmin)
- **Git** (für Updates)

### **Abhängigkeiten**
- `es_extended` (ESX Legacy)
- `oxmysql` (Datenbank-Connector)
- `ox_lib` (Utility-Bibliothek)
- `esx_menu_default` (Für Admin-Menüs)

### **Performance**
- **Optimierte Scripts** - Moderne lua54 Standards
- **Minimaler Impact** - Effizienter Resource-Verbrauch
- **Skalierbare Design** - Unterstützt bis zu 64+ Spieler
- **Speicher-Effizient** - Intelligentes Resource-Management

## 📞 Support & Community

### **Hilfe erhalten**
- 🎮 **Discord:** [discord.gg/zenscripts](https://discord.gg/zenscripts)
- 📖 **Dokumentation:** Siehe INSTALLATION.md für detaillierte Installation
- 🐛 **Bug Reports:** GitHub Issues

### **Community**
- 👥 **Aktive Community** - 24/7 Support von Benutzern und Entwicklern
- 📚 **Wiki & Tutorials** - Schritt-für-Schritt Anleitungen und Beispiele
- 🔄 **Regelmäßige Updates** - Neue Features und Verbesserungen
- 🤝 **Open Source** - Community-Beiträge willkommen

## 📄 Lizenz & Credits

### **Lizenz**
© 2024 Zen Scripts - ZenESX Framework  
**Custom Lizenz:**
- ✅ Nutzung für persönliche Server
- ✅ Modifikationen für eigene Bedürfnisse
- ❌ Kommerzielle Weiterverteilung verboten
- ❌ Entfernung des Copyrights verboten

### **Credits**
- **Entwicklung:** Zen Scripts Team
- **Basierend auf:** ESX Legacy Framework
- **Besonderer Dank:** ESX Legacy Community & Contributors

---

## 🚀 Bereit zum Starten?

1. **📖 Lesen:** [INSTALLATION.md](INSTALLATION.md) für detaillierte Installation
2. **💬 Beitreten:** [Discord](https://discord.gg/9m4EzYqJ) für Support
3. **🚀 Deployen:** txAdmin für einfache Installation verwenden
4. **🎮 Genießen:** Dein verbessertes FiveM Server-Erlebnis!

**Happy Role Playing! 🎮✨**
