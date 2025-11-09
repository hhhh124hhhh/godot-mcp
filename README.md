# Godot MCP (Model Context Protocol)

一个全面的 Godot 引擎与 AI 助手的集成解决方案，使用模型上下文协议 (MCP) 实现。该插件允许 AI 助手与您的 Godot 项目进行交互，提供强大的代码辅助、场景操作和项目管理功能。

## 🌟 主要特性

### 🤖 智能技能系统
- **Context7 自动研究**: 自动获取最新的 Godot 文档和最佳实践
- **Godot 兼容性检查器**: 自动检测和修复 Godot 3.x 到 4.x 的 API 兼容性问题
- **MCP 编排工具**: 智能协调多个 MCP 工具完成复杂开发任务
- **中文开发指南**: 为中文开发者提供完整的本地化配置和开发指导

### 🔧 强大的 MCP 工具集
- **Godot 兼容性工具**:
  - `detect_godot_version` - 检测项目 Godot 版本
  - `check_godot_api_compatibility` - 检查 API 兼容性问题
  - `fix_godot_api_compatibility` - 自动修复兼容性问题
  - `get_godot_migration_advice` - 获取版本迁移建议

- **标准开发工具**:
  - **节点工具**: 创建、修改、删除节点
  - **脚本工具**: 编辑、分析、创建 GDScript 文件
  - **场景工具**: 操作场景和结构
  - **编辑器工具**: 控制编辑器功能

- **增强开发工具**:
  - **Chrome DevTools**: 网页调试和性能分析
  - **Sequential Thinking**: 结构化思维和问题分解
  - **Context7**: 获取最新库文档和 API 信息

### 🎯 自动化代码生成
- **智能触发**: 当需要代码生成、配置步骤或库文档查询时，自动使用 Context7 MCP 工具
- **实时文档查询**: 无需明确请求，系统自动获取最新技术文档
- **最佳实践应用**: 结合项目实际情况提供最优解决方案

## 🎮 技术基础：Godot 引擎

godot-mcp 基于 **Godot 4.x** 引擎构建，这是我们的技术基础和AI自动开发的平台。

