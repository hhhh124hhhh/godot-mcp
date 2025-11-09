---
name: godot-ui-designer
description: Godot UI界面系统开发专家，支持自然语言描述自动创建菜单、HUD、对话框、响应式布局等完整UI系统
---

# Godot UI界面设计专家技能

> **重要提示**: 本技能的所有代码示例均基于 **Godot 4.5** 最佳实践，使用 GDScript 语法。
> 确保在 Godot 4.x 环境中使用，特别注意 Control 节点和信号系统的新特性。

## 技能概述

`godot-ui-designer` 是专门用于 Godot 游戏UI界面系统开发的智能化技能，能够根据用户的自然语言描述自动创建完整的用户界面系统，包括主菜单、游戏内HUD、设置界面、对话框、响应式布局等。

## 核心功能

### 📱 响应式布局系统
- **自适应布局**：支持不同分辨率和屏幕比例
- **锚点系统**：智能锚点定位和布局管理
- **容器布局**：GridContainer、HBoxContainer、VBoxContainer等
- **动态调整**：运行时布局调整和适配

### 🎨 视觉设计系统
- **主题管理**：统一的UI主题和样式系统
- **动画过渡**：流畅的UI动画和过渡效果
- **粒子效果**：UI特效和视觉反馈
- **颜色方案**：协调的颜色搭配和对比度

### 🎮 游戏HUD组件
- **状态显示**：血条、魔法条、经验条、等级显示
- **小地图系统**：可缩放的小地图和标记系统
- **物品栏**：可拖拽的物品栏和快捷栏
- **任务信息**：任务列表、目标追踪、提示信息

### 📋 菜单系统
- **主菜单**：游戏启动、设置、退出等选项
- **暂停菜单**：游戏暂停、继续、重启、设置
- **设置界面**：图形、音频、控制、游戏性设置
- **角色选择**：角色创建、选择、自定义

## 使用方法

### 创建游戏HUD
```
用户: "我需要一个像王者荣耀那样的游戏HUD，包含血条、蓝条、技能栏和地图"
系统: 自动实现：
- 顶部血条和蓝条显示
- 底部技能栏（4-6个技能）
- 右上角小地图系统
- 左上角角色信息和等级
- 击杀信息和连击提示
```

### 设计主菜单
```
用户: "创建一个现代化的游戏主菜单，有背景动画和音效"
系统: 智能生成：
- 动态背景效果
- 渐显式菜单选项
- 悬停和点击动画
- 设置和关于对话框
- 背景音乐和音效集成
```

### 设置界面
```
用户: "做一个完整的设置界面，包含图形、音频、控制和游戏设置"
系统: 全面开发：
- 图形设置（分辨率、全屏、画质）
- 音频控制（主音量、音乐、音效）
- 控制配置（键位映射、手柄支持）
- 游戏性选项（难度、字幕、辅助功能）
```

### 响应式布局
```
用户: "确保UI在手机和平板上都能正常显示"
系统: 自动适配：
- 不同屏幕分辨率的布局调整
- 触控友好的按钮大小
- 平板模式的优化布局
- 横竖屏切换支持
```

## 工作流程

### 1. 需求分析
```bash
# 分析UI需求
- 识别界面类型和功能
- 确定目标平台和屏幕尺寸
- 提取设计风格和交互要求
```

### 2. 架构设计
```bash
# 设计UI架构
- 选择合适的Control节点类型
- 规划界面层次结构
- 设计数据绑定机制
```

### 3. 视觉设计
```bash
# 创建视觉元素
- 设计配色方案和主题
- 创建图标和背景资源
- 配置字体和文字样式
```

### 4. 交互实现
```bash
# 实现交互逻辑
- 添加按钮和事件处理
- 实现动画和过渡效果
- 配置输入和导航系统
```

## MCP 工具集成

