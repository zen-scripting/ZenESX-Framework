# ZenESX Framework - Changelog

## Version 1.0.0 - Initial Release

### 🎉 **Major Features Added**

#### **📁 Modular Resource Structure**
- **Separated Systems** - Each system now has its own resource folder
- **Individual fxmanifest.lua** - Every system is independently configurable
- **Clean Architecture** - Better organization and maintainability

#### **🔄 GitHub Auto-Update System**
- **`zenesx_update_system/`** - Automatic GitHub integration
- **Real-time Update Checks** - Every hour for new versions
- **txAdmin Integration** - Updates shown in txAdmin panel
- **Discord Webhooks** - Update notifications
- **Commands:** `/zenesx:checkupdate`, `/zenesx:version`, `/zenesx:help`

#### **👨‍💻 Enhanced Admin System**
- **`zenesx_admin_system/`** - Complete admin management
- **F5 Admin Menu** - Modern UI with role-based access
- **Admin Levels** - God (5), Admin (4), Mod (3), Helper (2), User (1)
- **Full Command Set** - Teleport, Heal, Kick, Give Money, Set Job, Noclip, Invisible
- **Complete Logging** - All admin actions logged with Discord integration
- **Permission System** - ACE-based permissions

#### **📊 Performance Monitoring System**
- **`zenesx_performance_monitor/`** - Real-time server monitoring
- **Live Stats** - Tick time, memory usage, player count, resources
- **Automatic Alerts** - Performance issue notifications
- **Discord Integration** - Critical alerts via Discord
- **Commands:** `/perf`, `/resources`

#### **💾 Automatic Backup System**
- **`zenesx_backup_system/`** - Automated database backups
- **Hourly Backups** - Automatic database backups every hour
- **Compression & Cleanup** - Automatic compression and old backup cleanup
- **Backup Rotation** - Keep maximum 24 backups (configurable)
- **Discord Notifications** - Backup status notifications
- **Commands:** `/backup create`, `/backup status`

#### **🎵 Enhanced Loading Screen**
- **`loading_screen/`** - Separate resource with own manifest
- **Background Music** - Custom music with audio controls
- **Audio Controls** - Mute/Unmute button and volume slider
- **Modern Design** - Responsive design with animations
- **Framework Showcase** - Display of framework features

#### **🏦 Premium Banking Integration**
- **`zs_banking/`** - Complete banking system
- **Crypto Trading** - Bitcoin, Ethereum, Cardano support
- **Player Transfers** - Money transfers between players
- **Transaction History** - Complete banking history
- **Premium UI** - Modern banking interface
- **Sound Effects** - Enhanced user experience

#### **🏝️ Cayo Perico Complete Package**
- **`[cayo]/`** - 5 separate Cayo Perico mods
- **Cayo Bridge** - Driveable connection to the island
- **Cayo Shops** - Bank and shopping MLOs
- **Mansion Gate** - El Rubio's mansion gate system
- **Extended Minimap** - Full island map integration
- **79 Stream Files** - Detailed island modifications

### 🔧 **Technical Improvements**

#### **Server Configuration**
- **Enhanced server.cfg** - All new systems integrated
- **Resource Organization** - Clear resource loading order
- **Performance Optimized** - Optimized loading sequence

#### **Database Schema**
- **zen.sql** - Complete database schema
- **ZS Banking Tables** - Banking system integration
- **Performance Indexes** - Optimized database performance

#### **Recipe Integration**
- **recipe.yaml** - txAdmin deployment recipe
- **GitHub Integration** - Automatic update support
- **Feature Documentation** - Complete feature list

### 📚 **Documentation**

#### **Complete Documentation Package**
- **README.md** - English documentation
- **INSTALLATION.md** - Detailed installation guide
- **Individual README files** - For each system component

#### **Support Resources**
- **Troubleshooting Guide** - Common issues and solutions
- **Configuration Examples** - Setup examples
- **Command Reference** - All available commands

### 🎮 **New Commands**

#### **Admin Commands**
```bash
/tp [PlayerID]                    # Teleport to player
/bring [PlayerID]                 # Bring player to you
/heal [PlayerID]                  # Heal player (empty = self)
/revive [PlayerID]                # Revive player
/zkick [PlayerID] [Reason]        # Kick player
/givemoney [PlayerID] [Account] [Amount] # Give money
/setjob [PlayerID] [Job] [Grade]  # Set player job
/noclip                           # Toggle noclip
/invisible                        # Toggle invisible
/players                          # Show online players
```

#### **Performance Commands**
```bash
/perf                            # Show server performance
/resources                       # Show resource memory usage
```

#### **Backup Commands**
```bash
/backup create                   # Create manual backup
/backup status                   # Show backup status
```

#### **Update Commands**
```bash
/zenesx:checkupdate             # Manual update check
/zenesx:version                 # Show framework version
/zenesx:help                    # Show available commands
```

### 🔐 **Security & Permissions**

#### **ACE Permission System**
```cfg
# God Level (5) - Full access
add_ace group.admin zenesx.god allow

# Admin Level (4) - Administrative commands
add_ace group.admin zenesx.admin allow

# Moderator Level (3) - Moderation commands
add_ace group.moderator zenesx.mod allow

# Helper Level (2) - Basic helper commands
add_ace group.helper zenesx.helper allow
```

#### **Discord Integration**
- **Admin Logs** - All admin actions logged to Discord
- **Performance Alerts** - Critical performance issues
- **Backup Notifications** - Backup success/failure status
- **Update Notifications** - New version announcements

### 📁 **Final Structure**

```
ZenESX Framework/
├── 📄 server.cfg                  # Complete server configuration
├── 📄 recipe.yaml                 # txAdmin deployment recipe
├── 📄 zen.sql                     # Database schema
├── 📄 README.md                   # English documentation
├── 📄 INSTALLATION.md             # Installation guide
├── 📄 CHANGELOG.md                # This file
├── 🎵 loading_screen/             # Custom loading screen (separate resource)
├── 🏦 zs_banking/                 # Banking system (separate resource)
├── 🔄 zenesx_update_system/       # GitHub updates (separate resource)
├── 👨‍💻 zenesx_admin_system/        # Admin system (separate resource)
├── 📊 zenesx_performance_monitor/ # Performance monitoring (separate resource)
├── 💾 zenesx_backup_system/       # Backup system (separate resource)
└── 🏝️ [cayo]/                    # Cayo Perico mods (separate resources)
```

### 🚀 **Installation Ready**

The ZenESX Framework is now completely ready for deployment with:
- ✅ **Modular Architecture** - Each system as separate resource
- ✅ **GitHub Integration** - Automatic update notifications
- ✅ **Complete Admin System** - Full admin management
- ✅ **Performance Monitoring** - Real-time server monitoring
- ✅ **Automatic Backups** - Database backup automation
- ✅ **Premium Banking** - ZS Banking integration
- ✅ **Cayo Perico Integration** - Complete island experience
- ✅ **Custom Loading Screen** - With music and controls
- ✅ **Professional Documentation** - Complete setup guides

### 🎯 **Next Steps**

1. **Deploy via txAdmin** using the included recipe.yaml
2. **Configure Discord Webhooks** for notifications
3. **Set up Admin Permissions** using ACE system
4. **Configure Banking System** in zs_banking/config.lua
5. **Add Loading Screen Music** (musik.mp3)
6. **Test All Systems** with included commands

---

**The ZenESX Framework is ready for production use! 🎉**
