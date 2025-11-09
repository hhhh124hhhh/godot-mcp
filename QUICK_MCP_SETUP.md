# 🚀 AI 技能快速配置指南

> **小白用户专享** - 5分钟配置完整的 AI 游戏开发环境

## 🎯 配置目标

配置 4 个核心 AI 技能，让 Claude 智能辅助您的 Godot 游戏开发：

1. **🤖 Context7 自动研究** - 自动获取最新技术文档
2. **🎮 Godot 兼容性检查** - 自动修复版本兼容性问题
3. **🔧 MCP 工具编排** - 智能协调多工具协作
4. **🌏 中文开发指南** - 完整的中文环境支持

## ⚡ 一键配置 (推荐)

### 步骤 1: 下载项目
```bash
git clone https://github.com/hhhh124hhhh/godot-mcp.git
cd godot-mcp
```

### 步骤 2: 运行自动配置脚本
```bash
./setup-mcp-tools.sh
```

**脚本会自动**：
- ✅ 检查您的系统环境
- ✅ 安装所有必需的 MCP 工具
- ✅ 验证 AI 技能文件完整性
- ✅ 生成完整的配置代码
- ✅ 构建 Godot MCP 服务器

### 步骤 3: 配置 Claude Desktop

脚本运行完成后，会显示配置代码，类似这样：

```json
{
  "mcpServers": {
    "godot-mcp": {
      "command": "node",
      "args": ["/您的完整路径/godot-mcp/server/dist/index.js"],
      "env": {
        "MCP_TRANSPORT": "stdio"
      }
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["chrome-devtools-mcp@latest"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["sequential-thinking-mcp"]
    },
    "context7": {
      "command": "npx",
      "args": ["context7-mcp-server"]
    }
  }
}
```

**配置方法**：
1. 复制上面显示的完整配置代码
2. 编辑 Claude Desktop 配置文件：
   - **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - **Linux**: `~/.config/Claude/claude_desktop_config.json`
   - **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
3. 粘贴配置代码并保存文件
4. 重启 Claude Desktop

### 步骤 4: 验证配置

**测试 AI 技能**：
向 Claude 发送消息：
```
如何实现一个简单的 Godot 粒子效果
```

**预期结果**：
- AI 应该自动触发 `context7-auto-research` 技能
- 返回详细的粒子效果实现方案
- 包含代码示例和最佳实践

## 🛠️ 手动配置 (备用方案)

如果自动脚本遇到问题，可以手动配置：

### 1. 安装依赖
```bash
# 确保 Node.js 18+ 已安装
node --version

# 安装项目依赖
cd server
npm install
npm run build
cd ..
```

### 2. 安装 MCP 工具
```bash
# Chrome DevTools MCP
npm install -g chrome-devtools-mcp

# Sequential Thinking MCP
npm install -g sequential-thinking-mcp

# Context7 MCP
npm install -g context7-mcp-server
```

### 3. 配置 Claude Desktop

将上面的配置代码添加到您的 Claude Desktop 配置文件中。

## ✅ 故障排除

### 常见问题

**Q: 脚本无法执行**
```bash
chmod +x setup-mcp-tools.sh
./setup-mcp-tools.sh
```

**Q: Node.js 版本过低**
- 访问 https://nodejs.org 下载最新版本
- 或使用包管理器升级：`brew upgrade node` (macOS)

**Q: MCP 工具连接失败**
```bash
# 检查工具状态
claude mcp list

# 重新安装工具
npm install -g chrome-devtools-mcp sequential-thinking-mcp context7-mcp-server
```

**Q: 技能不触发**
- 检查 `.claude/skills/` 目录是否存在
- 确认技能文件格式正确
- 重启 Claude Desktop

### 获取帮助

1. **查看日志**: Claude Desktop 会显示连接状态
2. **检查配置**: 确保 JSON 格式正确
3. **重启服务**: 重启 Claude Desktop 和 Godot 编辑器
4. **GitHub Issues**: 报告问题到项目仓库

## 🎮 开始使用

配置完成后，您可以：

**自动文档查询**：
```
"如何在 Godot 4.x 中实现动态光照"
```

**兼容性检查**：
```
"检查我的 Godot 项目是否有 API 兼容性问题"
```

**复杂任务自动化**：
```
"创建一个完整的角色控制器系统"
```

**中文环境配置**：
```
"如何配置支持中文的 Godot 开发环境"
```

---

**配置完成时间**: 约 5-10 分钟
**难度等级**: ⭐ (适合完全小白)
**成功率**: 95%+ (在正常网络环境下)

开始享受 AI 驱动的游戏开发体验吧！🚀