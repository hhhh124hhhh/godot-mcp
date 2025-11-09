# Godot MCP 技能库

## 概述

这是一个符合标准Claude技能格式的技能库，专为Godot MCP项目设计，包含自动化开发工具、兼容性检查、MCP工具编排和中文支持等实用技能。

## 技能列表

### 🤖 Context7 Auto Research
- **路径**: `context7-auto-research/SKILL.md`
- **功能**: 自动使用Context7进行文档研究
- **触发**: "如何实现"、"配置"、"文档"等关键词
- **特色**: 实现用户要求的自动化规则："Always use context7 when I need code generation, setup or configuration steps, or library/API documentation"

### 🎮 Godot Compatibility Checker  
- **路径**: `godot-compatibility-checker/SKILL.md`
- **功能**: 检测和修复Godot 3.x与4.x兼容性问题
- **触发**: 版本升级、API错误、兼容性问题
- **特色**: 基于实际项目经验的修复方案

### 🔧 MCP Orchestration
- **路径**: `mcp-orchestration/SKILL.md`  
- **功能**: 编排多个MCP工具完成复杂任务
- **触发**: 多步骤开发流程、工具链协作
- **特色**: 支持串行、并行、条件、循环四种模式

### 🌏 Chinese Development Guide
- **路径**: `chinese-dev-guide/SKILL.md`
- **功能**: 中文环境配置和开发指导
- **触发**: 中文交流、本地化需求
- **特色**: 完整的中文化开发环境

## 使用方法

### 自动触发
大部分技能会根据用户输入自动触发，无需手动调用。

### 手动调用
```bash
/skill context7-auto-research
/skill godot-compatibility-checker  
/skill mcp-orchestration
/skill chinese-dev-guide
```

## 技能格式

所有技能都遵循标准Claude技能格式：
- YAML frontmatter (name, description, version)
- 清晰的指令和触发条件
- 详细的执行步骤
- 实用的示例和注意事项

## 技能统计

- **技能总数**: 4个
- **支持语言**: 中文、英文
- **覆盖场景**: 自动化研究、兼容性检查、工具编排、中文开发
- **符合标准**: Claude官方技能格式

---

**版本**: 1.0.0  
**最后更新**: 2025-11-09
**维护团队**: Godot MCP开发团队
