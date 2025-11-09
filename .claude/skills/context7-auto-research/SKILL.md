---
name: context7-auto-research
description: 自动使用Context7进行文档研究，当用户需要代码生成、配置步骤或库/API文档时无需明确请求即可自动获取最新信息
version: 1.0.0
allowed-tools: Read, Write, Skill, WebFetch
---

# Context7 自动化研究技能

## 指令

当用户输入包含以下关键词时，自动触发Context7文档研究：

### 中文触发条件
- "如何实现"、"怎么写"、"怎样制作" → 自动查询实现方案和教程
- "配置"、"设置"、"安装" → 自动获取配置指南和最佳实践
- "文档"、"参考"、"资料" → 自动检索官方文档和权威资料
- "最佳实践"、"推荐"、"建议" → 自动收集社区经验和优化建议
- "问题"、"错误"、"故障" → 自动搜索解决方案和故障排除指南

### 英文触发条件
- "how to implement"、"how to write" → 自动查询实现教程
- "configure"、"setup"、"install" → 自动获取配置指南
- "documentation"、"docs"、"reference" → 自动检索官方文档
- "best practice"、"recommendation" → 自动收集最佳实践

## 执行步骤

1. **检测触发条件** - 分析用户输入是否包含上述关键词
2. **生成查询策略** - 根据用户需求自动生成最优的Context7查询
3. **执行Context7搜索** - 使用 `/skill context7` 进行文档检索
4. **整合信息** - 将Context7返回的信息与项目上下文结合
5. **提供解决方案** - 给出具体的代码示例、配置步骤或实施建议

## MCP工具使用说明

此技能主要使用以下MCP工具：
- **Context7 MCP** - 核心文档检索和信息查询工具
- **WebFetch MCP** - 辅助获取在线文档和资源
- **Skill MCP** - 用于调用其他相关技能

### MCP调用方式
```bash
# 直接调用Context7 MCP
/skill context7 "查询内容"

# 在技能内部调用Context7
await useSkill('context7', { query: "用户查询内容" })
```

## 关键要素

### 自动化规则实现
- 严格按照用户设定："Always use context7 when I need code generation, setup or configuration steps, or library/API documentation"
- 无需用户明确请求，自动触发Context7查询
- 确保查询结果的准确性和时效性

### 查询优化策略
- 中英文关键词智能映射
- 技术栈特定查询优化
- 官方文档优先原则
- 社区最佳实践补充

### 结果质量保证
- 验证信息来源的权威性
- 确保代码示例的完整性
- 检查配置步骤的准确性
- 提供多层次的解决方案

## 示例场景

### 场景1：Godot开发咨询
**用户输入**: "如何实现Godot 4.x的彩色爆炸粒子效果"

**自动执行流程**:
1. 检测到"如何实现"触发条件
2. 自动查询: `/skill context7 "Godot 4.x colored explosion particle effect implementation tutorial"`
3. 整合官方文档和社区最佳实践
4. 提供完整的GDScript代码示例和配置说明

### 场景2：MCP工具配置
**用户输入**: "配置Chrome DevTools MCP服务器"

**自动执行流程**:
1. 检测到"配置"触发条件
2. 自动查询: `/skill context7 "Chrome DevTools MCP server configuration setup guide"`
3. 获取安装步骤和配置示例
4. 包含故障排除和常见问题解决方案

## 输出格式

1. **问题理解** - 确认用户需求和上下文
2. **研究过程** - 说明使用的Context7查询策略
3. **核心发现** - 突出最重要的信息点
4. **实施方案** - 提供具体的代码或配置
5. **补充资源** - 提供进一步学习的链接

## 注意事项

- 确保Context7查询的针对性和准确性
- 验证返回信息的时效性和可靠性
- 根据项目技术栈调整建议的适用性
- 提供足够的上下文信息帮助用户理解
- 在技术实现和最佳实践之间找到平衡