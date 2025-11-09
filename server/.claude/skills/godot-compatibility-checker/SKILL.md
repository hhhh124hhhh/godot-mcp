---
name: Godot Compatibility Checker
description: 自动检测和修复Godot 3.x与4.x之间的API兼容性问题，基于实际项目经验提供针对性解决方案
version: 1.0.0
---

# Godot版本兼容性检查技能

## 指令

当用户遇到Godot版本相关问题或需要进行版本升级时，自动进行兼容性检查和修复。

## 触发条件
- 提及Godot版本升级或迁移
- 遇到API兼容性错误
- 需要在不同Godot版本间运行代码

## 核心修复案例

### 粒子系统修复
```gdscript
# ❌ 错误: material.emission_amount = 50
# ✅ 正确: particles.amount = 50
```

### Tween系统修复
```gdscript
# ❌ 错误: tween.interpolate_property()
# ✅ 正确: tween.tween_property()
```

## 执行步骤
1. 检测Godot版本
2. 扫描代码问题
3. 提供修复方案
4. 验证修复效果
