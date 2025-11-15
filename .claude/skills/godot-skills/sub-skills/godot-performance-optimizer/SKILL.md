---
name: godot-performance-optimizer
description: Godot 性能优化与适配专家，支持自然语言描述自动完成分辨率适配、性能分析、内存优化、帧率提升等优化工作
---

# Godot 性能优化专家技能

## 技能概述

`godot-performance-optimizer` 是专门用于 Godot 游戏性能优化和平台适配的智能化技能，能够根据用户的自然语言描述自动完成分辨率适配、性能分析、内存优化、帧率提升、平台适配等全面的性能优化工作。

## 核心功能

### 📱 分辨率适配系统
- **多分辨率支持**：自动适配不同屏幕分辨率和比例
- **DPI缩放**：智能DPI检测和UI缩放
- **横竖屏切换**：动态横竖屏布局适配
- **平台特定优化**：针对不同平台的显示优化

### ⚡ 性能分析工具
- **帧率监控**：实时FPS监控和分析
- **内存分析**：内存使用情况追踪和优化建议
- **渲染分析**：Draw call、Overdraw等渲染性能分析
- **瓶颈检测**：自动检测性能瓶颈和热点代码

### 🧠 内存优化系统
- **对象池管理**：智能对象池和内存回收
- **资源压缩**：纹理、音频等资源的智能压缩
- **垃圾回收优化**：GC策略优化和内存碎片整理
- **流式加载**：大型资源的流式加载和卸载

### 🎮 渲染优化
- **批处理优化**：减少Draw call和渲染批次
- **LOD系统**：细节层次距离优化
- **遮挡剔除**：智能遮挡剔除和视锥剔除
- **着色器优化**：GPU着色器性能优化

## 使用方法

### 分辨率适配优化
```
用户: "我的游戏在不同手机上显示不正常，需要适配各种屏幕尺寸"
系统: 自动实现：
- 检测目标设备分辨率范围
- 设计响应式布局系统
- 配置自动缩放和锚点
- 优化UI元素大小和间距
- 测试各种分辨率下的显示效果
```

### 性能分析和优化
```
用户: "游戏在低端设备上运行卡顿，需要优化到60FPS"
系统: 智能优化：
- 全面性能分析和瓶颈检测
- 优化渲染管线和Draw call
- 减少物理计算开销
- 优化脚本执行效率
- 调整画质设置和特效等级
```

### 内存使用优化
```
用户: "游戏内存占用过高，经常闪退，需要优化内存使用"
系统: 全面优化：
- 分析内存使用热点
- 实现智能对象池系统
- 优化资源加载和卸载策略
- 压缩纹理和音频资源
- 配置垃圾回收策略
```

### 平台性能适配
```
用户: "需要为PC、移动、主机三个平台优化性能"
系统: 多平台优化：
- 针对不同平台的性能策略
- 平台特定的渲染设置
- 输入和UI适配优化
- 性能分级和质量设置
```

## 工作流程

### 1. 性能分析阶段
```bash
# 全面性能检测
- 帧率和稳定性分析
- 内存使用情况检测
- 渲染性能瓶颈识别
- CPU和GPU使用率分析
```

### 2. 优化策略制定
```bash
# 制定优化方案
- 确定优化优先级
- 选择合适的优化技术
- 平衡画质和性能
- 制定分阶段优化计划
```

### 3. 自动优化实施
```bash
# 执行优化操作
- 自动调整渲染设置
- 优化代码和算法
- 配置资源压缩
- 实现内存管理策略
```

### 4. 效果验证
```bash
# 验证优化效果
- 对比优化前后性能
- 测试不同设备表现
- 验证稳定性改善
- 生成优化报告
```

## MCP 工具集成

### 性能分析工具
- `get_performance_metrics` - 获取性能指标
- `analyze_memory_usage` - 分析内存使用
- `profile_render_performance` - 分析渲染性能
- `detect_performance_bottlenecks` - 检测性能瓶颈

### 优化操作工具
- `optimize_render_settings` - 优化渲染设置
- `compress_textures` - 压缩纹理资源
- `configure_object_pools` - 配置对象池
- `adjust_quality_settings` - 调整画质设置

### 平台适配工具
- `detect_platform_capabilities` - 检测平台能力
- `configure_platform_settings` - 配置平台设置
- `optimize_for_platform` - 针对平台优化
- `test_platform_performance` - 测试平台性能

