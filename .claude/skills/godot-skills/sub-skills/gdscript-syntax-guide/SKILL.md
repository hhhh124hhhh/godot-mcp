---
name: gdscript-syntax-guide
description: GDScript 语法权威指南，提供最新 Godot 4.5 语法规范、最佳实践、缩进规则和代码风格
---

# GDScript 语法权威指南

## 技能概述

`gdscript-syntax-guide` 是专门用于提供 Godot 4.5 环境下 GDScript 语法规范、最佳实践和代码风格的权威指南。该技能确保所有生成的代码符合最新标准和最佳实践。

## 🎯 核心目标

- **语法准确性**: 确保代码符合 Godot 4.5 语法标准
- **缩进规范**: 严格遵守 GDScript 官方缩进规范（制表符缩进）
- **最佳实践**: 提供业界认可的最佳实践示例
- **代码风格**: 统一代码风格和命名规范
- **类型安全**: 推荐强类型和类型提示使用

## 📋 缩进规范（核心重点）

### ✅ 官方推荐标准

#### 基本缩进规则
- **缩进字符**: **必须使用制表符 (Tab)**，而非空格
- **缩进宽度**: 显示为4个字符宽度（编辑器配置）
- **缩进层级**: 每个嵌套层级使用一个Tab
- **对齐**: 严格使用Tab缩进，避免Tab和空格混用

#### 为什么使用制表符
- Godot官方编辑器默认支持和推荐Tab缩进
- 文件大小更小，解析性能更好
- 避免空格/制表符混用导致的显示问题
- 团队协作时缩进一致性更容易保证

#### ✅ 正确示例
```gdscript
# 函数定义无前导缩进
func my_function(param: int) -> void:
    # 函数体内使用一个Tab缩进
    if condition:
        # 嵌套代码块使用两个Tab缩进
        nested_call()
        another_call()

    # 同级别的代码保持一个Tab缩进
    other_call()

# 静态函数同样遵循缩进规则
static func static_function() -> void:
    # 静态函数体内的代码使用一个Tab缩进
    pass
```

#### ❌ 错误示例
```gdscript
# 错误：函数定义前有缩进
    func bad_function() -> void:
        pass

# 错误：混用空格和制表符
func bad_example() -> void:
	var variable = 0    # 这里可能使用了空格
        another_var = 1   # 这里可能使用了不同的缩进

# 错误：缩进层级混乱
func bad_function() -> void:
if condition:
do_something()
		nested_call()
```

## 🔤 类型系统最佳实践

### 强类型推荐
```gdscript
# ✅ 推荐：使用类型提示
var player: Player
var health: int = 100
var position: Vector2 = Vector2.ZERO
var items: Array[String] = []

# ✅ 推荐：函数参数类型
func take_damage(amount: int, damage_type: String) -> void:
    pass

# ✅ 推荐：返回类型
func calculate_damage(base: int, multiplier: float) -> int:
    return int(base * multiplier)
```

### 类型转换安全
```gdscript
# ✅ 推荐：安全类型转换
var node = get_node("Player")
if node is Player:
    var player = node as Player
    player.health -= 10

# ✅ 推荐：使用类型检查
func process_object(object: Variant) -> void:
    match object.get_type():
        TYPE_INT:
            var value = object as int
            print("整数值: ", value)
        TYPE_STRING:
            var text = object as String
            print("字符串: ", text)
        _:
            push_warning("不支持的类型")
```

## 🎨 代码风格指南

### 命名规范
```gdscript
# ✅ 变量和函数：snake_case
var player_health: int = 100
var current_level: String = "level_1"
func calculate_damage() -> int:
    pass

# ✅ 常量：UPPER_SNAKE_CASE
const MAX_HEALTH: int = 100
const GRAVITY: float = 9.8

# ✅ 类名：PascalCase
class_name PlayerController
extends CharacterBody2D

# ✅ 信号：snake_case
signal health_changed(new_health: int)
signal player_died()
```

### 导入组织
```gdscript
# ✅ 推荐：按类型分组导入
# 内置类型
extends Node
class_name MyScript

# 第三方库（如果有）
# import third_party_library

# 本地资源
const MyResource = preload("res://resources/my_resource.gd")

# 本地脚本
const HelperScript = preload("res://scripts/helper.gd")
```

## 🚀 现代GDScript特性

