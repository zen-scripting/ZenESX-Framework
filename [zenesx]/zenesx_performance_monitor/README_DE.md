# ZenESX Performance Monitor

## 🎯 Übersicht
Der ZenESX Performance Monitor überwacht in Echtzeit die Server-Performance und bietet detaillierte Einblicke in Ressourcenverbrauch und Optimierungsmöglichkeiten.

## 🚀 Features
- **Echtzeit-Monitoring** - Live-Performance-Daten
- **Ressourcen-Überwachung** - CPU, RAM, Netzwerk
- **Script-Performance** - Einzelne Resource-Analyse
- **Automatische Warnungen** - Performance-Schwellenwerte
- **Performance-Reports** - Detaillierte Analysen

## ⌨️ Commands & Keybinds

### **Performance-Überwachung**
- **/perf status** - Aktuellen Performance-Status anzeigen
- **/perf monitor** - Performance-Monitor öffnen
- **/perf live** - Live-Performance-Daten starten

### **Ressourcen-Analyse**
- **/perf resources** - Alle Resources mit Performance-Daten
- **/perf resource [name]** - Spezifische Resource analysieren
- **/perf top** - Top 10 Performance-Resources

### **Performance-Reports**
- **/perf report** - Performance-Report generieren
- **/perf export** - Performance-Daten exportieren
- **/perf history** - Performance-Verlauf anzeigen

### **Admin-Commands**
- **/perf alert [on/off]** - Performance-Warnungen ein/aus
- **/perf threshold [cpu/ram] [value]** - Schwellenwerte setzen
- **/perf optimize** - Automatische Optimierung starten

## 🔧 Konfiguration

### **Performance-Schwellenwerte**
```lua
-- In der Konfiguration einstellbar
PerformanceThresholds = {
    cpu_warning = 80,      -- CPU-Warnung bei 80%
    cpu_critical = 95,     -- CPU-Kritisch bei 95%
    ram_warning = 85,      -- RAM-Warnung bei 85%
    ram_critical = 95      -- RAM-Kritisch bei 95%
}
```

### **Überwachungs-Einstellungen**
```lua
-- Monitor-Konfiguration
MonitorConfig = {
    update_interval = 1000,    -- Update alle 1000ms
    log_performance = true,    -- Performance loggen
    auto_optimize = false,     -- Automatische Optimierung
    alert_discord = true       -- Discord-Benachrichtigungen
}
```

## 📋 Installation
1. **Resource in server.cfg einbinden:**
   ```cfg
   ensure zenesx_performance_monitor
   ```

2. **Berechtigungen setzen:**
   ```cfg
   add_ace group.admin command.perf allow
   add_ace group.admin command.zenesx allow
   ```

3. **Konfiguration anpassen:**
   ```lua
   -- In config.lua
   PerformanceConfig = {
       enabled = true,
       log_level = "info",
       discord_webhook = "your_webhook_url"
   }
   ```

## 🎮 Verwendung

### **Als Admin:**
1. **Performance überwachen:** `/perf monitor`
2. **Ressourcen analysieren:** `/perf resources`
3. **Reports generieren:** `/perf report`

### **Als Moderator:**
- Nur Performance-Status einsehen
- Keine Konfiguration möglich
- Performance-Reports anzeigen

## 📊 Performance-Metriken

### **CPU-Performance**
- **Aktuelle Auslastung** - Live-CPU-Verbrauch
- **Durchschnitt** - 1h, 24h, 7 Tage
- **Spitzenwerte** - Höchste CPU-Last

### **RAM-Verbrauch**
- **Verwendeter Speicher** - Aktueller RAM-Verbrauch
- **Verfügbarer Speicher** - Freier RAM
- **Memory Leaks** - Speicherlecks erkennen

### **Netzwerk-Performance**
- **Bandbreite** - Ein-/Ausgang
- **Latenz** - Ping-Zeiten
- **Verbindungen** - Aktive Verbindungen

## 🔒 Sicherheit
- **Admin-Berechtigung** für alle Konfigurationen
- **Audit-Logging** aller Performance-Aktionen
- **Daten-Verschlüsselung** für sensible Metriken
- **Rate-Limiting** für Commands

## 📈 Optimierungstipps
- **Resource-Prioritäten** setzen
- **Unnötige Scripts** deaktivieren
- **Datenbank-Indexe** optimieren
- **Cache-Systeme** implementieren

## 📞 Support
- **Discord:** discord.gg/zenscripts
- **GitHub:** github.com/zenscripts/zenesx-framework
- **Version:** 1.0.0

## 📄 Lizenz
© 2025 ZenESX Framework - Alle Rechte vorbehalten

