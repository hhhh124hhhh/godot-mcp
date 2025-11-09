# 🆘 获取帮助

欢迎来到 godot-mcp 项目的支持中心！我们提供多种方式来帮助您解决问题和更好地使用我们的项目。

## 🚀 快速入门

如果您是第一次使用 godot-mcp，建议从以下资源开始：

1. **[快速开始指南](QUICK_START.md)** - 5分钟内体验 AI 自动开发
2. **[项目概览](PROJECT_OVERVIEW.md)** - 了解项目愿景和架构
3. **[示例项目](examples/README.md)** - 查看实际应用案例

## 📚 文档资源

### 📖 核心文档
- **[README.md](README.md)** - 项目主要介绍和功能说明
- **[贡献指南](CONTRIBUTING.md)** - 如何参与项目开发
- **[行为准则](CODE_OF_CONDUCT.md)** - 社区行为规范
- **[安全政策](SECURITY.md)** - 安全漏洞报告流程

### 📖 用户指南
- **[入门指南](docs/user-guide/getting-started.md)** - 详细安装和配置说明
- **[安装指南](docs/user-guide/installation-guide.md)** - 安装步骤说明
- **[命令参考](docs/user-guide/command-reference.md)** - 完整的 MCP 工具列表
- **[AI 开发指南](docs/user-guide/ai-development-guide.md)** - AI 自动开发最佳实践

### 🏗️ 技术文档
- **[架构说明](docs/technical/architecture.md)** - 技术架构详解
- **[实现计划](docs/technical/implementation-plan.md)** - 项目实现细节
- **[插件说明](docs/technical/godot-addon-readme.md)** - Godot 插件使用指南

### 📚 参考资料
- **[兼容性系统说明](docs/reference/GODOT_COMPATIBILITY_SYSTEM.md)** - API 兼容性指南
- **[Godot 4.x 属性迁移](docs/reference/GODOT_4X_HAS_PROPERTY_MIGRATION_GUIDE.md)** - 属性迁移指南
- **[解析错误解决方案](docs/reference/GODOT_CLASS_PARSER_ERROR_SOLUTION.md)** - 常见错误解决
- **[MCP 服务器说明](docs/reference/mcp-server-readme.md)** - 服务器端文档

### 📋 项目管理
- **[文档管理指南](docs/DOCUMENTATION_MANAGEMENT_GUIDE.md)** - 文档组织和管理策略
- **[开源项目实施报告](OPEN_SOURCE_IMPLEMENTATION_REPORT.md)** - 开源项目完善过程

## 💬 社区支持

### 🤔 提问渠道

