# 🤝 贡献指南

感谢您对 godot-mcp 项目的关注！我们欢迎各种形式的贡献，包括但不限于：

- 🐛 报告 Bug
- 💡 提出新功能建议
- 📝 改进文档
- 🔧 提交代码修复
- 🎨 优化用户体验
- 🌐 翻译和本地化

## 🚀 快速开始

### 前置要求

- **Godot Engine 4.2+** - 理解 Godot 基础概念
- **Node.js 18+** - 用于 MCP 服务器开发
- **Git** - 版本控制
- **GitHub 账户** - 提交 Pull Request

### 开发环境设置

1. **Fork 项目**
   ```bash
   # 在 GitHub 上点击 "Fork" 按钮
   # 然后克隆你的 fork
   git clone https://github.com/YOUR_USERNAME/godot-mcp.git
   cd godot-mcp
   ```

2. **设置上游仓库**
   ```bash
   git remote add upstream https://github.com/ee0pdt/godot-mcp.git
   git fetch upstream
   ```

3. **安装依赖**
   ```bash
   cd server
   npm install
   npm run build
   cd ..
   ```

4. **创建功能分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

## 📋 贡献类型

### 🐛 报告 Bug

在报告 Bug 之前，请：

1. **搜索现有 Issues** - 确保问题未被报告
2. **检查最新版本** - 确保问题在最新版本中仍然存在
3. **收集必要信息**：
   - 操作系统和版本
   - Godot 版本
   - Node.js 版本
   - 重现步骤
   - 期望行为 vs 实际行为
   - 相关日志或截图

**提交 Bug Report**：
- 使用 [Bug Report 模板](.github/ISSUE_TEMPLATE/bug_report.md)
- 提供清晰的重现步骤
- 包含相关的错误信息和日志

### 💡 建议新功能

1. **描述功能用途** - 这个功能解决什么问题？
2. **说明使用场景** - 谁会使用这个功能？如何使用？
3. **考虑替代方案** - 是否有其他方式实现相同目标？
4. **提供设计思路** - 如果有具体的实现想法，请分享

**提交功能请求**：
- 使用 [Feature Request 模板](.github/ISSUE_TEMPLATE/feature_request.md)
- 详细描述功能需求
- 说明为什么这个功能有价值

### 📝 改进文档

文档改进同样重要！您可以：

- 修正错误和不准确的信息
- 添加缺失的说明
- 改进代码示例
- 翻译文档到其他语言
- 添加更多使用场景

### 🔧 提交代码

#### 代码规范

**TypeScript/JavaScript (服务器端)**:
```typescript
// ✅ 好的示例
interface GodotNode {
  name: string;
  type: string;
  properties: Record<string, any>;
}

async function createNode(config: NodeConfig): Promise<GodotNode> {
  // 实现
}
```

**GDScript (Godot 插件端)**:
```gdscript
# ✅ 好的示例
extends Node

class_name NodeManager

var _nodes: Dictionary = {}

func _ready() -> void:
    _initialize_nodes()

func add_node(node: Node) -> void:
    if node == null:
        push_error("Cannot add null node")
        return

    _nodes[node.name] = node
```

#### 提交信息规范

