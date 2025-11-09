# Godot 四要素核心概念教学指南

## 📚 概述

Godot 引擎建立在四个核心概念之上：**节点 (Nodes)**、**场景 (Scenes)**、**场景树 (SceneTree)** 和 **信号 (Signals)**。正确理解这四要素是掌握 Godot 开发的基础。

## 🏗️ 一、节点 (Nodes)

### 1.1 什么是节点
节点是 Godot 中最基本的构建单元，所有游戏对象都是节点或节点的组合。

```gdscript
# 节点是所有游戏对象的基础
extends Node         # 基础节点
extends Sprite2D    # 精灵节点（继承自Node2D）
extends CharacterBody2D  # 角色物理节点
extends Control     # UI控制节点
```

### 1.2 节点的核心特性
- **层次结构**：节点可以包含子节点，形成树状结构
- **组件化**：每个节点提供特定功能（渲染、物理、音频等）
- **生命周期**：节点有 `_ready()`、`_process()`、`_physics_process()` 等生命周期方法

### 1.3 正确的节点访问方式

```gdscript
class_name Player extends CharacterBody2D

# ✅ 正确：使用 @onready 延迟初始化
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $UI/HealthBar

# ✅ 正确：使用 get_node() 和相对路径
var weapon = get_node("Equipment/Weapon")
var camera = get_node("../Camera2D")  # 访问父节点的子节点

# ✅ 正确：使用 get_tree() 访问场景树中的节点
var main_menu = get_tree().get_first_node_in_group("main_menu")
var player = get_tree().root.get_node("World/Player")

# ❌ 错误：在 _ready() 之前访问子节点
# var sprite = $Sprite2D  # 这样写会导致空引用错误
```

### 1.4 节点生命周期

```gdscript
extends Node

# 节点进入场景树时调用（仅一次）
func _ready() -> void:
    print("节点已准备就绪")
    # 在这里访问其他节点和设置初始状态

# 每帧调用（默认60FPS）
func _process(delta: float) -> void:
    # 处理游戏逻辑、动画、输入等
    pass

# 物理帧调用（默认60FPS，与物理引擎同步）
func _physics_process(delta: float) -> void:
    # 处理物理相关逻辑
    pass

# 节点退出场景树时调用
func _exit_tree() -> void:
    print("节点即将被移除")
    # 清理资源、断开连接等
```

## 🎬 二、场景 (Scenes)

### 2.1 什么是场景
场景是节点的集合，保存为 `.tscn` 文件。场景可以重用、实例化和继承。

```gdscript
# 场景是节点的集合，可以保存和重用
var player_scene = preload("res://scenes/player.tscn")
var enemy_scene = load("res://scenes/enemy.tscn")
```

### 2.2 正确的场景管理方式

```gdscript
# ✅ 正确：实例化场景
func spawn_enemy(spawn_position: Vector2) -> void:
    var enemy_scene = preload("res://scenes/enemy.tscn")
    var enemy_instance = enemy_scene.instantiate()  # 注意：是 instantiate() 不是 instance()

    # 设置位置
    enemy_instance.global_position = spawn_position

    # 添加到场景树
    get_tree().current_scene.add_child(enemy_instance)

# ✅ 正确：队列释放节点
func destroy_object(object: Node) -> void:
    # 使用 queue_free() 安全删除节点
    object.queue_free()
    # 不要直接调用 free()，可能导致崩溃

# ✅ 正确：场景切换
func go_to_main_menu() -> void:
    # 使用 SceneTree 的场景切换方法
    get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func go_to_game_level() -> void:
    var level_scene = preload("res://scenes/level_1.tscn")
    get_tree().change_scene_to_packed(level_scene)
```

### 2.3 场景继承

```gdscript
# base_enemy.tscn (基础敌人场景)
# 包含：CollisionShape2D, Sprite2D, HealthBar

# flying_enemy.tscn (继承自 base_enemy)
# 添加：飞行行为节点、额外碰撞区域

# 在脚本中：
extends "res://scripts/base_enemy.gd"

func _ready() -> void:
    super._ready()  # 调用父类方法
    # 添加飞行逻辑
```