### ⚙️ Godot 4.x 系统要求
- **推荐版本**: Godot 4.3+ (兼容 4.2+)
- **支持平台**: Windows 10+、macOS 10.13+、Linux (Ubuntu 18.04+)
- **下载地址**: [官方下载页面](https://godotengine.org/download/)

### 🎯 为什么选择 Godot 作为基础引擎？

#### 1. **AI 友好架构**
- 结构化的项目文件格式
- 清晰的 API 设计和命名规范
- 完整的节点系统和场景管理
- 热重载功能，实时查看修改效果

#### 2. **轻量级且强大**
- 完全免费、开源
- 零配置即可开始开发
- 丰富的内置功能，减少开发时间
- 跨平台导出支持

#### 3. **现代化技术栈**
- 全新的 Vulkan 渲染后端
- 改进的物理引擎和 UI 系统
- 支持多线程渲染和资源优化

### 🛠️ 与 godot-mcp 的集成优势

**godot-mcp** 通过 MCP 协议将 AI 能力与 Godot 引擎无缝集成：

- 🤖 **AI 驱动开发**: 自然语言命令自动生成代码和配置
- 🔧 **智能工具**: 节点操作、脚本编辑、场景管理等
- 🎨 **自动化测试**: AI 辅助的功能验证和问题排查
- 📚 **实时学习**: 自动获取最新 Godot 文档和最佳实践

### 📚 Godot 学习资源
- **官方文档**: https://docs.godotengine.org/
- **示例项目**: https://github.com/godotengine/godot-demo-projects
- **社区资源**: https://godotengine.org/asset-library/

## 🚀 快速开始

> 📖 **新手推荐**: 查看 [5分钟快速开始指南](QUICK_START.md) 立即体验 AI 自动开发！

### 1. 克隆仓库

```bash
git clone https://github.com/hhhh124hhhh/godot-mcp.git
cd godot-mcp
```

### 2. 🎮 安装 Godot 引擎

> **系统要求**: Godot 4.2+ (推荐 4.3 或更高版本)

#### 快速安装方式
```bash
# macOS (使用 Homebrew)
brew install --cask godot

# Windows (使用 Chocolatey)
choco install godot

# Ubuntu/Debian
sudo apt update
sudo apt install godot4
```

> **提示**: 也可从 [Godot 官网](https://godotengine.org/download/) 或 Steam 商店下载

#### 验证安装
```bash
godot --version
# 应显示: 4.x.stable.official [hash]
```

### 3. 设置 MCP 服务器

```bash
cd server
npm install
npm run build
# 返回项目根目录
cd ..
```

### 4. 配置 Claude Desktop

1. 编辑 Claude Desktop 配置文件：
   ```bash
   # macOS
   nano ~/Library/Application\ Support/Claude/claude_desktop_config.json

   # Linux
   nano ~/.config/claude/claude_desktop_config.json

   # Windows
   # 使用 VS Code 或其他编辑器编辑
   # %APPDATA%\Claude\claude_desktop_config.json
   ```

2. 添加以下配置：
   ```json
   {
     "mcpServers": {
       "godot-mcp": {
         "command": "node",
         "args": [
           "PATH_TO_YOUR_PROJECT/server/dist/index.js"
         ],
         "env": {
           "MCP_TRANSPORT": "stdio"
         }
       }
     }
   }
   ```
   > **注意**: 将 `PATH_TO_YOUR_PROJECT` 替换为仓库的绝对路径。

3. 重启 Claude Desktop

### 5. 🎮 在 Godot 中打开示例项目

1. 启动 Godot 编辑器
2. 点击"导入"按钮，导航到克隆的仓库
3. 选择 `examples/bubble-game-demo/` 文件夹
4. 点击"导入项目"按钮
5. 确保插件已启用（项目设置 → 插件 → Godot MCP）

### 6. 🚀 开始 AI 自动开发之旅

现在您可以：
- 查看 [5分钟快速开始指南](QUICK_START.md)
- 探索 [示例项目](examples/README.md)
- 阅读 [AI 开发指南](docs/ai-development-guide.md)

## 💡 使用示例

### 技能自动触发示例

```
用户: "如何实现 Godot 4.x 的彩色爆炸粒子效果"
→ 自动触发 context7-auto-research 技能
→ 调用 Context7 MCP 查询相关文档
→ 返回完整的实现方案
```

```
用户: "遇到 Godot 兼容性错误：Invalid assignment of property 'emission_amount'"
→ 自动触发 godot-compatibility-checker 技能
→ 调用 Godot MCP 检测和修复问题
→ 返回修复后的代码
```

### MCP 工具使用示例

```
用户: "检查我的 Godot 项目版本兼容性"
→ 自动调用 detect_godot_version 工具
→ 返回版本信息和兼容性建议
```

```
用户: "修复这些 Godot 3.x 到 4.x 的兼容性问题"
→ 自动调用 fix_godot_api_compatibility 工具
→ 返回修复后的代码和迁移说明
```

### 自然语言开发任务

- "创建一个带有开始、设置和退出按钮的主菜单"
- "为玩家角色添加碰撞检测"
- "实现昼夜循环系统"
- "重构代码使用信号替代直接引用"
- "调试玩家角色有时会穿过地板的问题"

## 🛠️ 可用 MCP 工具详细说明

### Godot 兼容性工具

#### detect_godot_version
**功能**: 检测项目中使用的 Godot 版本和配置信息
**使用场景**:
- 开始新项目时确认目标版本
- 遇到版本相关错误时的诊断
- 自动化构建流程中的版本检查

#### check_godot_api_compatibility
**功能**: 检查 GDScript 代码中的 API 兼容性问题
**参数**:
- `code`: 要检查的 GDScript 代码
- `targetVersion`: 目标版本 ('3.x', '4.x', 'auto')
- `projectPath`: 项目路径（可选）

#### fix_godot_api_compatibility
**功能**: 自动修复 GDScript 代码中的 API 兼容性问题
**支持的修复**:
- Tween 系统: `interpolate_property()` → `tween_property()`
- Gradient 系统: `get_color_at_offset()` → `get_color(index)`
- 输入系统: 信号连接语法现代化
- 节点操作: 安全的节点访问模式
- 信号系统: lambda 表达式支持
- 粒子系统: `ParticlesMaterial` → `ParticleProcessMaterial`

#### get_godot_migration_advice
**功能**: 获取 Godot 版本迁移建议和最佳实践
**输出**: 详细的迁移指南和代码示例

### 核心 MCP 工具

#### 节点操作工具
- `get-scene-tree` - 返回场景树结构
- `get-node-properties` - 获取特定节点的属性
- `create-node` - 创建新节点
- `delete-node` - 删除节点
- `modify-node` - 更新节点属性

#### 脚本编辑工具
- `list-project-scripts` - 列出项目中所有脚本
- `read-script` - 读取特定脚本
- `modify-script` - 更新脚本内容
- `create-script` - 创建新脚本
- `analyze-script` - 提供脚本分析

#### 场景管理工具
- `list-project-scenes` - 列出项目中所有场景
- `read-scene` - 读取场景结构
- `create-scene` - 创建新场景
- `save-scene` - 保存当前场景

#### 项目管理工具
- `get-project-settings` - 获取项目设置
- `list-project-resources` - 列出项目资源
- `get-project-info` - 获取项目元数据

## 🧠 技能系统详解

### Context7 自动研究技能
- **触发条件**: "如何实现"、"配置"、"文档"等关键词
- **功能**: 自动查询最新技术文档和最佳实践
- **优势**: 无需手动查询，实时获取最新信息

### Godot 兼容性检查技能
- **触发条件**: 版本升级、API 错误、兼容性问题
- **功能**: 基于实际项目经验的修复方案
- **数据库**: 完整的 Godot 3.x 到 4.x API 变化映射

### MCP 编排技能
- **触发条件**: 多步骤开发流程、工具链协作
- **功能**: 支持串行、并行、条件、循环四种执行模式
- **优势**: 复杂任务的智能协调

### 中文开发指南技能
- **触发条件**: 中文交流、本地化需求
- **功能**: 完整的中文化开发环境配置
- **包含**: 终端、Git、编辑器的中文支持

## 🔍 资源端点

### 文档资源
- `godot://script/current` - 当前打开的脚本
- `godot://scene/current` - 当前打开的场景
- `godot://project/info` - 项目元数据和设置

### 查询资源
- `godot://scripts/list` - 脚本列表
- `godot://scenes/list` - 场景列表
- `godot://resources/list` - 资源列表

## 🛠️ 将插件添加到您的 Godot 项目

如果要在自己的 Godot 项目中使用 MCP 插件：

1. 将 `addons/godot_mcp` 文件夹复制到您项目的 `addons` 目录
2. 在 Godot 中打开项目
3. 转到 项目 > 项目设置 > 插件
4. 启用"Godot MCP"插件

## 🔧 故障排除

### 连接问题
- 确保插件在 Godot 的项目设置中已启用
- 检查 Godot 控制台是否有错误消息
- 验证 Claude Desktop 启动时服务器正在运行

### 技能不工作
- 检查 `.claude/skills/` 目录是否存在技能文件
- 确认技能文件格式正确（包含 YAML front matter）
- 验证 MCP 工具是否已正确配置和运行

### 兼容性问题
- 使用 `detect_godot_version` 工具检查项目版本
- 运行 `check_godot_api_compatibility` 检查代码兼容性
- 使用 `fix_godot_api_compatibility` 自动修复问题

## 📚 技能开发

### 创建自定义技能

1. 在 `.claude/skills/` 目录创建技能文件夹
2. 创建 `SKILL.md` 文件，包含：
   ```yaml
   ---
   name: your-skill-name
   description: 技能描述
   version: 1.0.0
   allowed-tools: Tool1, Tool2
   ---

   # 技能内容
   ```

3. 在技能文件中定义触发条件和执行逻辑
4. Claude 会自动发现并加载技能

### 技能命名规范
- 使用小写字母和连字符
- 不包含空格或特殊字符
- 名称应简洁且描述性强

## 🤝 贡献

欢迎贡献！请随时提交 Pull Request。

### 开发环境设置
1. 克隆仓库
2. 安装依赖：`cd server && npm install`
3. 构建：`npm run build`
4. 开发模式：`npm run dev`

## 📖 文档导航

### 📋 项目概览
- [📖 快速开始指南](QUICK_START.md) - 5分钟快速上手
- [🎯 项目概览](PROJECT_OVERVIEW.md) - 项目愿景和架构详解

### 🤝 参与贡献
- [🤝 贡献指南](CONTRIBUTING.md) - 如何参与项目开发
- [📜 行为准则](CODE_OF_CONDUCT.md) - 社区行为规范
- [🔒 安全政策](SECURITY.md) - 安全漏洞报告流程
- [🆘 获取帮助](SUPPORT.md) - 支持资源和联系方式

### 📚 详细文档

#### 📖 用户指南
- [📖 入门指南](docs/user-guide/getting-started.md) - 详细安装和配置
- [📦 安装指南](docs/user-guide/installation-guide.md) - 安装步骤说明
- [🛠️ 命令参考](docs/user-guide/command-reference.md) - MCP 工具完整列表
- [🤖 AI 开发指南](docs/user-guide/ai-development-guide.md) - AI 自动开发最佳实践

#### 🏗️ 技术文档
- [🏗️ 架构说明](docs/technical/architecture.md) - 技术架构详解
- [📝 实现计划](docs/technical/implementation-plan.md) - 项目实现细节
- [🔧 插件说明](docs/technical/godot-addon-readme.md) - Godot 插件使用指南

#### 📚 参考资料
- [🔌 MCP 服务器](docs/reference/mcp-server-readme.md) - 服务器端说明
- [🔧 Godot 兼容性系统](docs/reference/GODOT_COMPATIBILITY_SYSTEM.md) - API 兼容性解决方案
- [🔄 Godot 4.x 属性迁移](docs/reference/GODOT_4X_HAS_PROPERTY_MIGRATION_GUIDE.md) - 属性迁移指南
- [🐛 解析错误解决方案](docs/reference/GODOT_CLASS_PARSER_ERROR_SOLUTION.md) - 常见错误解决

### 🎮 示例项目
- [🫧 示例项目集合](examples/README.md) - AI 开发案例展示
- [🎮 泡泡游戏演示](examples/bubble-game-demo/README.md) - 完整的 AI 开发游戏
- [🔧 Godot 兼容性系统](docs/reference/GODOT_COMPATIBILITY_SYSTEM.md) - API 兼容性解决方案
- [🐛 解析错误解决方案](docs/reference/GODOT_CLASS_PARSER_ERROR_SOLUTION.md) - 常见错误解决

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

## 🙏 致谢

- **Claude AI**: 提供强大的 AI 助手能力
- **Model Context Protocol**: 为 AI-工具集成提供标准化协议
- **FastMCP**: 提供高效的 MCP 服务器实现
- **Godot Engine**: 提供优秀的开源游戏引擎