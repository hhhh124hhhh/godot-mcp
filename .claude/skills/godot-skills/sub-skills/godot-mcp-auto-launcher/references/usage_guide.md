# Godot MCP 自动启动使用指南

## 概述

本指南介绍如何使用`godot-mcp-auto-launcher`技能中的脚本，自动启动Godot MCP服务器，确保开发环境始终可用。

## 为什么需要自动启动？

在Godot项目中使用MCP工具时，需要确保：
1. MCP服务器已启动并监听指定端口
2. Godot编辑器中的MCP插件已连接到服务器
3. 如果服务器崩溃，能够自动恢复

手动启动这些服务容易遗忘或出错，自动化可以大大简化工作流程。

## 可用脚本

### 1. start_mcp_server.py

基础启动脚本，用于启动、停止和检查MCP服务器状态。

**功能：**
- 启动MCP服务器
- 检查服务器状态
- 停止服务器
- 重启服务器

**使用方法：**

```bash
# 启动MCP服务器
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start_mcp_server.py start

# 检查服务器状态
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start_mcp_server.py status

# 停止服务器
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start_mcp_server.py stop

# 重启服务器
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start_mcp_server.py restart
```

### 2. monitor_mcp_server.py

监控守护进程，持续监控MCP服务器并在崩溃时自动重启。

**功能：**
- 持续监控MCP服务器状态
- 服务器停止时自动重启
- 记录所有事件到日志文件
- 防止无限重启（最大尝试次数限制）
- 后台守护模式

**使用方法：**

```bash
# 启动监控（前台模式，按Ctrl+C停止）
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/monitor_mcp_server.py start

# 后台启动监控（守护进程）
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/monitor_mcp_server.py start --daemon

# 停止监控
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/monitor_mcp_server.py stop

# 查看监控状态
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/monitor_mcp_server.py status

# 重启监控
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/monitor_mcp_server.py restart --daemon

# 自定义检查间隔（每30秒检查一次）
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/monitor_mcp_server.py start --daemon --interval 30
```

**查看日志：**

```bash
# 实时监控日志
tail -f /tmp/godot_mcp_monitor.log

# 查看最近100条日志
tail -n 100 /tmp/godot_mcp_monitor.log
```

**监控日志示例：**

```
[2025-11-15 20:30:15] ============================================================
[2025-11-15 20:30:15] MCP监控守护进程启动 - 2025-11-15 20:30:15.123456
[2025-11-15 20:30:15] ============================================================
[2025-11-15 20:30:15] 开始监控MCP服务器...
[2025-11-15 20:30:15] MCP服务器未运行，正在初始化...
[2025-11-15 20:30:15] 🚀 正在启动Godot MCP服务器（端口 9080）...
[2025-11-15 20:30:20] ✅ MCP服务器已成功启动 (PID: 12345)
[2025-11-15 20:30:20] ✅ MCP服务器启动成功
[2025-11-15 20:30:20] MCP服务器已在运行，开始监控...
```

### 3. launch_godot_with_mcp.py

一键启动Godot和MCP服务器，提供完整的开发环境。

**功能：**
- 自动启动MCP服务器
- 等待服务器就绪
- 启动Godot编辑器
- 自动检测Godot安装位置
- 可配置是否等待Godot关闭

**使用方法：**

```bash
# 启动Godot + MCP完整开发环境
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/launch_godot_with_mcp.py

# 自动检测Godot并启动
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/launch_godot_with_mcp.py --detect

# 指定Godot路径和项目路径
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/launch_godot_with_mcp.py \
  --godot /path/to/godot \
  --project /path/to/godot/project

# 仅启动MCP服务器（不启动Godot）
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/launch_godot_with_mcp.py --no-godot

# 后台启动（不等待Godot关闭）
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/launch_godot_with_mcp.py --no-wait
```

## 推荐工作流程

### 方式1：开发时手动启动

每次开始开发前，手动启动MCP服务器：

```bash
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start_mcp_server.py start
```

然后在Godot中打开项目即可。

**优点：**简单直接，完全控制
**缺点：**容易忘记启动，需要手动操作

### 方式2：使用监控守护进程（推荐）

在后台运行监控守护进程，它会持续监控并自动重启MCP服务器：

```bash
# 启动一次，长期有效
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/monitor_mcp_server.py start --daemon

# 停止时运行
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/monitor_mcp_server.py stop
```

