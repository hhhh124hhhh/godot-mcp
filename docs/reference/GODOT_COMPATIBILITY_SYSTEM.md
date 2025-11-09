# Godot API兼容性系统

## 系统概述

这是一个完整的Godot API版本兼容性问题解决方案，专门用于检测、修复和预防Godot 3.x与4.x之间的API差异问题。

## 系统架构

### 核心组件

1. **版本检测器** (`godot_version_detector.ts`)
   - 自动检测项目使用的Godot版本
   - 解析`project.godot`配置文件
   - 提供版本兼容性提示

2. **API兼容性数据库** (`godot_api_compatibility.ts`)
   - 完整的API变化映射表
   - 破坏性变化、废弃功能和更新说明
   - 自动修复规则和示例代码

3. **实时代码验证器** (`godot_code_validator.ts`)
   - 静态代码分析
   - 兼容性问题检测
   - 性能和安全性建议
   - 现代化建议

4. **MCP工具集成** (`godot_compatibility_tools.ts`)
   - 4个专用的兼容性工具
   - 与现有MCP架构无缝集成
   - 自动修复和迁移建议

## 可用工具

### 1. detect_godot_version
**功能**：检测项目中使用的Godot版本和配置信息

**参数**：
- `projectPath` (可选)：项目路径

**返回**：
- 版本信息 (major, minor, patch)
- 项目配置 (name, description, version)
- 兼容性提示和建议

### 2. check_godot_api_compatibility
**功能**：检查GDScript代码中的API兼容性问题

**参数**：
- `code` (必需)：要检查的GDScript代码
- `targetVersion` (可选)：目标版本 ('3.x', '4.x', 'auto')
- `projectPath` (可选)：项目路径

**返回**：
- 详细的兼容性问题列表
- 按严重程度分类的问题
- 修复建议和自动修复选项

### 3. fix_godot_api_compatibility
**功能**：自动修复GDScript代码中的API兼容性问题

**参数**：
- `code` (必需)：要修复的GDScript代码
- `issueIds` (可选)：要修复的问题ID列表
- `targetVersion` (可选)：目标版本
- `projectPath` (可选)：项目路径

**返回**：
- 修复后的代码
- 应用的修复列表
- 修复成功率统计

### 4. get_godot_migration_advice
**功能**：获取Godot版本迁移建议和最佳实践

**参数**：
- `fromVersion` (可选)：源版本
- `toVersion` (可选)：目标版本
- `projectPath` (可选)：项目路径

**返回**：
- 详细的迁移建议
- 破坏性变化列表
- 最佳实践和推荐做法

## 支持的API变化

### Tween系统
- ✅ `interpolate_property()` → `tween_property()`
- ✅ `set_looped()` → callback循环模式
- ✅ 缓动常量和过渡方式更新

### Gradient系统
- ✅ `get_color_at_offset()` → `get_color(index)`
- ✅ `set_color(index, color)` 替代方案

### 输入系统
- ✅ 信号连接语法现代化
- ✅ 鼠标事件处理更新
- ✅ 输入映射系统变化

### 节点操作
- ✅ 安全的节点访问模式
- ✅ `call_deferred("queue_free")` 安全删除
- ✅ 节点路径处理优化

### 信号系统
- ✅ lambda表达式支持
- ✅ 新的连接语法
- ✅ 自动断开机制

## 使用示例

### 场景1：检测项目版本
```
调用：detect_godot_version({projectPath: "/path/to/project"})
返回：
{
  "success": true,
  "data": {
    "version": {"major": 4, "minor": 2, "versionString": "4.2"},
    "compatibilityHints": ["项目使用Godot 4.x API"],
    "recommendations": {"isGodot4": true, "needsMigration": false}
  }
}
```

### 场景2：检查代码兼容性
```
调用：check_godot_api_compatibility({
  code: "tween.set_looped(true)",
  targetVersion: "4.x"
})
返回：
{
  "success": true,
  "data": {
    "issues": {
      "breaking": 1,
      "details": [{
        "category": "tween",
        "description": "set_looped()在Godot 4.x中已被移除",
        "autoFixAvailable": true
      }]
    }
  }
}
```

### 场景3：自动修复代码
```
调用：fix_godot_api_compatibility({
  code: "gradient.get_color_at_offset(0.5)",
  targetVersion: "4.x"
})
返回：
{
  "success": true,
  "data": {
    "fixedCode": "gradient.get_color(index)  # 请替换为正确的索引",
    "fixes": [{"success": true, "category": "gradient"}]
  }
}
```

## 技术特点

### 智能检测
- 基于正则表达式的模式匹配
- 上下文感知的问题识别
- 语法和语义双重验证

### 自动修复
- 规则驱动的代码转换
- 保持原有逻辑不变
- 添加详细的修复注释

### 预防机制
- 实时代码验证
- 最佳实践推荐
- 性能优化建议

### 扩展性
- 模块化设计
- 易于添加新规则
- 支持自定义验证逻辑

## 集成方式

### 1. MCP服务器集成
- 已集成到主MCP服务器 (`index.ts`)
- 自动注册所有兼容性工具
- 与现有工具无缝协作

### 2. AI技能集成
- 专用技能文件 (`godot-version-compatibility.md`)
- 详细的故障排除指南
- 最佳实践文档

### 3. 代码编辑器集成
- 实时代码检查
- 自动补全和修复建议
- 错误高亮和快速修复

## 性能优化

### 缓存机制
- 版本检测结果缓存
- API变化数据预加载
- 修复规则索引优化

### 并发处理
- 异步文件处理
- 多文件并行检查
- 非阻塞用户界面

### 内存管理
- 智能垃圾回收
- 大文件流式处理
- 缓存大小限制

## 维护和更新

### 数据更新
- 定期更新API变化数据库
- 添加新的兼容性规则
- 优化修复算法

### 质量保证
- 全面的单元测试
- 集成测试覆盖
- 用户反馈收集

### 文档维护
- API文档同步更新
- 最佳实践指南
- 故障排除手册

## 未来规划

### 功能扩展
- 支持更多Godot版本
- 添加项目级修复
- 集成IDE插件

### 智能化增强
- 机器学习驱动的检测
- 自适应修复策略
- 智能代码生成

### 生态系统
- 社区贡献机制
- 插件市场支持
- 第三方工具集成

---

**版本**: 1.0.0
**最后更新**: 2025-11-08
**维护者**: Godot MCP开发团队