## 🌳 三、场景树 (SceneTree)

### 3.1 什么是场景树
场景树管理所有节点的层次结构，是整个游戏场景的管理者。

```gdscript
# SceneTree 是单例，通过 get_tree() 访问
var scene_tree = get_tree()

# 获取重要引用
var current_scene = scene_tree.current_scene  # 当前活动场景的根节点
var root_window = scene_tree.root             # 场景树的根窗口
```

### 3.2 正确的场景树操作

```gdscript
# ✅ 正确：获取当前场景
func get_current_level() -> Node:
    return get_tree().current_scene

# ✅ 正确：创建计时器
func create_delayed_action(delay: float) -> void:
    var timer = get_tree().create_timer(delay)
    timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout() -> void:
    print("延迟执行完成")

# ✅ 正确：节点组操作
func activate_all_enemies() -> void:
    # 调用组内所有节点的方法
    get_tree().call_group("enemies", "activate")

    # 设置组内节点的属性
    get_tree().set_group("enemies", "is_active", true)

func get_all_enemies() -> Array:
    return get_tree().get_nodes_in_group("enemies")

# ✅ 正确：暂停和恢复游戏
func pause_game() -> void:
    get_tree().paused = true

func resume_game() -> void:
    get_tree().paused = false
```

### 3.3 常见错误和修正

```gdscript
# ❌ 错误：直接设置 current_scene
# get_tree().current_scene = new_scene  # 这样不会正确处理场景切换

# ✅ 正确：使用场景切换方法
get_tree().change_scene_to_file("res://new_scene.tscn")

# ❌ 错误：在错误的时机访问场景树
# 在 _init() 中访问 get_tree() 可能返回 null

# ✅ 正确：在 _ready() 或之后访问场景树
func _ready() -> void:
    var player = get_tree().get_first_node_in_group("player")
```

## ⚡ 四、信号 (Signals)

### 4.1 什么是信号
信号是 Godot 的观察者模式实现，用于节点间的解耦通信。

```gdscript
# 信号定义
signal health_changed(new_health: int, max_health: int)
signal died()
signal item_collected(item: Item)
```

### 4.2 正确的信号使用方式 (Godot 4.x)

```gdscript
# === 发送信号 ===

class_name Player extends CharacterBody2D
signal health_changed(new_health: int, max_health: int)

func take_damage(damage: int) -> void:
    health -= damage
    # ✅ 正确：发送信号
    health_changed.emit(health, max_health)

    if health <= 0:
        died.emit()

# === 连接信号 ===

class_name UIHealthBar extends Control
var player: Player

func setup(player_ref: Player) -> void:
    player = player_ref

    # ✅ 正确：推荐使用新的连接语法
    player.health_changed.connect(_on_player_health_changed)
    player.died.connect(_on_player_died)

# ✅ 正确：信号处理函数
func _on_player_health_changed(new_health: int, max_health: int) -> void:
    health_bar.value = float(new_health) / float(max_health) * 100.0

func _on_player_died() -> void:
    game_over_panel.show()
```

### 4.3 高级信号用法

```gdscript
# ✅ 使用 lambda 表达式（匿名函数）
button.pressed.connect(func():
    print("按钮被点击")
    start_game()
)

# ✅ 带参数的 lambda 连接
timer.timeout.connect(func():
    spawn_enemy()
    start_next_wave()
)

# ✅ 使用 Callable 包装
func setup_custom_signal(object: Object, method_name: String) -> void:
    var callable = Callable(self, method_name)
    some_signal.connect(callable)

# ✅ 断开信号连接
func cleanup() -> void:
    if player and player.health_changed.is_connected(_on_player_health_changed):
        player.health_changed.disconnect(_on_player_health_changed)
```

### 4.4 信号最佳实践