### UI节点工具
- `create_node` - 创建UI节点（Button、Label、Panel等）
- `configure_node` - 配置UI节点属性
- `add_child_node` - 添加子UI节点
- `style_node` - 设置UI节点样式

### 场景管理工具
- `create_scene` - 创建UI场景
- `instance_scene` - 实例化UI预制件
- `save_scene` - 保存UI场景
- `load_scene` - 加载UI场景

### 资源管理工具
- `create_resource` - 创建UI资源（Theme、StyleBox等）
- `import_asset` - 导入UI素材（图标、字体等）
- `configure_resource` - 配置资源属性

### 调试测试工具
- `play_scene` - 测试UI场景
- `get_node_properties` - 获取UI节点属性
- `set_node_property` - 设置UI节点属性
- `simulate_input` - 模拟用户输入测试

## UI组件库

### 基础组件
```gdscript
# 智能按钮组件
class_name SmartButton extends Button
@export var hover_scale: float = 1.1
@export var click_sound: AudioStream
@export var animation_duration: float = 0.2

func _ready() -> void:
    mouse_entered.connect(_on_hover)
    pressed.connect(_on_pressed)

# 动态血条组件
class_name HealthBar extends ProgressBar
@export var animate_changes: bool = true
@export var animation_speed: float = 5.0
var target_health: float

func _process(delta: float) -> void:
    if animate_changes and value != target_health:
        value = move_toward(value, target_health, animation_speed * delta)
```

### 高级组件
```gdscript
# 小地图系统
class_name Minimap extends Control
@export var minimap_size: Vector2 = Vector2(200, 200)
@export var world_size: Vector2 = Vector2(1000, 1000)
var player_marker: TextureRect
var enemy_markers: Array[TextureRect]

func update_player_position(world_pos: Vector2) -> void:
    var minimap_pos = (world_pos / world_size) * minimap_size
    player_marker.position = minimap_pos

# 技能栏系统
class_name SkillBar extends HBoxContainer
@export var skill_count: int = 4
var skill_slots: Array[SkillSlot]

func _ready() -> void:
    for i in skill_count:
        var slot = SkillSlot.new()
        slot.skill_index = i
        add_child(slot)
        skill_slots.append(slot)
```

## 布局系统

### 响应式布局
```gdscript
# 自适应布局管理器
class_name ResponsiveLayout extends Control
@export var mobile_breakpoint: int = 768
@export var tablet_breakpoint: int = 1024

func _ready() -> void:
    get_tree().get_window().size_changed.connect(_on_screen_resized)
    _on_screen_resized()

func _on_screen_resized() -> void:
    var screen_size = DisplayServer.screen_get_size()
    var layout_type = _determine_layout_type(screen_size.x)
    _apply_layout(layout_type)

func _determine_layout_type(width: int) -> String:
    if width < mobile_breakpoint:
        return "mobile"
    elif width < tablet_breakpoint:
        return "tablet"
    else:
        return "desktop"
```

### 动态布局
```gdscript
# 动态网格布局
class_name DynamicGrid extends GridContainer
@export var min_columns: int = 2
@export var max_columns: int = 6
@export var item_size: Vector2 = Vector2(100, 100)

func _ready() -> void:
    custom_minimum_size = Vector2(min_columns * item_size.x, item_size.y)
    resize_children()

func resize_children() -> void:
    var available_width = size.x
    var columns = clamp(int(available_width / item_size.x), min_columns, max_columns)
    columns = columns

    for child in get_children():
        if child is Control:
            child.custom_minimum_size = item_size
```

## 动画系统

