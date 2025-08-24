# ZenESX Admin System

## 🎯 Übersicht
Das ZenESX Admin System bietet erweiterte Admin-Tools für Server-Administratoren mit verschiedenen Berechtigungsstufen.

## 🚀 Features
- **Noclip System** - Durch Wände und Objekte fliegen
- **Invisible Mode** - Unsichtbar für andere Spieler
- **Player Healing** - Spieler sofort heilen
- **Teleport System** - Zu anderen Spielern teleportieren
- **Admin Menu** - Vollständiges Admin-Interface

## ⌨️ Commands & Keybinds

### **Admin Menu**
- **F5** - Admin-Menü öffnen
- **/admin** - Admin-Menü über Chat öffnen

### **Noclip System**
- **F6** - Noclip ein/ausschalten
- **/noclip** - Noclip über Chat steuern

### **Invisible Mode**
- **F7** - Unsichtbarkeit ein/ausschalten
- **/invisible** - Unsichtbarkeit über Chat steuern

### **Player Healing**
- **F8** - Spieler sofort heilen
- **/heal** - Heilung über Chat

### **Teleport System**
- **/goto [ID]** - Zu Spieler teleportieren
- **/bring [ID]** - Spieler zu dir teleportieren

## 🔧 Konfiguration

### **Berechtigungsstufen**
```lua
-- In der Konfiguration einstellbar
AdminLevels = {
    ["superadmin"] = 3,    -- Alle Rechte
    ["admin"] = 2,         -- Erweiterte Rechte
    ["moderator"] = 1      -- Grundrechte
}
```

### **Keybinds anpassen**
```lua
-- In der Konfiguration änderbar
AdminMenuKey = 166,        -- F5
NoclipKey = 167,           -- F6
InvisibleKey = 168,        -- F7
HealKey = 169              -- F8
```

## 📋 Installation
1. **Resource in server.cfg einbinden:**
   ```cfg
   ensure zenesx_admin_system
   ```

2. **Berechtigungen setzen:**
   ```cfg
   add_ace group.admin command allow
   add_ace group.admin command.zenesx allow
   ```

## 🎮 Verwendung

### **Als Admin:**
1. **F5 drücken** für Admin-Menü
2. **Spieler auswählen** aus der Liste
3. **Aktion wählen** (Heal, Teleport, etc.)
4. **Bestätigen** der Aktion

### **Als Moderator:**
- Eingeschränkte Rechte
- Nur grundlegende Admin-Funktionen
- Keine Spieler-Banns oder Kicks

## 🔒 Sicherheit
- **Server-seitige Validierung** aller Admin-Aktionen
- **Berechtigungsprüfung** vor jeder Aktion
- **Logging** aller Admin-Aktivitäten
- **Anti-Abuse** Schutzmaßnahmen

## 📞 Support
- **Discord:** discord.gg/zenscripts
- **GitHub:** github.com/zenscripts/zenesx-framework
- **Version:** 1.0.0

## 📄 Lizenz
© 2025 ZenESX Framework - Alle Rechte vorbehalten