### @export 使用最佳实践
```gdscript
# ✅ 推荐：使用类型化的 @export
@export var max_health: int = 100
@export var movement_speed: float = 300.0
@export var starting_position: Vector2 = Vector2.ZERO

# ✅ 推荐：枚举导出
enum CharacterClass { WARRIOR, MAGE, ARCHER }
@export var character_class: CharacterClass

# ✅ 推荐：资源导出
@export var sprite_texture: Texture2D
@export var collision_shape: Shape2D

# ✅ 推荐：数组导出
@export var inventory_items: Array[ItemResource] = []
@export var dialog_options: Array[String] = []
```

### 信号系统最佳实践
```gdscript
# ✅ 推荐：类型化信号定义
signal health_changed(current: int, maximum: int)
signal level_up(new_level: int)
signal item_collected(item: ItemResource, quantity: int)

# ✅ 推荐：安全信号连接
func _ready() -> void:
    # 检查信号是否存在再连接
    if has_signal("health_changed"):
        health_changed.connect(_on_health_changed)

# ✅ 推荐：信号发射前检查连接
func take_damage(amount: int) -> void:
    health -= amount
    if health_changed.get_connections().size() > 0:
        health_changed.emit(health, max_health)
```

### 字典和数组最佳实践
```gdscript
# ✅ 推荐：类型化集合
var player_stats: Dictionary = {
    "health": 100,
    "mana": 50,
    "level": 1
}

var inventory: Array[ItemResource] = []

# ✅ 推荐：Lua风格字典语法
var character_data = {
    name = "Hero",
    class = "Warrior",
    level = 1
}

# ✅ 推荐：使用 in 操作符检查
if "health" in character_data:
    print("角色有生命值属性")

if required_item in inventory:
    print("拥有必需物品")
```

## 🔧 节点引用模式

### @onready 最佳实践
```gdscript
# ✅ 推荐：使用 @onready 延迟初始化
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: ProgressBar = $UI/HealthBar

# ✅ 推荐：类型化的 @onready
@onready var player: CharacterBody2D = get_node("../Player") as CharacterBody2D
```

### 安全节点访问
```gdscript
# ✅ 推荐：安全的节点获取
func get_player_reference() -> Player:
    var player_node = get_tree().get_first_node_in_group("player")
    if player_node and player_node is Player:
        return player_node
    push_error("场景中未找到玩家节点")
    return null

# ✅ 推荐：节点存在性检查
func setup_weapon(weapon_path: NodePath) -> void:
    if has_node(weapon_path):
        var weapon_node = get_node(weapon_path)
        if weapon_node is Weapon:
            weapon_node.setup()
        else:
            push_warning("指定节点不是武器类型")
    else:
        push_warning("武器节点不存在")
```

## ⚡ 性能优化建议

### 变量声明优化
```gdscript
# ✅ 推荐：使用 const 声明常量
const BASE_DAMAGE: int = 10
const CRITICAL_MULTIPLIER: float = 2.0

# ✅ 推荐：缓存常用引用
@onready var camera: Camera2D = $Camera2D
@onready var animation_tree: AnimationTree = $AnimationTree

# ✅ 推荐：避免不必要的类型转换
func process_damage(damage: int) -> void:
    # 避免重复转换
    health -= damage
    update_health_display()
```

### 内存管理最佳实践
```gdscript
# ✅ 推荐：安全删除节点
func cleanup_effect(effect_node: Node) -> void:
    if effect_node and is_instance_valid(effect_node):
        effect_node.call_deferred("queue_free")

# ✅ 推荐：对象池模式
class_name BulletPool extends Node
var inactive_bullets: Array[Bullet] = []
var active_bullets: Array[Bullet] = []

func get_bullet() -> Bullet:
    if inactive_bullets.size() > 0:
        var bullet = inactive_bullets.pop_back()
        active_bullets.append(bullet)
        return bullet
    return create_new_bullet()

func return_bullet(bullet: Bullet) -> void:
    if bullet in active_bullets:
        active_bullets.erase(bullet)
        inactive_bullets.append(bullet)
        bullet.reset()
```

## 🛡️ 错误处理模式