### UI动画库
```gdscript
# UI动画管理器
class_name UIAnimationManager extends Node
var tween: Tween

func slide_in(node: Control, direction: Vector2, duration: float = 0.5) -> void:
    var start_pos = node.position - direction * 100
    var end_pos = node.position

    node.position = start_pos
    node.modulate.a = 0.0

    create_tween().parallel()\
        .tween_property(node, "position", end_pos, duration)\
        .set_trans(Tween.TRANS_CUBIC)\
        .set_ease(Tween.EASE_OUT)
    create_tween().parallel()\
        .tween_property(node, "modulate:a", 1.0, duration)

func bounce_effect(node: Control) -> void:
    var original_scale = node.scale
    create_tween().tween_property(node, "scale", original_scale * 1.2, 0.1)\
        .set_trans(Tween.TRANS_BACK)\
        .set_ease(Tween.EASE_OUT)
    create_tween().tween_property(node, "scale", original_scale, 0.2)\
        .set_trans(Tween.TRANS_BOUNCE)\
        .set_ease(Tween.EASE_OUT)
```

## 主题系统

### 主题管理
```gdscript
# 主题管理器
class_name ThemeManager extends Node
@export var light_theme: Theme
@export var dark_theme: Theme
@export var current_theme: Theme

func _ready() -> void:
    apply_theme(current_theme)

func switch_theme(theme_name: String) -> void:
    match theme_name:
        "light":
            current_theme = light_theme
        "dark":
            current_theme = dark_theme
    apply_theme(current_theme)

func apply_theme(theme: Theme) -> void:
    # ✅ 正确：检查场景树是否存在和当前场景是否可用
    if get_tree() and get_tree().current_scene:
        var ui_root = get_tree().current_scene
        _apply_theme_recursive(ui_root, theme)
    else:
        push_warning("场景树未准备就绪，无法应用主题")

func _apply_theme_recursive(node: Node, theme: Theme) -> void:
    if node is Control:
        node.theme = theme

    for child in node.get_children():
        _apply_theme_recursive(child, theme)
```

## 数据绑定系统

### UI数据绑定
```gdscript
# 数据绑定管理器
class_name DataBindingManager extends Node
var bindings: Dictionary = {}

func bind_ui_element(ui_node: Control, data_source: Object, property: String) -> void:
    var binding = {
        "ui_node": ui_node,
        "data_source": data_source,
        "property": property
    }
    bindings[ui_node.get_instance_id()] = binding

    # 连接数据源变化信号
    if data_source.has_signal("changed"):
        data_source.changed.connect(_on_data_changed.bind(ui_node))

func _on_data_changed(ui_node: Control) -> void:
    var binding = bindings.get(ui_node.get_instance_id())
    if binding:
        var value = binding.data_source.get(binding.property)
        _update_ui_value(ui_node, value)

func _update_ui_value(ui_node: Control, value) -> void:
    if ui_node is Label:
        ui_node.text = str(value)
    elif ui_node is ProgressBar:
        ui_node.value = value
    elif ui_node is TextureProgressBar:
        ui_node.value = value
```

## 智能特性

### 自动适配
- **屏幕检测**：自动检测屏幕尺寸和比例
- **布局调整**：智能调整UI布局和元素大小
- **字体缩放**：动态调整字体大小和间距
- **控件重排**：自动重排控件以适应屏幕

### 用户体验优化
- **响应时间**：优化UI响应速度和流畅度
- **可访问性**：支持色盲模式和高对比度
- **多语言**：支持多语言文本和本地化
- **手柄支持**：完整的手柄导航和支持

### 性能优化
- **批处理渲染**：优化UI渲染性能
- **延迟加载**：UI元素的延迟加载和释放
- **内存管理**：合理的UI资源内存管理
- **帧率优化**：确保UI不影响游戏帧率

## 示例实现

