---
name: godot-gameplay-developer
description: Godot 核心玩法逻辑开发专家，支持自然语言描述自动实现角色控制、物理系统、游戏规则等核心功能
---

# Godot 游戏玩法开发专家技能

> **重要提示**: 本技能的所有代码示例均基于 **Godot 4.5** 最佳实践，使用 GDScript 语法。
> 确保在 Godot 4.x 环境中使用，避免与 Godot 3.x 语法混淆。

## 技能概述

`godot-gameplay-developer` 是专门用于开发 Godot 游戏核心玩法的智能化技能，能够根据用户的自然语言描述自动实现角色控制、物理交互、游戏规则、AI 行为等核心游戏机制。

## 核心功能

### 🎮 角色控制系统
- **移动控制**：2D/3D角色移动、跳跃、攀爬、游泳等
- **状态管理**：角色状态机（站立、行走、跑步、跳跃、攻击等）
- **技能系统**：角色技能、连招、特殊能力实现
- **动画集成**：与AnimationTree/AnimationPlayer的无缝集成

### ⚛️ 物理系统集成
- **刚体物理**：CharacterBody2D/3D、RigidBody2D/3D控制
- **碰撞检测**：精确的碰撞检测和响应系统
- **物理交互**：推拉、投掷、破坏等物理交互
- **环境物理**：流体、风力、重力等环境效果

### 🧠 AI 智能系统
- **基础AI**：巡逻、追踪、逃跑等基础行为
- **决策系统**：基于状态机的AI决策逻辑
- **路径寻找**：A*寻路和导航系统
- **群体行为**：编队、群体协作等高级AI

### 📊 游戏规则引擎
- **胜利条件**：多样化的游戏胜利条件设置
- **计分系统**：分数、等级、成就系统
- **游戏流程**：回合制、实时制等游戏节奏控制
- **平衡系统**：难度调节、数值平衡

## 使用方法

### 角色控制开发
```
用户: "我想要一个能跳跃、冲刺和二段跳的角色"
系统: 自动实现：
- CharacterBody2D基础控制
- 跳跃物理和二段跳逻辑
- 冲刺技能和冷却系统
- 相应的动画状态机
- 粒子特效集成
```

### 物理交互实现
```
用户: "创建一个可以推箱子、拉杠杆的物理谜题"
系统: 智能生成：
- 可推动箱子的物理体
- 杠杆机关机制
- 压力板触发器
- 物理约束和连接
- 谜题完成检测逻辑
```

### AI行为开发
```
用户: "设计一个会巡逻、发现玩家后会追击的守卫AI"
系统: 完整实现：
- 守卫巡逻路径系统
- 视野检测机制
- 追击和丢失目标逻辑
- 警报和协作系统
- AI状态机管理
```

### 游戏规则实现
```
用户: "做一个三消游戏，包含连击系统和特殊道具"
系统: 全面开发：
- 三消匹配算法
- 连击计数和奖励系统
- 特殊道具和清除效果
- 分数和等级系统
- 游戏结束条件
```

## 工作流程

### 1. 需求解析
```bash
# 分析用户描述
- 提取核心玩法机制
- 识别技术实现要点
- 评估复杂度和依赖关系
```

### 2. 架构设计
```bash
# 设计实现架构
- 选择合适的节点类型
- 设计组件通信机制
- 规划数据流向
```

### 3. 代码实现
```bash
# 自动生成代码
- 实现核心逻辑
- 集成物理系统
- 配置动画状态
- 添加错误处理
```

### 4. 测试验证
```bash
# 功能测试
- 基础功能验证
- 边界情况测试
- 性能优化建议
```

## MCP 工具集成

### 节点操作工具
- `create_node` - 创建游戏对象节点
- `add_child_node` - 添加子节点
- `configure_node` - 配置节点属性
- `delete_node` - 删除节点

