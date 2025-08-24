# ZenESX Admin System

## 🎯 Overview
The ZenESX Admin System provides advanced admin tools for server administrators with different permission levels.

## 🚀 Features
- **Noclip System** - Fly through walls and objects
- **Invisible Mode** - Become invisible to other players
- **Player Healing** - Instantly heal players
- **Teleport System** - Teleport to other players
- **Admin Menu** - Complete admin interface

## ⌨️ Commands & Keybinds

### **Admin Menu**
- **F5** - Open admin menu
- **/admin** - Open admin menu via chat

### **Noclip System**
- **F6** - Toggle noclip on/off
- **/noclip** - Control noclip via chat

### **Invisible Mode**
- **F7** - Toggle invisibility on/off
- **/invisible** - Control invisibility via chat

### **Player Healing**
- **F8** - Instantly heal player
- **/heal** - Healing via chat

### **Teleport System**
- **/goto [ID]** - Teleport to player
- **/bring [ID]** - Teleport player to you

## 🔧 Configuration

### **Permission Levels**
```lua
-- Configurable in configuration
AdminLevels = {
    ["superadmin"] = 3,    -- All permissions
    ["admin"] = 2,         -- Extended permissions
    ["moderator"] = 1      -- Basic permissions
}
```

### **Customize Keybinds**
```lua
-- Changeable in configuration
AdminMenuKey = 166,        -- F5
NoclipKey = 167,           -- F6
InvisibleKey = 168,        -- F7
HealKey = 169              -- F8
```

## 📋 Installation
1. **Include resource in server.cfg:**
   ```cfg
   ensure zenesx_admin_system
   ```

2. **Set permissions:**
   ```cfg
   add_ace group.admin command allow
   add_ace group.admin command.zenesx allow
   ```

## 🎮 Usage

### **As Admin:**
1. **Press F5** for admin menu
2. **Select player** from list
3. **Choose action** (Heal, Teleport, etc.)
4. **Confirm** the action

### **As Moderator:**
- Limited permissions
- Only basic admin functions
- No player bans or kicks

## 🔒 Security
- **Server-side validation** of all admin actions
- **Permission checking** before each action
- **Logging** of all admin activities
- **Anti-abuse** protection measures

## 📞 Support
- **Discord:** discord.gg/zenscripts
- **GitHub:** github.com/zenscripts/zenesx-framework
- **Version:** 1.0.0

## 📄 License
© 2025 ZenESX Framework - All rights reserved
