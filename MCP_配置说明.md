# Godot MCP 全局配置说明

## 配置文件位置
已创建 Claude Desktop 配置文件：`~/.config/claude/claude_desktop_config.json`

## 配置内容
```json
{
  "mcpServers": {
    "godot-mcp": {
      "command": "node",
      "args": [
        "/mnt/d/godot-mcp/server/dist/index.js"
      ],
      "env": {
        "MCP_TRANSPORT": "stdio"
      }
    }
  }
}
```

## 使用方法

### 1. 启动开发环境
```bash
# 终端 1: 启动 Godot 项目
cd /mnt/d/godot-mcp
godot --editor project.godot

# 终端 2: 确保服务器已构建（如果需要）
cd /mnt/d/godot-mcp/server
npm run build
```

### 2. 重启 Claude Desktop
配置完成后，需要重启 Claude Desktop 以加载新的 MCP 服务器。

### 3. 验证连接
在 Claude 中使用以下命令测试连接：
```
@mcp godot-mcp get-project-info
```

## 工作流程

1. **Godot 端**: 打开项目，MCP 插件自动启动 WebSocket 服务器（端口 9080）
2. **Claude 端**: 通过 MCP 协议与 Node.js 服务器通信
3. **服务器**: 作为桥梁，将 Claude 的命令转发给 Godot

## 可用命令类别
- **节点操作**: 创建、修改、删除场景节点
- **脚本操作**: 读取、编辑、创建 GDScript 文件
- **场景操作**: 管理场景文件和结构
- **项目操作**: 访问项目设置和资源
- **编辑器操作**: 控制 Godot 编辑器功能

## 注意事项
- 确保 Godot 项目在后台运行时插件已启用
- WebSocket 连接使用本地端口 9080
- 如果连接失败，检查 Godot 控制台的错误信息