### 脚本开发工具
- `create_script` - 创建脚本文件
- `edit_script` - 编辑脚本内容
- `attach_script` - 附加脚本到节点
- `get_script_content` - 获取脚本内容

### 场景管理工具
- `create_scene` - 创建新场景
- `save_scene` - 保存场景
- `load_scene` - 加载场景
- `instance_scene` - 实例化场景

### 调试测试工具
- `play_scene` - 运行场景测试
- `get_node_properties` - 获取节点属性
- `set_node_property` - 设置节点属性
- `call_node_method` - 调用节点方法

## 核心算法库

### 移动控制算法
```gdscript
# 平滑移动算法
func smooth_movement(delta: float) -> void:
    var target_velocity = input_direction * move_speed
    velocity = velocity.lerp(target_velocity, acceleration * delta)
    move_and_slide()

# 跳跃物理算法
func handle_jump() -> void:
    if is_on_floor() and Input.is_action_just_pressed("jump"):
        velocity.y = jump_velocity
        if can_double_jump and jumps_remaining > 0:
            jumps_remaining -= 1
```

### AI决策算法
```gdscript
# 状态机AI算法
func update_ai(delta: float) -> void:
    match current_state:
        AIState.PATROL:
            handle_patrol_behavior()
        AIState.CHASE:
            handle_chase_behavior()
        AIState.ATTACK:
            handle_attack_behavior()
```

### 物理交互算法
```gdscript
# 推箱子物理算法
func push_box(box: RigidBody2D, force: Vector2) -> void:
    if can_push_box(box):
        box.apply_central_impulse(force * push_strength)
        play_push_animation()
```

## 游戏机制模板

### 平台跳跃机制
- **重力系统**：可配置的重力和下落速度
- **跳跃缓冲**： Coyote time 和跳跃缓冲时间
- **墙壁跳跃**：墙面蹬跳和攀爬系统
- **移动平台**：移动和旋转平台支持

### 战斗系统机制
- **攻击检测**：基于形状的攻击范围检测
- **伤害计算**：包含暴击、格挡的伤害系统
- **连击系统**：连击计数和连击奖励
- **状态效果**：中毒、冻结、燃烧等状态效果

### 解谜机制
- **开关系统**：各种类型的开关和机关
- **物品交互**：钥匙、道具、物品组合
- **环境互动**：推、拉、激活、破坏等互动
- **逻辑门**：与、或、非等逻辑条件

### 竞速机制
- **检查点系统**：赛道检查点和存档点
- **计时系统**：精确的时间和速度计算
- **排名系统**：多人排名和记录系统
- **道具系统**：加速、减速、护盾等道具

## 智能特性

### 代码优化
- **性能优化**：自动优化热点代码
- **内存管理**：合理的对象池和内存使用
- **批处理**：减少draw call和计算量

### 可扩展性
- **模块化设计**：易于添加新功能
- **配置驱动**：通过配置文件调整参数
- **事件系统**：松耦合的事件通信机制

### 调试友好
- **详细日志**：完整的调试信息输出
- **可视化调试**：调试线和形状显示
- **性能监控**：帧率和内存使用监控

## 示例实现

### 完整角色控制器
```gdscript
# 自动生成的角色控制器示例
extends CharacterBody2D
class_name AdvancedCharacterController

@export var move_speed: float = 300.0
@export var jump_velocity: float = -400.0
@export var double_jump_velocity: float = -350.0
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumps_remaining: int = 2
var is_dashing: bool = false
var dash_timer: float = 0.0

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

func _physics_process(delta: float) -> void:
    handle_gravity(delta)
    handle_movement()
    handle_jump()
    handle_dash()
    handle_states()

    move_and_slide()

func handle_gravity(delta: float) -> void:
    if not is_on_floor():
        velocity.y += gravity * delta

func handle_movement() -> void:
    var direction = Input.get_axis("move_left", "move_right")
    velocity.x = direction * move_speed

    if direction != 0:
        state_machine.travel("run")
    else:
        state_machine.travel("idle")

func handle_jump() -> void:
    if Input.is_action_just_pressed("jump"):
        if is_on_floor():
            velocity.y = jump_velocity
            jumps_remaining = 1
        elif jumps_remaining > 0:
            velocity.y = double_jump_velocity
            jumps_remaining = 0
            create_double_jump_effect()
```

