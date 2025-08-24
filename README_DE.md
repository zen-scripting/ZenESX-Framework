# ZenESX Framework 🚀

**Sprachen:** [🇩🇪 Deutsch](README_DE.md) | [🇺🇸 English](README_EN.md)

Das ist der link der in txadmin eingefügt werden muss in Remote URL Template , das man das framework verwenden kann

txadmin framework link:https://raw.githubusercontent.com/zen-scripting/ZenESX-Framework/main/recipe.yaml

Ein vollständiges, erweiterbares ESX-basiertes Framework für FiveM Server mit modernem Banking-System, Custom Loading Screen und umfangreichen Features.

## 🌟 Hauptfeatures

### 🎮 **Core Framework**
- **ESX Legacy Kompatibilität** - Vollständig kompatibel mit bestehenden ESX Scripts
- **txAdmin Integration** - Einfache Installation über txAdmin Server Manager
- **Modulare Architektur** - Jedes System als separate Resource
- **GitHub Auto-Updates** - Automatische Update-Benachrichtigungen in txAdmin
- **Professionelle Dokumentation** - Vollständige Setup-Anleitungen

### 🏦 **ZS Banking System**
- **Crypto Trading** - Bitcoin, Ethereum, Cardano und mehr
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

### 🚚 **RAMAZON Delivery Job**
- **Vollständiges Lieferungssystem** - Pakete an verschiedene Standorte liefern
- **Fahrzeug-Integration** - Spezielle Lieferfahrzeuge für den Job
- **Verdienst-System** - Einkommen basierend auf gelieferten Paketen
- **Arbeiter-Verwaltung** - System zur Verwaltung von RAMAZON-Mitarbeitern
- **Fortschritts-Tracking** - Verfolgung der Lieferungen und Statistiken
- **Mehrere Standorte** - Verschiedene Lieferpunkte in der Stadt

### 🏗️ **Construction Worker Job**
- **Vollständiges Bauarbeiter-System** - Verschiedene Bauprojekte in der Stadt
- **Baustellen-Management** - Mehrere Baustellen mit verschiedenen Aufgaben
- **Verdienst-System** - Einkommen basierend auf geleisteter Arbeit
- **Arbeiter-Verwaltung** - System zur Verwaltung von Bauarbeitern
- **Fortschritts-Tracking** - Verfolgung der Bauprojekte
- **Material-System** - Baumaterialien und Werkzeuge verwalten

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
├── 🚚 [jobs]/                     # Custom Job System
│   ├── 📦 ramazon_job/            # RAMAZON Delivery Job
│   │   ├── 📄 fxmanifest.lua      # Job Resource
│   │   ├── 📄 rc_ramazon/         # Haupt-Job System
│   │   ├── 📄 rc_ramazonDelivery/ # Lieferungs-System
│   │   ├── 📄 rprogress/          # Fortschritts-Bar
│   │   ├── 📄 pNotify/            # Benachrichtigungen
│   │   └── 📄 README_DE.md        # Deutsche Dokumentation
│   └── 🏗️ construction_worker/    # Construction Worker Job
│       ├── 📄 fxmanifest.lua      # Job Resource
│       ├── 📄 client/             # Client-Side Scripts
│       ├── 📄 server/             # Server-Side Scripts
│       ├── 📄 locales/            # Lokalisierung
│       ├── 📄 config.lua          # Job-Konfiguration
│       └── 📄 README_DE.md        # Deutsche Dokumentation
│
├── 💾 zenesx_backup_system/       # Backup-Automatisierung
│
├── 📦 [ox]/                       # OX Library & Inventory System
│   ├── 📦 ox_lib/                 # OX Library System
│   │   ├── 📄 fxmanifest.lua      # ox_lib Resource
│   │   └── 📄 init.lua            # Library Initialisierung
│   └── 🎒 ox_inventory/           # OX Inventory System
│       ├── 📄 fxmanifest.lua      # ox_inventory Resource
│       ├── 📄 modules/            # Inventory Module
│       ├── 📄 data/               # Item-Daten
│       ├── 📄 locales/            # Lokalisierung
│       └── 📄 web/                # Web-Interface
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
   [https://github.com/zenscripts/zenesx-framework/raw/main/recipe.yaml]
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
- 🌐 **Website:** [zenscripts.de](https://zenscripts.de)
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
- **Inspiriert von:** PlumeESX Template
- **Besonderer Dank:** ESX Legacy Community & Contributors

---

## 🚀 Bereit zum Starten?

1. **📖 Lesen:** [INSTALLATION.md](INSTALLATION.md) für detaillierte Installation
2. **💬 Beitreten:** [Discord](https://discord.gg/9m4EzYqJ) für Support
3. **🚀 Deployen:** txAdmin für einfache Installation verwenden
4. **🎮 Genießen:** Dein verbessertes FiveM Server-Erlebnis!

**Happy Role Playing! 🎮✨**

