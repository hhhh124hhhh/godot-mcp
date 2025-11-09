---
name: godot-compatibility-checker
description: 自动检测和修复Godot 3.x与4.x之间的API兼容性问题，基于实际项目经验提供针对性解决方案
version: 1.0.0
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Godot版本兼容性检查技能

## 指令

当用户遇到Godot版本相关问题或需要进行版本升级时，自动进行兼容性检查和修复：

### 触发条件
- 提及Godot版本升级或迁移
- 遇到API兼容性错误
- 需要在不同Godot版本间运行代码
- 询问特定API的版本支持情况

## 执行步骤

1. **版本检测** - 分析项目配置确定目标Godot版本
2. **代码扫描** - 检查GDScript中的过时API使用
3. **问题识别** - 定位具体的兼容性问题点
4. **生成修复方案** - 提供详细的代码修改建议
5. **验证修复** - 确保修复后的代码在目标版本正常运行

## 核心兼容性问题修复

### 粒子系统架构变化
**问题**: `Invalid assignment of property or key 'emission_amount' on a base object of type 'ParticleProcessMaterial'`

**修复方案**:
```gdscript
# ❌ Godot 3.x 错误写法
var material = ParticleProcessMaterial.new()
material.emission_amount = 50
material.lifetime = 1.5

# ✅ Godot 4.x 正确写法
var particles = GPUParticles2D.new()
var material = ParticleProcessMaterial.new()
particles.amount = 50      # 属性设置在节点层级
particles.lifetime = 1.5   # 属性设置在节点层级
particles.material = material
```

### Tween系统现代化
**问题**: `interpolate_property()` 和 `set_looped()` 方法不存在

**修复方案**:
```gdscript
# ❌ Godot 3.x 过时写法
var tween = Tween.new()
tween.interpolate_property(object, "property", start, end, 1.0)
tween.set_looped(true)

# ✅ Godot 4.x 现代写法
var tween = create_tween()
tween.tween_property(object, "property", end, 1.0)
# 使用回调实现循环
func animate_loop():
    var tween = create_tween()
    # 动画代码...
    tween.tween_callback(animate_loop)
```

### 信号系统更新
**问题**: 信号连接语法变化

**修复方案**:
```gdscript
# ❌ Godot 3.x 过时写法
connect("input_event", self, "_on_input_event")

# ✅ Godot 4.x 现代写法
input_event.connect(_on_input_event)
# 或使用lambda表达式
signal.signal_name.connect(func(): print("信号触发"))
```

### 输入系统常量更新
**问题**: 鼠标按钮常量名称变化

**修复方案**:
```gdscript
# ❌ Godot 3.x 过时写法
if event.button_index == BUTTON_LEFT

# ✅ Godot 4.x 现代写法
if event.button_index == MOUSE_BUTTON_LEFT
```

### 属性检查方法移除
**问题**: `has_property()` 方法被移除

**修复方案**:
```gdscript
# ❌ Godot 3.x 过时写法
if node.has_property("custom_property"):
    value = node.get("custom_property")

# ✅ Godot 4.x 现代写法
if "custom_property" in node:
    value = node.get("custom_property")
# 或更安全的检查
var property_value = node.get("custom_property")
if property_value != null:
    value = property_value
```

## 实际修复案例

### 案例1: EnhancedParticleEffect.gd修复
**原始错误**: 粒子属性设置位置错误
**修复位置**: lines 142, 163, 196, 327
**修复内容**: 将 `material.emission_amount` 改为 `particles.amount`

### 案例2: Bubble.gd现代化
**修复内容**:
- 修复信号名称错误 (`opopped.emit` → `popped.emit`)
- 更新Tween系统API
- 现代化信号连接语法
- 更新async/await语法

## 检查清单

### 代码审查要点
- [ ] Tween系统是否使用 `create_tween()` 而非 `Tween.new()`
- [ ] 粒子系统是否使用 `ParticleProcessMaterial` 而非 `ParticlesMaterial`
- [ ] 粒子属性是否设置在正确层级（节点vs材质）
- [ ] 信号连接是否使用新语法
- [ ] 输入事件是否使用正确的常量名称
- [ ] 属性检查是否使用 `in` 操作符而非 `has_property()`
- [ ] Shader参数是否有适当的类型转换
- [ ] 节点删除是否使用 `call_deferred("queue_free")`

## MCP工具使用说明

此技能主要使用以下MCP工具：
- **Godot MCP** - 核心Godot引擎集成工具，提供版本检测、兼容性检查和自动修复功能
- **Read/Write/Edit MCP** - 用于读取、修改和编辑项目文件
- **Glob/Grep MCP** - 用于代码扫描和问题检测

### MCP调用方式
```bash
# 检测Godot版本 (通过Godot MCP)
await godotMCP.detect_godot_version({ projectPath: './project.godot' })

# 检查API兼容性 (通过Godot MCP)
await godotMCP.check_godot_api_compatibility({
  code: fileContent,
  targetVersion: '4.x'
})

# 自动修复兼容性问题 (通过Godot MCP)
await godotMCP.fix_godot_api_compatibility({
  code: problematicCode,
  issueIds: detectedIssues
})
```

### 可用工具
- `detect_godot_version` - 检测项目Godot版本
- `check_godot_api_compatibility` - 检查代码兼容性
- `fix_godot_api_compatibility` - 自动修复兼容性问题
- `get_godot_migration_advice` - 获取迁移建议

### 工作流程
1. 使用 `detect_godot_version` 确定当前和目标版本
2. 运行 `check_godot_api_compatibility` 全面扫描代码
3. 应用 `fix_godot_api_compatibility` 自动修复问题
4. 使用 `get_godot_migration_advice` 获取最佳实践建议

## 输出格式

1. **问题概述** - 列出发现的兼容性问题及严重程度
2. **修复建议** - 提供具体的代码修改方案
3. **修复示例** - 展示修改前后的代码对比
4. **验证步骤** - 说明如何验证修复效果
5. **最佳实践** - 提供避免未来问题的建议

## 注意事项

- 确保修复后的代码在目标Godot版本中能够正常运行
- 保留原始代码备份以防回滚需要
- 优先修复破坏性变化，再处理废弃功能警告
- 考虑性能影响，充分利用新版本优化特性
- 测试关键功能确保修复没有引入新问题