使用 [Conventional Commits](https://www.conventionalcommits.org/) 格式：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**类型**：
- `feat`: 新功能
- `fix`: Bug 修复
- `docs`: 文档更新
- `style`: 代码格式化（不影响功能）
- `refactor`: 重构代码
- `test`: 添加或修改测试
- `chore`: 构建过程或辅助工具的变动

**示例**：
```
feat(server): add godot 4.x compatibility check

Add automatic detection of Godot version compatibility issues
and provide migration suggestions for outdated APIs.

Closes #123
```

#### Pull Request 流程

1. **同步最新代码**
   ```bash
   git checkout main
   git pull upstream main
   git checkout feature/your-feature-name
   git rebase main
   ```

2. **确保代码质量**
   ```bash
   # 运行测试
   cd server && npm test

   # 检查代码格式
   npm run lint

   # 构建项目
   npm run build
   ```

3. **提交 Pull Request**
   - 使用 [PR 模板](.github/PULL_REQUEST_TEMPLATE.md)
   - 提供清晰的描述
   - 引用相关的 Issues
   - 添加适当的标签

4. **代码审查**
   - 响应审查意见
   - 及时更新代码
   - 保持礼貌和专业

## 🧪 测试指南

### 服务器端测试

```bash
cd server

# 运行所有测试
npm test

# 运行特定测试文件
npm test -- --grep "GodotConnection"

# 生成覆盖率报告
npm run test:coverage
```

### Godot 插件测试

1. **在 Godot 中测试插件**
   - 打开示例项目
   - 启用插件
   - 测试各项功能

2. **手动测试清单**：
   - [ ] WebSocket 连接正常
   - [ ] MCP 命令正确执行
   - [ ] 错误处理恰当
   - [ ] 性能表现良好

## 📚 代码审查

### 审查者指南

当审查代码时，请关注：

1. **功能正确性** - 代码是否按预期工作？
2. **代码质量** - 是否遵循项目的编码规范？
3. **性能影响** - 是否有性能问题？
4. **安全性** - 是否引入安全风险？
5. **测试覆盖** - 是否有足够的测试？
6. **文档更新** - 是否需要更新相关文档？

### 被审查者指南

1. **保持开放心态** - 建设性地接受反馈
2. **及时响应** - 尽快回复审查意见
3. **解释设计决策** - 如有特殊考虑，请说明
4. **感谢贡献** - 对审查者的时间表示感谢

## 🏷️ 标签说明

我们使用以下标签来分类 Issues 和 Pull Requests：

### Issue 标签
- `bug` - Bug 报告
- `enhancement` - 功能增强
- `documentation` - 文档相关
- `good first issue` - 适合新贡献者
- `help wanted` - 需要帮助
- `question` - 问题咨询

### PR 标签
- `dependencies` - 依赖更新
- `server` - 服务器端更改
- `plugin` - Godot 插件更改
- `documentation` - 文档更新
- `breaking-change` - 破坏性更改
- `security` - 安全相关

## 🌟 贡献者认可

我们感谢所有贡献者的努力！贡献将通过以下方式得到认可：

1. **Contributors 列表** - 在 README 中展示
2. **Release Notes** - 在版本发布中提及
3. **社区认可** - 在社交媒体上感谢
4. **贡献者徽章** - 长期贡献者获得特殊认可

## 🤝 社区准则

请遵守我们的 [行为准则](CODE_OF_CONDUCT.md)，确保我们的社区保持友好、包容和专业的氛围。

## 📞 获取帮助

如果您有任何问题或需要帮助：

1. **查看现有 Issues** - 可能已有类似问题的解答
2. **创建 Discussion** - 在 GitHub Discussions 中提问
3. **联系维护者** - 通过 Issue @ 相关维护者
4. **查看文档** - 阅读项目的文档和指南

## 🚀 发布流程

只有项目维护者可以进行发布：

1. **更新版本号**
2. **更新 CHANGELOG**
3. **创建 Git Tag**
4. **发布 GitHub Release**
5. **更新文档**

---

再次感谢您的贡献！每一个贡献，无论大小，都让这个项目变得更好。🎉

## 📚 相关资源

### 开源项目指南
- [GitHub Open Source Guide](https://opensource.guide/)
- [Conventional Commits](https://www.conventionalcommits.org/)

### 技术文档
- [📖 入门指南](docs/user-guide/getting-started.md)
- [🏗️ 架构说明](docs/technical/architecture.md)
- [🛠️ 命令参考](docs/user-guide/command-reference.md)

### 外部资源
- [Godot Documentation](https://docs.godotengine.org/)
- [MCP Specification](https://modelcontextprotocol.io/)