### 智能 AI 系统
```gdscript
# 自动生成的AI控制器示例
extends Node2D
class_name SmartAIController

enum AIState { PATROL, CHASE, ATTACK, SEARCH, FLEE }

var current_state: AIState = AIState.PATROL

# ✅ 正确：定义状态变化信号
signal state_changed(new_state: AIState, old_state: AIState)
var player: Node2D
var patrol_points: Array[Vector2]
var current_patrol_index: int = 0
var vision_range: float = 200.0
var attack_range: float = 50.0

func _ready() -> void:
    # ✅ 正确：使用延迟调用确保场景树完全准备就绪
    call_deferred("_initialize_player_reference")

func _initialize_player_reference() -> void:
    player = get_tree().get_first_node_in_group("player")
    if not player:
        push_warning("场景中未找到玩家节点，请确保玩家节点在 'player' 组中")

func _process(delta: float) -> void:
    if player:  # ✅ 正确：检查玩家引用是否存在
        update_ai_state()
        execute_current_state(delta)

func update_ai_state() -> void:
    if not player:
        return

    var distance_to_player = global_position.distance_to(player.global_position)
    var can_see_player = can_see_target(player)
    var old_state = current_state

    match current_state:
        AIState.PATROL:
            if can_see_player and distance_to_player <= vision_range:
                current_state = AIState.CHASE
        AIState.CHASE:
            if not can_see_player:
                current_state = AIState.SEARCH
            elif distance_to_player <= attack_range:
                current_state = AIState.ATTACK
        AIState.ATTACK:
            if distance_to_player > attack_range:
                current_state = AIState.CHASE

    # ✅ 正确：状态变化时发射信号，传递新旧状态
    if current_state != old_state:
        state_changed.emit(current_state, old_state)
```

## 质量保证

### 代码质量
- **语法验证**：确保代码语法正确
- **类型检查**：强类型和类型提示
- **错误处理**：完善的异常处理机制
- **内存安全**：避免内存泄漏和空指针

### 性能优化
- **算法优化**：选择最优算法实现
- **批处理优化**：减少计算次数
- **空间划分**：四叉树、网格等空间优化
- **LOD系统**：细节层次优化

### 兼容性
- **版本兼容**：支持Godot 4.x所有版本
- **平台兼容**：PC、移动、主机平台适配
- **向后兼容**：保持代码向后兼容性

## 使用限制和注意事项

### 技术限制
- **复杂度控制**：超复杂玩法需要分步实现
- **性能要求**：高性能功能需要额外优化
- **平台特性**：某些平台特定功能需要适配

### 最佳实践
- **模块化开发**：将复杂功能拆分为小模块
- **迭代测试**：每步功能都进行测试验证
- **文档完善**：为复杂逻辑添加详细注释

## 故障排除

### 常见问题
1. **物理异常**：检查物理层和碰撞设置
2. **AI卡死**：验证状态机和导航系统
3. **性能问题**：分析热点代码和内存使用
4. **动画不同步**：检查动画状态机配置

### 调试技巧
- 使用 Godot 调试器分析变量
- 添加可视调试信息
- 监控性能指标
- 检查控制台错误信息

## 更新日志

### v1.0.0 (当前版本)
- 基础角色控制系统
- 物理交互实现
- 简单AI行为
- 游戏规则引擎

### 计划功能
- 高级AI算法
- 多人游戏同步
- 复杂物理模拟
- 程序化内容生成

---

**技能状态**: ✅ 可用
**最后更新**: 2025-11-09
**兼容性**: Godot 4.5+
**依赖**: Godot MCP 工具集 + 基础物理知识