### 类型安全检查
```gdscript
# ✅ 推荐：完整的错误处理
func load_character_data(path: String) -> CharacterData:
    if not FileAccess.file_exists(path):
        push_error("角色数据文件不存在: " + path)
        return null

    var file = FileAccess.open(path, FileAccess.READ)
    if file == null:
        push_error("无法打开文件: " + path)
        return null

    var json_string = file.get_as_text()
    file.close()

    var json = JSON.new()
    var parse_result = json.parse(json_string)
    if parse_result != OK:
        push_error("JSON解析失败: " + json.get_error_message())
        return null

    var data = json.get_data()
    if not data is Dictionary:
        push_error("无效的角色数据格式")
        return null

    return CharacterData.from_dict(data)
```

## 📝 字符串格式化最佳实践

### 现代字符串格式化
```gdscript
# ✅ 推荐：使用 format() 方法
func format_status_message(health: int, max_health: int) -> String:
    return "生命值: {current}/{maximum}".format({
        "current": health,
        "maximum": max_health
    })

# ✅ 推荐：数组格式化
func format_inventory(items: Array[String]) -> String:
    return "背包物品: {0}, {1}, {2}".format(items)

# ✅ 推荐：数字格式化
func format_damage(damage: float) -> String:
    return "造成 %.1f 点伤害" % damage
```

## 🎮 游戏特定模式

### 状态机实现
```gdscript
# ✅ 推荐：类型化状态机
enum CharacterState { IDLE, WALKING, RUNNING, JUMPING }

class_name CharacterStateMachine extends Node
var current_state: CharacterState = CharacterState.IDLE

func change_state(new_state: CharacterState) -> void:
    if new_state == current_state:
        return

    var old_state = current_state
    _exit_state(old_state)
    current_state = new_state
    _enter_state(new_state)

    state_changed.emit(current_state, old_state)

signal state_changed(new_state: CharacterState, old_state: CharacterState)
```

### 输入处理模式
```gdscript
# ✅ 推荐：结构化输入处理
func _input(event: InputEvent) -> void:
    if not is_processing_input():
        return

    if event is InputEventKey:
        _handle_keyboard_input(event as InputEventKey)
    elif event is InputEventMouseButton:
        _handle_mouse_input(event as InputEventMouseButton)
    elif event is InputEventJoypadButton:
        _handle_controller_input(event as InputEventJoypadButton)

func _handle_keyboard_input(key_event: InputEventKey) -> void:
    if key_event.is_action_pressed("jump"):
        jump()
    elif key_event.is_action_pressed("attack"):
        attack()
```

## 🔍 调试和日志最佳实践

### 结构化日志
```gdscript
# ✅ 推荐：分类日志
func log_debug(message: String, context: Dictionary = {}) -> void:
    if OS.is_debug_build():
        print_rich("[color=gray][DEBUG][/color] ", message)
        if not context.is_empty():
            print("  Context: ", context)

func log_warning(message: String, context: Dictionary = {}) -> void:
    push_warning(message)
    print_rich("[color=yellow][WARNING][/color] ", message)
    if not context.is_empty():
        print("  Context: ", context)

func log_error(message: String, context: Dictionary = {}) -> void:
    push_error(message)
    print_rich("[color=red][ERROR][/color] ", message)
    if not context.is_empty():
        print("  Context: ", context)
```

## 📚 学习资源和检查清单

### 代码审查清单
- [ ] 所有缩进都使用制表符
- [ ] 变量和函数使用 snake_case 命名
- [ ] 类名使用 PascalCase
- [ ] 关键变量有类型提示
- [ ] 函数参数和返回值有类型标注
- [ ] 使用 @onready 延迟获取节点引用
- [ ] 信号连接前进行安全检查
- [ ] 资源加载有错误处理
- [ ] 数组访问前检查索引有效性
- [ ] 字典访问前检查键存在性

### 常见错误预防
1. **缩进错误**: 始终使用制表符，配置编辑器显示宽度为4
2. **类型错误**: 使用类型提示和 `is` 操作符进行类型检查
3. **空引用**: 使用 @onready 和存在性检查避免空引用
4. **信号错误**: 连接前检查信号存在性，断开前检查连接状态
5. **内存泄漏**: 使用 queue_free() 而非 free()，注意对象引用循环

---

**技能状态**: ✅ 可用
**最后更新**: 2025-11-09
**兼容性**: Godot 4.5+
**重点关注**: 缩进规范、类型安全、最佳实践