**优点：**
- 自动恢复，无需手动干预
- 后台运行，不影响工作
- 记录日志，便于排查问题

**缺点：**占用少量系统资源

### 方式3：一键启动完整环境

使用集成脚本一键启动所有服务：

```bash
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/launch_godot_with_mcp.py
```

**优点：**
- 一键启动所有服务
- 确保正确的启动顺序
- 自动检测配置

**缺点：**需要每次都运行脚本

### 方式4：创建桌面快捷方式（最佳体验）

创建桌面快捷方式，双击即可启动完整开发环境：

**Linux (GNOME/KDE):**

创建文件 `~/Desktop/Godot_MCP.desktop`:

```ini
[Desktop Entry]
Name=Godot + MCP
Comment=启动Godot和MCP服务器
Exec=python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/launch_godot_with_mcp.py
Icon=godot
Terminal=true
Type=Application
Categories=Development;
```

然后设置可执行权限：

```bash
chmod +x ~/Desktop/Godot_MCP.desktop
```

**Windows:**

创建批处理文件 `Godot_MCP.bat`:

```batch
@echo off
echo 正在启动Godot + MCP...
python3 "/mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/launch_godot_with_mcp.py"
pause
```

然后在桌面创建该文件的快捷方式。

## 故障排除

### 问题1：端口被占用

**症状：**
```
Error: listen EADDRINUSE: address already in use :::9080
```

**解决方案：**

```bash
# 查找占用端口的进程
lsof -i :9080

# 如果是MCP服务器的旧实例，重启即可
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start_mcp_server.py restart

# 如果是其他进程，结束它或更换MCP端口
```

### 问题2：找不到Python解释器

**症状：**
```
python3: command not found
```

**解决方案：**

```bash
# 检查Python安装
which python3

# 如果没有，安装Python
# Ubuntu/Debian:
sudo apt install python3

# macOS:
brew install python3

# Windows: 从python.org下载安装
```

### 问题3：找不到Godot

**症状：**
```
找不到Godot可执行文件: godot
```

**解决方案：**

```bash
# 方法1: 使用--detect参数自动检测
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/launch_godot_with_mcp.py --detect

# 方法2: 手动指定Godot路径
python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/launch_godot_with_mcp.py \
  --godot /Applications/Godot.app/Contents/MacOS/Godot

# 方法3: 将Godot添加到PATH
export PATH="/path/to/godot:$PATH"
```

### 问题4：MCP服务器崩溃

**症状：**服务器意外停止，监控日志显示重启尝试失败。

**解决方案：**

1. 查看详细日志：
```bash
tail -f /tmp/godot_mcp_monitor.log
```

2. 检查MCP服务器日志：
```bash
cd /mnt/d/godot-mcp/server
cat dist/*.log 2>/dev/null || echo "暂无日志"
```

3. 常见问题：
- 依赖未安装：`cd /mnt/d/godot-mcp/server && npm install`
- 构建失败：`cd /mnt/d/godot-mcp/server && npm run build`
- 端口冲突：修改端口或结束占用进程

## 最佳实践

1. **推荐配置：**
   ```bash
   # 在~/.bashrc或~/.zshrc中添加别名
   alias start-mcp="python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/launch_godot_with_mcp.py"
   alias mcp-status="python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start_mcp_server.py status"
   alias mcp-stop="python3 /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start_mcp_server.py stop"
   ```

2. **长期使用建议：**
   - 在系统启动时自动启动监控守护进程
   - 定期检查日志文件大小，及时清理
   - 为不同项目创建不同的启动快捷方式

3. **性能优化：**
   - 根据实际需求调整检查间隔（默认10秒）
   - 闲置时停止监控以节省资源
   - 使用--no-wait模式在后台启动Godot

## 总结

三种脚本提供了不同层次的自动化：

- **`start_mcp_server.py`**：基础功能，手动控制
- **`monitor_mcp_server.py`**：中级自动化，自动重启
- **`launch_godot_with_mcp.py`**：高级集成，一键启动

**推荐组合：**
- 日常使用：`monitor_mcp_server.py`（后台守护）
- 快速启动：`launch_godot_with_mcp.py`（桌面快捷方式）
- 调试问题：`start_mcp_server.py`（手动控制）

选择最适合你工作流程的方式，提高开发效率！
