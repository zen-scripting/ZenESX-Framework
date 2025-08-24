# ZenESX Loading Screen

## 🎯 Overview
The ZenESX Loading Screen provides a professional and engaging loading experience with background music, animated elements, and ESX integration.

## 🚀 Features
- **Custom Design** - Modern neon look with ZenESX branding
- **Background Music** - Automatic music playback
- **Audio Controls** - Mute, volume, music control
- **ESX Integration** - Waits for ESX loading before hiding
- **Responsive Design** - Optimized for all screen sizes
- **Animated Elements** - Smooth transitions and effects

## 🎨 Design Features
- **Logo Image** - ZenESX logo with hover effects
- **Background Image** - Fullscreen background with overlay
- **Neon Colors** - Green/blue gradient design
- **Glow Effects** - Animated shadows and lighting
- **Status Updates** - Live loading status with icons

## 🎵 Audio Features
- **Automatic Playback** - Music starts automatically
- **Volume Control** - Adjustable volume (0-100%)
- **Mute/Unmute** - One-click mute toggle
- **Loop Function** - Music runs endlessly
- **Browser Compatibility** - Works in all modern browsers

## ⏱️ Loading Behavior
- **Slow Loading** - Realistic loading process
- **ESX Waiting** - Waits until ESX is fully loaded
- **Auto Hide** - Smooth fade-out after ESX readiness
- **Fallback Timeout** - Maximum 30 seconds wait time
- **Status Updates** - 6 different loading phases

## 🔧 Configuration

### **File Structure**
```
loading_screen/
├── index.html          # Main HTML file
├── style.css           # CSS styling
├── script.js           # JavaScript logic
├── logo/
│   ├── logo.png        # ZenESX logo
│   └── background.png  # Background image
├── music/
│   └── musik.mp3       # Background music
└── fxmanifest.lua      # FiveM manifest
```

### **fxmanifest.lua**
```lua
fx_version 'cerulean'
game 'gta5'

author 'Zen Scripts'
description 'ZenESX Framework - Custom Loading Screen with Music'
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
1. **Include resource in server.cfg:**
   ```cfg
   ensure loading_screen
   ```

2. **Add images:**
   - `logo/logo.png` - ZenESX logo (recommended: 200x200px)
   - `logo/background.png` - Background image (recommended: 1920x1080px)

3. **Add music:**
   - `music/musik.mp3` - Background music (MP3 format)

## 🎮 Usage

### **Automatic:**
- Loading screen starts automatically on server join
- Music begins after 2 seconds
- Waits for ESX loading
- Automatically fades out

### **Manual:**
- Audio controls top right
- Mute button for mute toggle
- Volume slider for volume
- Click on screen starts music

## 🔒 Security
- **Anti-Developer-Tools** - F12, Ctrl+Shift+I blocked
- **Right-click blocked** - No context menu
- **Source-view blocked** - Ctrl+U disabled
- **Inspect-element blocked** - Developer tools locked

## 📱 Responsive Design
- **Desktop** - Full features
- **Tablet** - Adjusted sizes
- **Mobile** - Optimized touch controls
- **All resolutions** - Automatic scaling

## 📞 Support
- **Discord:** discord.gg/zenscripts
- **GitHub:** github.com/zenscripts/zenesx-framework
- **Version:** 1.0.0

## 📄 License
© 2025 ZenESX Framework - All rights reserved
