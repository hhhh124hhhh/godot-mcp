---
name: godot-mcp-auto-launcher
description: 使用此技能自动启动Godot MCP服务器，确保在Godot项目启动时MCP工具可用。当需要确保MCP连接就绪或在项目启动时自动初始化MCP工具时触发。
---

# Godot MCP 自动启动器

## 技能目标

本技能负责自动检测和启动Godot MCP服务器，确保AI助手能够通过MCP工具与Godot编辑器通信。该技能提供完整的自动化流程，无需人工干预即可建立MCP连接。

## 使用场景

在以下情况中使用此技能：

1. **Godot项目启动时** - 确保MCP服务器随Godot编辑器一起启动
2. **MCP连接不可用** - 检测到MCP工具无法连接时自动启动服务器
3. **开发环境初始化** - 设置新的Godot+MCP开发环境
4. **MCP服务器意外关闭** - 自动重启意外终止的MCP服务器

## 操作流程

### 1. 检查MCP连接状态

首先检查MCP Node.js客户端是否已经连接到Godot：

```bash
# 使用Node.js脚本检查状态
node /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start-mcp.js status

# 或者直接检查端口
lsof -i :9080  # 查看Godot是否在监听9080端口
```

### 2. 启动MCP客户端

如果MCP客户端未运行，使用以下命令启动：

```bash
# 使用Node.js启动脚本（推荐）
node /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start-mcp.js start
```

**注意：** 启动前请确保Godot编辑器已打开且MCP插件已启用。

启动脚本会自动：
1. 检查MCP客户端是否已在运行
2. 构建MCP服务器（如果需要）
3. 启动MCP Node.js客户端
4. 保存进程PID以便后续管理

MCP客户端会自动尝试连接到Godot WebSocket服务器（端口9080）。

### 3. 验证连接

启动后验证MCP连接是否正常：

```bash
# 检查状态
node /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start-mcp.js status

# 查看日志
 tail -f /tmp/mcp_launcher.log
```

### 4. 管理MCP客户端

停止MCP客户端：

```bash
node /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start-mcp.js stop
```

重启MCP客户端：

```bash
node /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start-mcp.js restart
```

显示帮助信息：

```bash
node /mnt/d/godot-mcp/.claude/skills/godot-mcp-auto-launcher/scripts/start-mcp.js --help
```

## 重要规则

### ⚠️ 禁止直接操作Godot文件

**绝对禁止**直接读取、写入或修改Godot项目文件（.tscn, .gd, .tres等）。所有与Godot文件的交互必须通过MCP工具完成。

✅ **正确做法**：使用MCP工具
- 使用 `create_node` 创建节点
- 使用 `update_node_property` 修改节点属性
- 使用 `create_script` 创建脚本
- 使用 `get_script` 读取脚本内容

❌ **错误做法**：直接操作文件
- 不要使用Read工具读取.tscn文件
- 不要使用Edit工具修改.gd文件
- 不要使用Write工具创建Godot资源文件

### 自动化启动的最佳实践

1. **错误处理**：启动失败时提供清晰的错误信息
2. **日志记录**：记录启动过程中的所有关键步骤
3. **状态检查**：在启动前后都进行状态验证
4. **优雅关闭**：提供关闭服务器的机制

## 故障排除

### 问题：端口已被占用

如果端口9080已被其他应用占用：

```bash
# 查找占用端口的进程
lsof -i :9080

# 如果是Godot MCP的旧实例，先终止它
kill -9 <PID>

# 然后重新启动
npm run dev
```

### 问题：MCP工具连接失败

如果MCP工具无法连接到服务器：

1. 检查防火墙设置，确保端口9080未被阻止
2. 确认MCP服务器日志中没有错误
3. 检查Godot插件配置，确认WebSocket地址正确
4. 尝试重启Godot编辑器

### 问题：npm命令执行失败

如果npm命令执行失败：

```bash
# 先安装依赖
cd /mnt/d/godot-mcp/server && npm install

# 然后重新构建
npm run build

# 最后启动
npm start
```

## 示例

### 完整启动流程示例

```bash
# 1. 检查服务器状态
echo "检查MCP服务器状态..."
lsof -i :9080

# 2. 如果未运行，启动服务器
if [ $? -ne 0 ]; then
    echo "MCP服务器未运行，正在启动..."
    cd /mnt/d/godot-mcp/server
    npm run dev &
    sleep 3
fi

# 3. 验证启动成功
echo "验证MCP服务器..."
curl -s http://localhost:9080 > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ MCP服务器已成功启动"
else
    echo "❌ MCP服务器启动失败"
fi
```

### 集成到Godot启动脚本

可以将此技能集成到Godot项目的启动流程中，确保每次打开项目时MCP自动可用。
