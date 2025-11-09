# Godot MCP 技能库使用指南

## 技能加载方式

### 1. 自动加载 (推荐)
Claude会自动发现以下位置的技能：
- **项目技能**: `.claude/skills/<技能名>/` (当前项目)
- **个人技能**: `~/.claude/skills/<技能名>/` (全局使用)

### 2. 手动调用技能
```bash
# 调用特定技能 (使用正确的技能名称)
/skill godot-compatibility-checker
/skill context7-auto-research
/skill mcp-orchestration
/skill chinese-dev-guide
```

## 可用技能

### 🤖 context7-auto-research
- **路径**: `context7-auto-research/SKILL.md`
- **功能**: 自动使用Context7进行文档研究
- **触发**: "如何实现"、"配置"、"文档"等关键词
- **特色**: 实现用户要求的自动化规则："Always use context7 when I need code generation, setup or configuration steps, or library/API documentation"

### 🎮 godot-compatibility-checker
- **路径**: `godot-compatibility-checker/SKILL.md`
- **功能**: 检测和修复Godot 3.x与4.x兼容性问题
- **触发**: 版本升级、API错误、兼容性问题
- **特色**: 基于实际项目经验的修复方案

### 🔧 mcp-orchestration
- **路径**: `mcp-orchestration/SKILL.md`
- **功能**: 编排多个MCP工具完成复杂任务
- **触发**: 多步骤开发流程、工具链协作
- **特色**: 支持串行、并行、条件、循环四种模式

### 🌏 chinese-dev-guide
- **路径**: `chinese-dev-guide/SKILL.md`
- **功能**: 中文环境配置和开发指导
- **触发**: 中文交流、本地化需求
- **特色**: 完整的中文化开发环境

## 技能状态

✅ **已加载技能**: 4个
- godot-compatibility-checker
- context7-auto-research
- mcp-orchestration
- chinese-dev-guide

## 使用示例

### 自动触发示例
```
用户: "如何实现Godot 4.x的彩色爆炸粒子效果"
→ 自动触发 context7-auto-research 技能
→ 调用 Context7 MCP 查询相关文档
→ 返回完整的实现方案

用户: "遇到Godot兼容性错误：Invalid assignment of property 'emission_amount'"
→ 自动触发 godot-compatibility-checker 技能
→ 调用 Godot MCP 检测和修复问题
→ 返回修复后的代码
```

### 手动调用示例
```
/skill godot-compatibility-checker
→ 检测Godot版本和API兼容性问题
→ 提供具体的修复建议

/skill context7-auto-research
→ 自动查询最佳实践和文档
→ 解决特定的开发问题
```

## MCP工具集成

所有技能都明确说明了使用的MCP工具：
- **Context7 MCP**: 文档检索和查询
- **Godot MCP**: Godot引擎集成
- **Chrome DevTools MCP**: Web开发调试
- **Sequential Thinking MCP**: 逻辑分析和推理
- **Bash MCP**: 系统命令执行
- **Read/Write/Edit MCP**: 文件操作
- **Grep/Glob MCP**: 代码搜索和扫描

## 注意事项

1. **技能目录**: 技能必须放在 `.claude/skills/` 目录下才能被自动加载
2. **技能名称**: 使用简单的小写名称和连字符，不要包含空格
3. **文件格式**: 每个技能必须包含 `SKILL.md` 文件
4. **YAML格式**: 技能文件开头必须包含正确的YAML front matter
5. **MCP依赖**: 某些技能需要特定的MCP工具已配置并运行

## 技能名称规范

已修复的技能名称：
- ✅ `godot-compatibility-checker` (之前: "Godot Compatibility Checker")
- ✅ `context7-auto-research` (之前: "Context7 Auto Research")
- ✅ `mcp-orchestration` (之前: "MCP Orchestration")
- ✅ `chinese-dev-guide` (之前: "Chinese Development Guide")

---

**版本**: 1.0.1
**最后更新**: 2025-11-09
**技能总数**: 4个
**状态**: 已加载并可使用
**修复**: 技能名称格式问题已解决