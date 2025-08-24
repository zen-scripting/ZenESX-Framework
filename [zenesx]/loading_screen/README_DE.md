# ZenESX Loading Screen

## 🎯 Übersicht
Der ZenESX Loading Screen bietet ein professionelles und ansprechendes Ladeerlebnis mit Hintergrundmusik, animierten Elementen und ESX-Integration.

## 🚀 Features
- **Custom Design** - Moderner Neon-Look mit ZenESX Branding
- **Hintergrundmusik** - Automatische Musikwiedergabe
- **Audio-Controls** - Mute, Volume, Musiksteuerung
- **ESX-Integration** - Wartet auf ESX-Laden vor Ausblenden
- **Responsive Design** - Optimiert für alle Bildschirmgrößen
- **Animierte Elemente** - Smooth Transitions und Effekte

## 🎨 Design-Features
- **Logo-Bild** - ZenESX Logo mit Hover-Effekten
- **Hintergrund-Bild** - Vollbild-Hintergrund mit Overlay
- **Neon-Farben** - Grün/Blau Gradient-Design
- **Glow-Effekte** - Animierte Schatten und Leuchten
- **Status-Updates** - Live-Lade-Status mit Icons

## 🎵 Audio-Features
- **Automatische Wiedergabe** - Musik startet automatisch
- **Volume Control** - Lautstärke einstellbar (0-100%)
- **Mute/Unmute** - Ein-Klick Stummschaltung
- **Loop-Funktion** - Musik läuft endlos
- **Browser-Kompatibilität** - Funktioniert in allen modernen Browsern

## ⏱️ Loading-Verhalten
- **Langsames Laden** - Realistischer Ladevorgang
- **ESX-Wartung** - Wartet bis ESX vollständig geladen ist
- **Automatisches Ausblenden** - Smooth Fade-Out nach ESX-Bereitschaft
- **Fallback-Timeout** - Maximal 30 Sekunden Wartezeit
- **Status-Updates** - 6 verschiedene Lade-Phasen

## 🔧 Konfiguration

### **Datei-Struktur**
```
loading_screen/
├── index.html          # Haupt-HTML-Datei
├── style.css           # CSS-Styling
├── script.js           # JavaScript-Logik
├── logo/
│   ├── logo.png        # ZenESX Logo
│   └── background.png  # Hintergrund-Bild
├── music/
│   └── musik.mp3       # Hintergrundmusik
└── fxmanifest.lua      # FiveM-Manifest
```

### **fxmanifest.lua**
```lua
fx_version 'cerulean'
game 'gta5'

author 'Zen Scripts'
description 'ZenESX Framework - Custom Loading Screen mit Musik'
version '1.0.0'

loadscreen 'index.html'
loadscreen_manual_shutdown 'yes'

files {
    'index.html',
    'style.css',
    'script.js',
    'music/musik.mp3',
    'logo/logo.png',
    'logo/background.png'
}

lua54 'yes'
```

## 📋 Installation
1. **Resource in server.cfg einbinden:**
   ```cfg
   ensure loading_screen
   ```

2. **Bilder hinzufügen:**
   - `logo/logo.png` - ZenESX Logo (empfohlen: 200x200px)
   - `logo/background.png` - Hintergrund-Bild (empfohlen: 1920x1080px)

3. **Musik hinzufügen:**
   - `music/musik.mp3` - Hintergrundmusik (MP3-Format)

## 🎮 Verwendung

### **Automatisch:**
- Loading Screen startet automatisch beim Server-Join
- Musik beginnt nach 2 Sekunden
- Wartet auf ESX-Laden
- Blendet automatisch aus

### **Manuell:**
- Audio-Controls oben rechts
- Mute-Button für Stummschaltung
- Volume-Slider für Lautstärke
- Klick auf Bildschirm startet Musik

## 🔒 Sicherheit
- **Anti-Developer-Tools** - F12, Ctrl+Shift+I blockiert
- **Rechtsklick blockiert** - Kein Kontext-Menü
- **Source-View blockiert** - Ctrl+U deaktiviert
- **Inspect-Element blockiert** - Developer-Tools gesperrt

## 📱 Responsive Design
- **Desktop** - Vollständige Features
- **Tablet** - Angepasste Größen
- **Mobile** - Optimierte Touch-Controls
- **Alle Auflösungen** - Automatische Skalierung

## 📞 Support
- **Discord:** discord.gg/zenscripts
- **GitHub:** github.com/zenscripts/zenesx-framework
- **Version:** 1.0.0

## 📄 Lizenz
© 2025 ZenESX Framework - Alle Rechte vorbehalten