#### GitHub Discussions 💬
**最适合**: 一般性问题、使用经验分享、功能讨论
- 📝 [创建新讨论](https://github.com/ee0pdt/godot-mcp/discussions/new)
- 🏷️ 可选择讨论类型：Q&A、想法、展示等
- ⏰ 响应时间：通常 24-48 小时

#### GitHub Issues 🐛
**最适合**: Bug 报告、功能请求、具体技术问题
- 📋 [Bug 报告模板](https://github.com/ee0pdt/godot-mcp/issues/new?assignees=&labels=bug&template=bug_report.md)
- 💡 [功能请求模板](https://github.com/ee0pdt/godot-mcp/issues/new?assignees=&labels=enhancement&template=feature_request.md)
- ❓ [问题咨询模板](https://github.com/ee0pdt/godot-mcp/issues/new?assignees=&labels=question&template=question.md)

#### 社区聊天 🗣️
**最适合**: 实时交流、快速问题解答
- 💬 [Discord 服务器](https://discord.gg/godot-mcp) (即将开放)
- 🐦 Twitter: [@godot_mcp](https://twitter.com/godot_mcp)
- 📧 邮件列表: [godot-mcp@googlegroups.com](mailto:godot-mcp@googlegroups.com)

### 🎯 获取帮助的最佳实践

#### ✅ 有效的提问方式
1. **搜索现有资源** - 在提问前先搜索文档和现有 Issues
2. **提供详细信息** - 包含环境信息、错误日志、重现步骤
3. **使用模板** - 使用我们提供的 Issue 模板
4. **保持耐心** - 社区志愿者会尽快回复您的提问

#### ❓ 什么情况下需要帮助？
- 安装和配置问题
- 功能使用疑问
- Bug 报告和故障排除
- 性能优化建议
- API 使用指导
- 最佳实践咨询

## 🔧 常见问题

### 🚀 安装和设置

**Q: 如何安装 Godot MCP？**
A: 请参考 [快速开始指南](QUICK_START.md#-快速安装)，里面有详细的安装步骤。

**Q: 支持哪些 Godot 版本？**
A: 我们支持 Godot 4.2+ 版本，推荐使用 4.3 或更高版本以获得最佳体验。

**Q: Claude Desktop 无法连接到 MCP 服务器怎么办？**
A: 请检查：
1. MCP 服务器是否正在运行
2. 配置文件路径是否正确
3. 是否重启了 Claude Desktop

### 🔌 插件使用

**Q: 如何在 Godot 中启用 MCP 插件？**
A: 在 Godot 编辑器中，进入 项目设置 → 插件，启用 "Godot MCP" 插件。

**Q: 插件连接失败怎么办？**
A: 请检查：
1. 确保使用支持的 Godot 版本
2. 检查 Godot 控制台是否有错误信息
3. 验证 MCP 服务器配置

### 🤖 AI 功能

**Q: 如何使用 AI 自动开发功能？**
A: 请参考 [AI 开发指南](docs/user-guide/ai-development-guide.md)，里面有详细的使用说明。

**Q: AI 技能不工作怎么办？**
A: 请检查：
1. .claude/skills/ 目录是否存在
2. 技能文件格式是否正确
3. MCP 工具是否正常运行

### 🐛 故障排除

**Q: 遇到 "Invalid assignment" 错误怎么办？**
A: 这通常是 Godot 版本兼容性问题，请使用我们的兼容性检查工具。

**Q: 如何查看详细错误信息？**
A: 请检查：
- Godot 控制台输出
- MCP 服务器日志
- Claude Desktop 错误信息

## 📞 联系方式

### 🔒 安全相关问题
如果您发现了安全漏洞，请通过私密渠道报告：
- 📧 **安全邮箱**: `security@godot-mcp.dev`
- 🔒 **GitHub Security**: [私密安全报告](https://github.com/ee0pdt/godot-mcp/security/advisories/new)

### 📧 一般联系
- 📧 **项目邮箱**: `contact@godot-mcp.dev`
- 💬 **GitHub Discussions**: [参与讨论](https://github.com/ee0pdt/godot-mcp/discussions)
- 🐛 **GitHub Issues**: [报告问题](https://github.com/ee0pdt/godot-mcp/issues)

### 👥 社交媒体
- 🐦 **Twitter**: [@godot_mcp](https://twitter.com/godot_mcp)
- 📺 **YouTube**: [Godot MCP 频道](https://youtube.com/@godot-mcp) (即将开放)
- 📝 **博客**: [技术博客](https://blog.godot-mcp.dev) (即将开放)

## 🤝 贡献支持

### 💡 提供反馈
我们欢迎各种形式的反馈：
- 🐛 报告 Bug 和问题
- 💡 提出功能建议
- 📝 改进文档
- 🌐 翻译内容
- 🎨 设计改进

### 🔧 技术贡献
如果您想参与项目开发，请参考：
- [贡献指南](CONTRIBUTING.md) - 详细的贡献流程
- [行为准则](CODE_OF_CONDUCT.md) - 社区行为规范
- [项目概览](PROJECT_OVERVIEW.md) - 了解项目架构

### 💰 资助项目
如果您觉得项目有用，可以考虑：
- ⭐ 给项目加星标
- 📢 分享给其他人
- 💵 [GitHub Sponsors](https://github.com/sponsors/ee0pdt)
- ☕ 请喝咖啡

## 📊 响应时间承诺

| 支持类型 | 响应时间 | 解决时间 |
|----------|----------|----------|
| 🚨 安全漏洞 | 24小时内 | 7天内 |
| 🔴 严重 Bug | 48小时内 | 14天内 |
| 🟡 一般问题 | 72小时内 | 30天内 |
| 💬 社区讨论 | 24小时内 | 持续跟进 |
| 📝 功能请求 | 1周内 | 纳入规划 |

## 🌟 支持等级

### 🏢 企业支持
如果您需要企业级支持，包括：
- 专属技术支持
- 定制开发服务
- 培训和咨询
- SLA 保证

请联系：`enterprise@godot-mcp.dev`

### 🎓 教育支持
教育机构可以申请：
- 免费技术支持
- 教学资源
- 培训服务
- 课程开发指导

请联系：`education@godot-mcp.dev`

## 📚 学习资源

### 🎓 官方教程
- [快速入门视频](https://youtube.com/playlist?list=PLxxx) (制作中)
- [进阶开发指南](docs/advanced-development.md) (计划中)
- [最佳实践案例](examples/) - 查看示例项目

### 📖 推荐阅读
- [Godot 官方文档](https://docs.godotengine.org/)
- [Claude AI 使用指南](https://claude.ai/docs)
- [MCP 协议规范](https://modelcontextprotocol.io/)

## 🔮 未来计划

我们正在开发更多支持资源：

- 📚 完整的在线文档网站
- 🎺 视频教程系列
- 💬 24/7 社区聊天
- 🏆 开发者认证计划
- 🌍 多语言支持

---

## 🙏 致谢

感谢所有为社区提供帮助的志愿者和贡献者！您的每一个问题、建议和贡献都让这个项目变得更好。

**最后更新**: 2025年11月9日
**版本**: 1.0

需要帮助？我们随时在这里为您提供支持！🤗