### 完整游戏HUD
```gdscript
# 游戏HUD主控制器
class_name GameHUD extends CanvasLayer
@onready var health_bar: ProgressBar = $TopPanel/HealthBar
@onready var mana_bar: ProgressBar = $TopPanel/ManaBar
@onready var level_label: Label = $TopPanel/LevelLabel
@onready var minimap: Minimap = $MinimapContainer/Minimap
@onready var skill_bar: SkillBar = $BottomPanel/SkillBar
@onready var kill_feed: VBoxContainer = $RightPanel/KillFeed

var player: Player

func _ready() -> void:
    # 连接玩家信号
    player.health_changed.connect(_on_health_changed)
    player.mana_changed.connect(_on_mana_changed)
    player.level_up.connect(_on_level_up)

func _on_health_changed(new_health: int, max_health: int) -> void:
    health_bar.max_value = max_health
    health_bar.value = new_health

    # 血量低时显示红色警告
    if new_health < max_health * 0.3:
        health_bar.modulate = Color.RED
        create_low_health_effect()

func _on_mana_changed(new_mana: int, max_mana: int) -> void:
    mana_bar.max_value = max_mana
    mana_bar.value = new_mana

func _on_level_up(new_level: int) -> void:
    level_label.text = "Lv. %d" % new_level
    create_level_up_effect()
```

### 设置界面系统
```gdscript
# 设置界面控制器
class_name SettingsMenu extends Control
@onready var tab_container: TabContainer = $TabContainer
@onready var graphics_tab: Control = $TabContainer/Graphics
@onready var audio_tab: Control = $TabContainer/Audio
@onready var controls_tab: Control = $TabContainer/Controls

func _ready() -> void:
    _load_settings()
    _setup_controls()

func _load_settings() -> void:
    # 加载图形设置
    var resolution_option = graphics_tab.get_node("ResolutionOption")
    resolution_option.selected = _get_current_resolution_index()

    # 加载音频设置
    var master_slider = audio_tab.get_node("MasterVolume")
    master_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))

func _save_settings() -> void:
    # 保存图形设置
    var resolution_option = graphics_tab.get_node("ResolutionOption")
    var selected_resolution = resolution_option.get_item_text(resolution_option.selected)
    _apply_resolution(selected_resolution)

    # 保存音频设置
    var master_slider = audio_tab.get_node("MasterVolume")
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_slider.value)
```

## 质量保证

### 视觉质量
- **设计一致性**：确保UI风格统一
- **颜色对比度**：符合可访问性标准
- **字体可读性**：清晰的字体和大小设置
- **动画流畅性**：60FPS的流畅动画体验

### 功能完整性
- **事件处理**：完整的用户输入处理
- **错误处理**：优雅的错误处理和恢复
- **数据验证**：输入数据的验证和过滤
- **状态管理**：正确的UI状态管理

### 性能优化
- **渲染优化**：减少draw call和overdraw
- **内存优化**：合理的纹理和资源管理
- **响应优化**：快速的UI响应和反馈
- **电池优化**：移动设备的电池使用优化

## 使用限制和注意事项

### 设计限制
- **复杂度控制**：超复杂UI需要分步实现
- **性能考虑**：大量UI元素可能影响性能
- **平台差异**：不同平台的UI规范差异

### 最佳实践
- **用户中心**：以用户体验为中心设计
- **迭代测试**：频繁测试和收集反馈
- **渐进增强**：核心功能优先，增强功能后续添加

## 故障排除

### 常见问题
1. **布局错乱**：检查锚点和容器设置
2. **动画卡顿**：优化动画性能和复杂度
3. **响应延迟**：检查事件处理和绑定
4. **主题失效**：验证主题资源路径

### 调试技巧
- 使用Godot的UI调试工具
- 检查控制台的警告信息
- 监控内存和性能指标
- 测试不同分辨率下的显示效果

## 更新日志

### v1.0.0 (当前版本)
- 基础UI组件系统
- 响应式布局支持
- 主题管理功能
- 动画系统集成

### 计划功能
- 高级动画效果
- 可视化UI编辑器
- 更多UI组件模板
- 实时协作设计

---

**技能状态**: ✅ 可用
**最后更新**: 2025-11-09
**兼容性**: Godot 4.5+
**依赖**: Godot MCP 工具集 + UI设计知识