### 监控调试工具
- `create_performance_monitor` - 创建性能监控器
- `setup_debug_overlay` - 设置调试界面
- `log_performance_data` - 记录性能数据
- `generate_performance_report` - 生成性能报告

## 分辨率适配系统

### 智能布局管理器
```gdscript
# 响应式布局管理器
class_name ResponsiveLayoutManager extends Control
@export var base_resolution: Vector2 = Vector2(1920, 1080)
@export var support_orientations: bool = true

var current_scale: float = 1.0
var current_resolution: Vector2

func _ready() -> void:
    get_tree().get_window().size_changed.connect(_on_window_resized)
    _on_window_resized()

func _on_window_resized() -> void:
    var window_size = get_tree().get_window().size
    current_resolution = window_size
    current_scale = _calculate_scale_factor(window_size)
    _apply_scaling()

func _calculate_scale_factor(window_size: Vector2) -> float:
    var scale_x = window_size.x / base_resolution.x
    var scale_y = window_size.y / base_resolution.y

    # 使用最小缩放比例确保内容完全可见
    return min(scale_x, scale_y)

func _apply_scaling() -> void:
    # 应用缩放到所有子控件
    for child in get_children():
        if child is Control:
            _scale_control_recursive(child, current_scale)
```

### DPI适配系统
```gdscript
# DPI适配管理器
class_name DPIAdapter extends Node
var base_dpi: float = 96.0  # 标准DPI
var current_dpi: float = 96.0
var scale_factor: float = 1.0

func _ready() -> void:
    _detect_dpi()
    _apply_dpi_scaling()

func _detect_dpi() -> void:
    var screen = DisplayServer.screen_get_screen_rect()
    var physical_size = DisplayServer.screen_get_size()

    # 计算DPI
    var diagonal_pixels = sqrt(physical_size.x^2 + physical_size.y^2)
    var diagonal_inches = sqrt(screen.size.x^2 + screen.size.y^2) / base_dpi
    current_dpi = diagonal_pixels / diagonal_inches

    scale_factor = current_dpi / base_dpi

func _apply_dpi_scaling() -> void:
    # 调整字体大小
    var theme = get_tree().current_scene.get_theme()
    if theme:
        _scale_font_sizes(theme, scale_factor)

    # 调整UI元素间距
    _scale_ui_spacing(scale_factor)
```

## 性能分析系统

### 实时性能监控器
```gdscript
# 性能监控器
class_name PerformanceMonitor extends Node
@export var monitoring_interval: float = 1.0
@export var enable_debug_overlay: bool = true

var fps_history: Array[float] = []
var memory_history: Array[float] = []
var draw_call_history: Array[int] = []

var debug_overlay: Control

func _ready() -> void:
    if enable_debug_overlay:
        _create_debug_overlay()

    var timer = Timer.new()
    timer.timeout.connect(_update_metrics)
    timer.wait_time = monitoring_interval
    timer.autostart = true
    add_child(timer)

func _update_metrics() -> void:
    # 收集性能指标
    var current_fps = Engine.get_frames_per_second()
    var memory_usage = OS.get_static_memory_usage_by_type()
    var draw_calls = RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_DRAW_CALLS_IN_FRAME)

    # 更新历史数据
    fps_history.append(current_fps)
    memory_history.append(memory_usage[OS.MEMORY_TYPE_STATIC] / 1024.0 / 1024.0)  # MB
    draw_call_history.append(draw_calls)

    # 保持历史数据在合理范围内
    if fps_history.size() > 60:
        fps_history.pop_front()
        memory_history.pop_front()
        draw_call_history.pop_front()

    # 更新调试界面
    if debug_overlay:
        _update_debug_overlay()

func get_performance_summary() -> Dictionary:
    var avg_fps = 0.0
    if fps_history.size() > 0:
        avg_fps = fps_history.reduce(func(sum, fps): return sum + fps, 0.0) / fps_history.size()

    return {
        "average_fps": avg_fps,
        "min_fps": fps_history.min() if fps_history.size() > 0 else 0,
        "max_fps": fps_history.max() if fps_history.size() > 0 else 0,
        "memory_usage_mb": memory_history[-1] if memory_history.size() > 0 else 0,
        "draw_calls": draw_calls[-1] if draw_calls.size() > 0 else 0
    }
```