```gdscript
class_name Weapon extends Node2D
signal ammo_changed(current_ammo: int, max_ammo: int)
signal weapon_fired(position: Vector2, direction: Vector2)
signal reload_started()
signal reload_completed()

# ✅ 在信号中传递必要的信息
func fire() -> void:
    if current_ammo > 0 and not is_reloading:
        current_ammo -= 1
        weapon_fired.emit(global_position, look_direction)
        ammo_changed.emit(current_ammo, max_ammo)

# ✅ 使用信号验证
func try_connect_to_player(player: Player) -> bool:
    if not player:
        return false

    if not player.has_signal("weapon_equipped"):
        push_error("Player 没有 weapon_equipped 信号")
        return false

    player.weapon_equipped.connect(_on_equipped)
    return true
```

## 🔗 四要素协同工作示例

### 完整的游戏场景示例

```gdscript
# 主场景管理器
class_name GameManager extends Node

signal game_started()
signal game_paused()
signal game_over()

var player: Player
var ui: GameUI
var enemy_spawner: EnemySpawner

func _ready() -> void:
    _setup_connections()
    _load_game_scene()

func _setup_connections() -> void:
    # 连接UI信号
    ui.start_button.pressed.connect(_on_start_game)
    ui.pause_button.pressed.connect(_on_pause_game)

    # 连接玩家信号（场景树中的节点）
    player = get_tree().get_first_node_in_group("player")
    if player:
        player.died.connect(_on_player_died)
        player.health_changed.connect(ui.update_health_display)

func _on_start_game() -> void:
    # 重置游戏状态
    _reset_game_state()

    # 通过场景树激活所有敌人
    get_tree().call_group("enemies", "activate")

    # 发送游戏开始信号
    game_started.emit()

func _on_player_died() -> void:
    # 游戏结束逻辑
    get_tree().call_group("enemies", "deactivate")
    game_over.emit()

    # 延迟后显示游戏结束界面
    var timer = get_tree().create_timer(2.0)
    timer.timeout.connect(ui.show_game_over_screen)

func _load_game_scene() -> void:
    # 场景切换
    get_tree().change_scene_to_file("res://scenes/game_world.tscn")
    await get_tree().scene_changed

    # 场景加载完成后重新设置引用
    player = get_tree().get_first_node_in_group("player")
    ui = get_tree().get_first_node_in_group("ui")
```

## 🚨 常见错误和解决方案

### 错误1：错误的节点访问时机

```gdscript
# ❌ 错误
extends Node
var sprite = $Sprite2D  # 在类定义时访问，此时节点还未准备好

# ✅ 正确
extends Node
@onready var sprite: Sprite2D = $Sprite2D  # 使用 @onready 延迟初始化
```

### 错误2：场景切换方式错误

```gdscript
# ❌ 错误
func next_level():
    get_tree().current_scene = preload("res://level2.tscn").instantiate()

# ✅ 正确
func next_level():
    get_tree().change_scene_to_file("res://level2.tscn")
```

### 错误3：信号连接语法过时

```gdscript
# ❌ 错误 (Godot 3.x 语法)
player.connect("health_changed", self, "_on_health_changed")

# ✅ 正确 (Godot 4.x 语法)
player.health_changed.connect(_on_health_changed)
```

### 错误4：内存泄漏

```gdscript
# ❌ 错误：忘记断开信号连接
func _ready():
    some_node.some_signal.connect(_on_some_signal)

# ✅ 正确：在节点退出时断开连接
func _exit_tree():
    if some_node and some_node.some_signal.is_connected(_on_some_signal):
        some_node.some_signal.disconnect(_on_some_signal)
```

## 📋 检查清单

在编写 Godot 代码时，请检查：

- [ ] 节点访问是否使用 `@onready` 或在 `_ready()` 之后
- [ ] 场景切换是否使用 `change_scene_to_file()` 等正确方法
- [ ] 信号连接是否使用 Godot 4.x 的新语法
- [ ] 是否正确处理了信号连接的断开，避免内存泄漏
- [ ] 节点删除是否使用 `queue_free()` 而非直接 `free()`
- [ ] 场景树操作是否通过 `get_tree()` 正确访问

---

**版本**: Godot 4.5
**最后更新**: 2025-11-09
**作者**: Godot MCP 开发团队