# 🚀 快速开始指南

5分钟内体验 AI 自动化游戏开发的强大能力！

## 📋 前置要求

- **Godot Engine 4.2+** ([下载地址](https://godotengine.org/download))
- **Node.js 18+** ([下载地址](https://nodejs.org))
- **Claude Desktop** ([下载地址](https://claude.ai/download))

## ⚡ 快速安装

### 1. 克隆项目
```bash
git clone https://github.com/hhhh124hhhh/godot-mcp.git
cd godot-mcp
```

### 2. 安装依赖
```bash
cd server
npm install
npm run build
cd ..
```

### 3. 配置 Claude Desktop

编辑 Claude Desktop 配置文件：

**macOS**:
```bash
nano ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

**Linux**:
```bash
nano ~/.config/claude/claude_desktop_config.json
```

**Windows**:
编辑 `%APPDATA%\Claude\claude_desktop_config.json`

添加以下配置：
```json
{
  "mcpServers": {
    "godot-mcp": {
      "command": "node",
      "args": ["YOUR_ABSOLUTE_PATH/server/dist/index.js"],
      "env": {
        "MCP_TRANSPORT": "stdio"
      }
    }
  }
}
```

> **重要**: 将 `YOUR_ABSOLUTE_PATH` 替换为项目的绝对路径

### 4. 重启 Claude Desktop

配置完成后，重启 Claude Desktop 使配置生效。

## 🎮 运行示例项目

### 1. 打开 Godot 项目
```bash
# 在 Godot 编辑器中打开
examples/bubble-game-demo/project.godot
```

### 2. 启动 MCP 服务器
```bash
cd server
npm run dev
```

### 3. 在 Godot 中运行游戏
- 确保插件已启用（项目设置 → 插件 → Godot MCP）
- 按 F5 运行项目
- 体验 AI 自动开发的泡泡游戏！

## 🤖 体验 AI 开发

### 示例1: 自动修复兼容性问题

```
向 Claude 发送:
"我的 Godot 项目遇到兼容性错误，请帮我修复"

AI 会自动:
1. 检测项目中的 API 兼容性问题
2. 自动修复 Tween、Gradient、粒子系统等问题
3. 验证修复效果
```

### 示例2: 查询最新技术文档

```
向 Claude 发送:
"如何在 Godot 4.x 中实现动态粒子效果"

AI 会自动:
1. 触发 Context7 自动研究
2. 查询最新 Godot 4.x 文档
3. 提供完整的实现代码
4. 包含最佳实践建议
```

### 示例3: 创建新功能

```
向 Claude 发送:
"为泡泡游戏添加一个得分排行榜功能"

AI 会自动:
1. 分析现有代码结构
2. 设计排行榜系统
3. 生成完整的 GDScript 代码
4. 创建相应的 UI 界面
```

## 🛠️ 常用 AI 命令

### 兼容性检查
```
"检查我的项目 Godot 版本兼容性"
"修复这些 Godot 4.x API 问题"
"提供 Godot 升级建议"
```

### 代码生成
```
"创建一个玩家角色控制器"
"实现敌人 AI 行为"
"添加音效管理系统"
```

### 性能优化
```
"优化游戏性能"
"减少内存占用"
"提高帧率到 60 FPS"
```

### UI 设计
```
"创建游戏主菜单"
"设计设置界面"
"添加暂停菜单"
```

## 🔧 故障排除

### 常见问题

**Q: Claude 提示 "MCP 服务器连接失败"**
```
A:
1. 检查服务器是否运行: cd server && npm run dev
2. 确认配置文件路径正确
3. 重启 Claude Desktop
```

**Q: Godot 中插件无法启用**
```
A:
1. 确保使用 Godot 4.2+
2. 检查 addons/godot_mcp/plugin.godot 是否存在
3. 重启 Godot 编辑器
```

**Q: AI 技能不触发**
```
A:
1. 检查 .claude/skills/ 目录是否存在
2. 确认技能文件格式正确
3. 尝试重新配置 Claude Desktop
```

### 调试技巧

1. **查看 Godot 控制台**: 检查插件日志和错误信息
2. **检查 MCP 服务器**: 确认服务器正常运行且无错误
3. **验证配置文件**: 确保路径和参数设置正确
4. **重启所有服务**: Claude Desktop、Godot、MCP 服务器

## 📚 学习资源

### 推荐学习路径

1. **基础使用** → 运行示例项目，体验基本功能
2. **技能系统** → 了解 4 个核心 AI 技能的使用
3. **MCP 工具** → 学习 15+ 专业工具的应用
4. **项目开发** → 尝试 AI 自动开发新项目

### 文档资源

- **[完整 README](README.md)**: 详细的功能介绍和配置说明
- **[项目概览](PROJECT_OVERVIEW.md)**: 项目整体介绍和愿景
- **[AI 开发指南](docs/user-guide/ai-development-guide.md)**: 深入的 AI 开发教程
- **[示例项目说明](examples/README.md)**: 示例项目详细介绍

### 视频教程（计划中）

- [ ] 5分钟快速上手
- [ ] AI 技能详解
- [ ] 完整项目开发演示
- [ ] 高级功能使用技巧

## 🎯 下一步

### 尝试这些任务

1. **创建自己的游戏**:
   ```
   "帮我创建一个简单的平台跳跃游戏"
   ```

2. **优化现有项目**:
   ```
   "分析并优化我的游戏性能"
   ```

3. **学习新技术**:
   ```
   "教我如何使用 Godot 的着色器系统"
   ```

### 加入社区

- **GitHub Issues**: 报告问题和功能请求
- **Discord 社区**: 与其他用户交流经验
- **贡献代码**: 参与项目开发

---

**开始你的 AI 游戏开发之旅吧！有任何问题，欢迎随时向我们求助。** 🚀