### 性能瓶颈检测器
```gdscript
# 性能瓶颈检测器
class_name PerformanceBottleneckDetector extends Node
@export var analysis_duration: float = 5.0
@export var fps_threshold: float = 30.0
@export var memory_threshold_mb: float = 500.0

var analysis_active: bool = false
var analysis_start_time: float = 0.0

func start_analysis() -> void:
    analysis_active = true
    analysis_start_time = Time.get_time_dict_from_system().hour * 3600 + \
                         Time.get_time_dict_from_system().minute * 60 + \
                         Time.get_time_dict_from_system().second

func _process(delta: float) -> void:
    if not analysis_active:
        return

    var current_time = Time.get_time_dict_from_system().hour * 3600 + \
                      Time.get_time_dict_from_system().minute * 60 + \
                      Time.get_time_dict_from_system().second

    if current_time - analysis_start_time >= analysis_duration:
        _analyze_and_report()
        analysis_active = false

func _analyze_and_report() -> void:
    var report = {}

    # 检测FPS问题
    var fps = Engine.get_frames_per_second()
    if fps < fps_threshold:
        report["fps_issue"] = {
            "current_fps": fps,
            "threshold": fps_threshold,
            "suggestions": _get_fps_optimization_suggestions(fps)
        }

    # 检测内存问题
    var memory_mb = OS.get_static_memory_usage_by_type()[OS.MEMORY_TYPE_STATIC] / 1024.0 / 1024.0
    if memory_mb > memory_threshold_mb:
        report["memory_issue"] = {
            "current_memory_mb": memory_mb,
            "threshold_mb": memory_threshold_mb,
            "suggestions": _get_memory_optimization_suggestions(memory_mb)
        }

    # 输出报告
    _output_performance_report(report)
```

## 内存优化系统

### 智能对象池
```gdscript
# 智能对象池管理器
class_name SmartObjectPool extends Node
var pools: Dictionary = {}

@export var max_pool_size: int = 100
@export var cleanup_interval: float = 30.0

func _ready() -> void:
    var cleanup_timer = Timer.new()
    cleanup_timer.timeout.connect(_cleanup_unused_objects)
    cleanup_timer.wait_time = cleanup_interval
    cleanup_timer.autostart = true
    add_child(cleanup_timer)

func get_object(object_scene: PackedScene) -> Node:
    var scene_path = object_scene.resource_path
    var pool = pools.get(scene_path)

    if not pool:
        pool = []
        pools[scene_path] = pool

    # 从池中获取对象
    if pool.size() > 0:
        var obj = pool.pop_back()
        obj.visible = true
        obj.set_process(true)
        return obj

    # 池中没有可用对象，创建新对象
    return object_scene.instantiate()

func return_object(obj: Node) -> void:
    var scene_path = obj.scene_file_path
    var pool = pools.get(scene_path)

    if not pool:
        pool = []
        pools[scene_path] = pool

    # 如果池未满，将对象返回池中
    if pool.size() < max_pool_size:
        obj.visible = false
        obj.set_process(false)
        obj.get_parent().remove_child(obj)
        pool.append(obj)
    else:
        # 池已满，直接删除对象
        obj.queue_free()

func _cleanup_unused_objects() -> void:
    for scene_path in pools.keys():
        var pool = pools[scene_path]
        # 清理池中一半的对象
        var cleanup_count = pool.size() / 2
        for i in range(cleanup_count):
            pool.pop_front().queue_free()
```

### 资源压缩优化器
```gdscript
# 资源压缩优化器
class_name AssetCompressionOptimizer extends Node

func optimize_textures_recursively(folder_path: String) -> void:
    var dir = DirAccess.open(folder_path)
    if not dir:
        push_error("Cannot open folder: " + folder_path)
        return

    dir.list_dir_begin()
    var file_name = dir.get_next()

    while file_name != "":
        var full_path = folder_path + "/" + file_name

        if dir.current_is_dir():
            # 递归处理子文件夹
            optimize_textures_recursively(full_path)
        elif file_name.ends_with(".png") or file_name.ends_with(".jpg"):
            # 优化纹理文件
            optimize_texture(full_path)

        file_name = dir.get_next()

func optimize_texture(file_path: String) -> void:
    var texture = load(file_path)
    if not texture:
        return

    var image = texture.get_image()
    if not image:
        return

    # 检测是否可以压缩
    if image.get_format() != Image.FORMAT_DXT1 or image.get_format() != Image.FORMAT_DXT5:
        # 转换为压缩格式
        var compressed_format = _select_optimal_format(image)
        image.compress(compressed_format, Image.COMPRESS_S3TC)

        # 保存优化后的纹理
        var optimized_texture = ImageTexture.new()
        optimized_texture.set_image(image)

        var save_path = file_path.get_basename() + "_optimized" + file_path.get_extension()
        ResourceSaver.save(optimized_texture, save_path)

func _select_optimal_format(image: Image) -> Image.Format:
    # 根据图像特征选择最佳压缩格式
    if image.detect_alpha():
        return Image.FORMAT_DXT5  # 带透明度
    else:
        return Image.FORMAT_DXT1  # 不带透明度
```

