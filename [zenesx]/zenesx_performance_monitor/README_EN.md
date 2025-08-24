# ZenESX Performance Monitor

## 🎯 Overview
The ZenESX Performance Monitor monitors server performance in real-time and provides detailed insights into resource consumption and optimization opportunities.

## 🚀 Features
- **Real-time Monitoring** - Live performance data
- **Resource Monitoring** - CPU, RAM, Network
- **Script Performance** - Individual resource analysis
- **Automatic Alerts** - Performance thresholds
- **Performance Reports** - Detailed analyses

## ⌨️ Commands & Keybinds

### **Performance Monitoring**
- **/perf status** - Show current performance status
- **/perf monitor** - Open performance monitor
- **/perf live** - Start live performance data

### **Resource Analysis**
- **/perf resources** - All resources with performance data
- **/perf resource [name]** - Analyze specific resource
- **/perf top** - Top 10 performance resources

### **Performance Reports**
- **/perf report** - Generate performance report
- **/perf export** - Export performance data
- **/perf history** - Show performance history

### **Admin Commands**
- **/perf alert [on/off]** - Toggle performance alerts
- **/perf threshold [cpu/ram] [value]** - Set thresholds
- **/perf optimize** - Start automatic optimization

## 🔧 Configuration

### **Performance Thresholds**
```lua
-- Configurable in configuration
PerformanceThresholds = {
    cpu_warning = 80,      -- CPU warning at 80%
    cpu_critical = 95,     -- CPU critical at 95%
    ram_warning = 85,      -- RAM warning at 85%
    ram_critical = 95      -- RAM critical at 95%
}
```

### **Monitoring Settings**
```lua
-- Monitor configuration
MonitorConfig = {
    update_interval = 1000,    -- Update every 1000ms
    log_performance = true,    -- Log performance
    auto_optimize = false,     -- Automatic optimization
    alert_discord = true       -- Discord notifications
}
```

## 📋 Installation
1. **Include resource in server.cfg:**
   ```cfg
   ensure zenesx_performance_monitor
   ```

2. **Set permissions:**
   ```cfg
   add_ace group.admin command.perf allow
   add_ace group.admin command.zenesx allow
   ```

3. **Adjust configuration:**
   ```lua
   -- In config.lua
   PerformanceConfig = {
       enabled = true,
       log_level = "info",
       discord_webhook = "your_webhook_url"
   }
   ```

## 🎮 Usage

### **As Admin:**
1. **Monitor performance:** `/perf monitor`
2. **Analyze resources:** `/perf resources`
3. **Generate reports:** `/perf report`

### **As Moderator:**
- Only view performance status
- No configuration possible
- Show performance reports

## 📊 Performance Metrics

### **CPU Performance**
- **Current load** - Live CPU consumption
- **Average** - 1h, 24h, 7 days
- **Peak values** - Highest CPU load

### **RAM Usage**
- **Used memory** - Current RAM consumption
- **Available memory** - Free RAM
- **Memory leaks** - Detect memory leaks

### **Network Performance**
- **Bandwidth** - Input/output
- **Latency** - Ping times
- **Connections** - Active connections

## 🔒 Security
- **Admin permission** for all configurations
- **Audit logging** of all performance actions
- **Data encryption** for sensitive metrics
- **Rate limiting** for commands

## 📈 Optimization Tips
- **Set resource priorities**
- **Disable unnecessary scripts**
- **Optimize database indexes**
- **Implement cache systems**

## 📞 Support
- **Discord:** discord.gg/zenscripts
- **GitHub:** github.com/zenscripts/zenesx-framework
- **Version:** 1.0.0

## 📄 License
© 2025 ZenESX Framework - All rights reserved