## 渲染优化系统

### 批处理优化器
```gdscript
# 渲染批处理优化器
class_name RenderingBatchOptimizer extends Node
@export var batch_size: int = 100
@export var max_distance: float = 1000.0

var batch_groups: Dictionary = {}

func _ready() -> void:
    # 注册到性能监控
    var performance_monitor = PerformanceMonitor.new()
    add_child(performance_monitor)

func optimize_rendering() -> void:
    # 收集所有可批处理的对象
    var renderable_objects = _get_renderable_objects()

    # 按材质和纹理分组
    var groups = _group_by_material(renderable_objects)

    # 为每个组创建批处理
    for group_key in groups.keys():
        _create_render_batch(groups[group_key])

func _get_renderable_objects() -> Array[Node]:
    var objects: Array[Node] = []
    var tree = get_tree()

    # 遍历场景树收集可渲染对象
    _collect_renderable_objects_recursive(tree.current_scene, objects)

    return objects

func _collect_renderable_objects_recursive(node: Node, objects: Array[Node]) -> void:
    # 检查节点是否可批处理
    if _can_be_batched(node):
        objects.append(node)

    # 递归处理子节点
    for child in node.get_children():
        _collect_renderable_objects_recursive(child, objects)

func _can_be_batched(node: Node) -> bool:
    # 检查节点是否适合批处理
    if not node is Sprite2D and not node is MeshInstance3D:
        return false

    # 检查是否使用相同的材质
    # 检查是否在合理的距离范围内
    # 检查其他批处理条件

    return true
```

### LOD系统管理器
```gdscript
# LOD（细节层次）系统管理器
class_name LODManager extends Node
@export var camera_path: NodePath
@export var lod_distances: Array[float] = [10.0, 25.0, 50.0, 100.0]

var camera: Camera3D
var lod_objects: Array[LODObject] = []

func _ready() -> void:
    # ✅ 正确：添加节点存在性和类型检查
    if camera_path and has_node(camera_path):
        var node = get_node(camera_path)
        if node is Camera3D:
            camera = node
        else:
            push_warning("指定路径的节点不是 Camera3D 类型: " + camera_path)
    elif camera_path:
        push_warning("找不到指定的相机节点: " + camera_path)
    else:
        # 如果没有指定路径，尝试自动查找主相机
        camera = get_viewport().get_camera_3d()
        if not camera:
            push_warning("场景中未找到相机，LOD 系统将无法工作")

func register_lod_object(obj: Node, lod_levels: Array[Mesh]) -> void:
    var lod_obj = LODObject.new()
    lod_obj.object = obj
    lod_obj.lod_levels = lod_levels
    lod_objects.append(lod_obj)

func _process(_delta: float) -> void:
    if not camera:
        return

    var camera_pos = camera.global_position

    # 更新所有LOD对象
    for lod_obj in lod_objects:
        var distance = camera_pos.distance_to(lod_obj.object.global_position)
        var lod_level = _calculate_lod_level(distance)
        _apply_lod_level(lod_obj, lod_level)

func _calculate_lod_level(distance: float) -> int:
    for i in range(lod_distances.size()):
        if distance < lod_distances[i]:
            return i
    return lod_distances.size() - 1

func _apply_lod_level(lod_obj: LODObject, level: int) -> void:
    if level < lod_obj.lod_levels.size():
        var mesh_instance = lod_obj.object as MeshInstance3D
        if mesh_instance:
            mesh_instance.mesh = lod_obj.lod_levels[level]

# LOD对象数据结构
class LODObject:
    var object: Node
    var lod_levels: Array[Mesh]
    var current_level: int = 0
```

## 智能特性

### 自适应优化
- **性能检测**：实时检测设备性能表现
- **动态调整**：根据性能自动调整画质
- **预测优化**：预测性能瓶颈并提前优化
- **学习优化**：基于使用数据优化策略

### 平台智能适配
- **设备识别**：自动识别设备性能等级
- **配置优化**：针对设备特点优化配置
- **资源适配**：选择合适的资源质量
- **功能开关**：智能开关高级功能

### 用户行为分析
- **使用模式**：分析用户使用习惯
- **热点检测**：识别性能热点场景
- **体验优化**：基于用户体验优化
- **反馈收集**：收集性能反馈数据

## 示例实现

### 完整性能优化系统
```gdscript
# 智能性能优化系统
class_name SmartPerformanceOptimizer extends Node
@export var target_fps: float = 60.0
@export var enable_adaptive_quality: bool = true

var performance_monitor: PerformanceMonitor
var object_pool: SmartObjectPool
var lod_manager: LODManager
var compression_optimizer: AssetCompressionOptimizer

func _ready() -> void:
    _initialize_systems()
    start_continuous_optimization()

func _initialize_systems() -> void:
    # 初始化各个子系统
    performance_monitor = PerformanceMonitor.new()
    object_pool = SmartObjectPool.new()
    lod_manager = LODManager.new()
    compression_optimizer = AssetCompressionOptimizer.new()

    add_child(performance_monitor)
    add_child(object_pool)
    add_child(lod_manager)
    add_child(compression_optimizer)

func start_continuous_optimization() -> void:
    var optimization_timer = Timer.new()
    optimization_timer.timeout.connect(_continuous_optimization_check)
    optimization_timer.wait_time = 5.0  # 每5秒检查一次
    optimization_timer.autostart = true
    add_child(optimization_timer)

func _continuous_optimization_check() -> void:
    var metrics = performance_monitor.get_performance_summary()

    if metrics.average_fps < target_fps:
        _apply_performance_optimizations(metrics)
    elif metrics.average_fps > target_fps * 1.2:
        _can_increase_quality(metrics)

func _apply_performance_optimizations(metrics: Dictionary) -> void:
    # FPS不足时应用优化
    if metrics.average_fps < target_fps * 0.8:
        _reduce_rendering_quality()

    if metrics.memory_usage_mb > 300.0:
        _optimize_memory_usage()

    if metrics.draw_calls > 100:
        _optimize_rendering_pipeline()

func _reduce_rendering_quality() -> void:
    # 降低渲染质量
    RenderingServer.camera_set_use_vertical_aspect(true)
    get_viewport().msaa_3d = Viewport.MSAA_DISABLED
    get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED

func _optimize_memory_usage() -> void:
    # 优化内存使用
    object_pool._cleanup_unused_objects()
    compression_optimizer.optimize_textures_recursively("res://assets/")
```

## 质量保证

### 性能验证
- **基准测试**：标准化的性能基准测试
- **压力测试**：高负载下的稳定性测试
- **长时间测试**：长时间运行的稳定性验证
- **多设备测试**：不同设备上的性能验证

### 优化效果评估
- **量化指标**：具体的性能提升数据
- **用户体验**：主观体验改善评估
- **稳定性分析**：优化后的稳定性分析
- **兼容性验证**：确保优化不影响兼容性

### 回归测试
- **功能完整性**：确保功能不受影响
- **视觉质量**：验证视觉质量保持
- **音频同步**：确保音画同步正常
- **交互响应**：验证交互响应及时

## 使用限制和注意事项

### 技术限制
- **硬件限制**：低端硬件的优化空间有限
- **功能权衡**：某些优化可能影响功能
- **平台差异**：不同平台的优化策略不同

### 最佳实践
- **渐进优化**：逐步优化，避免激进改动
- **测试验证**：每次优化后进行充分测试
- **用户反馈**：重视用户的使用反馈

## 故障排除

### 常见问题
1. **优化后性能下降**：检查优化策略是否正确
2. **视觉质量下降**：平衡性能和画质
3. **内存泄漏**：检查对象池和资源管理
4. **兼容性问题**：验证不同平台的表现

### 调试技巧
- 使用性能监控工具
- 分析性能瓶颈报告
- 检查优化配置参数
- 对比优化前后的表现

## 更新日志

### v1.0.0 (当前版本)
- 基础性能监控功能
- 分辨率适配系统
- 内存优化工具
- 渲染批处理优化

### 计划功能
- AI智能优化建议
- 云端性能数据分析
- 更多平台适配策略
- 高级性能诊断工具

---

**技能状态**: ✅ 可用
**最后更新**: 2025-11-09
**兼容性**: Godot 4.5+
**依赖**: Godot MCP 工具集 + 性能优化知识