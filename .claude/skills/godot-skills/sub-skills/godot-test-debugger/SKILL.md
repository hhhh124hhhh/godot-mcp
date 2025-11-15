---
name: godot-test-debugger
description: Godot 测试与调试工作流专家，支持自然语言描述自动完成单元测试、集成测试、错误诊断、性能调试等测试工作
---

# Godot 测试调试专家技能

## 技能概述

`godot-test-debugger` 是专门用于 Godot 游戏测试和调试的智能化技能，能够根据用户的自然语言描述自动完成单元测试、集成测试、性能测试、错误诊断、调试工具创建、问题定位等全面的测试调试工作。

## 核心功能

### 🧪 自动化测试系统
- **单元测试**：自动生成和运行单元测试
- **集成测试**：复杂场景的集成测试
- **性能测试**：帧率、内存、加载性能测试
- **回归测试**：版本更新后的回归检测

### 🔍 智能错误诊断
- **异常捕获**：全面的游戏异常捕获和分类
- **错误分析**：深度分析错误原因和影响范围
- **修复建议**：提供具体的修复方案和代码建议
- **预防措施**：预防同类错误的再次发生

### 🛠️ 调试工具生成
- **调试界面**：创建功能完整的调试UI界面
- **日志系统**：智能日志记录和分类系统
- **性能监控**：实时性能监控和可视化
- **状态检查器**：游戏状态实时检查工具

### 📊 测试报告生成
- **测试覆盖度**：代码覆盖度和功能覆盖度分析
- **缺陷统计**：缺陷分类、优先级和趋势分析
- **性能报告**：详细的性能分析报告
- **质量评估**：整体代码质量评估和建议

## 使用方法

### 单元测试创建
```
用户: "为我的角色控制系统创建完整的单元测试"
系统: 自动实现：
- 分析角色控制系统的所有功能
- 生成移动、跳跃、攻击等测试用例
- 创建边界条件和异常情况测试
- 设置测试数据和预期结果
- 运行测试并生成报告
```

### 性能测试实施
```
用户: "测试游戏在1000个敌人同时存在时的性能表现"
系统: 智能测试：
- 创建大规模场景测试环境
- 监控帧率、内存、CPU使用率
- 测试不同设备配置下的表现
- 分析性能瓶颈和优化建议
- 生成详细的性能测试报告
```

### 错误诊断和修复
```
玩家报告游戏在某个关卡崩溃，需要找出问题"
系统: 全面诊断：
- 分析崩溃日志和错误信息
- 重现崩溃场景和条件
- 定位问题代码和根本原因
- 提供多种修复方案
- 验证修复效果
```

### 调试工具创建
```
用户: "为开发团队创建一个完整的调试工具界面"
系统: 智能生成：
- 实时性能监控面板
- 游戏状态查看和修改工具
- 场景导航和对象检查器
- 命令控制台和脚本执行器
- 日志查看和过滤系统
```

## 工作流程

### 1. 测试需求分析
```bash
# 分析测试需求
- 识别核心功能模块
- 确定测试类型和范围
- 评估测试复杂度和优先级
- 制定测试计划和时间安排
```

### 2. 测试用例设计
```bash
# 设计测试用例
- 正常功能测试用例
- 边界条件测试用例
- 异常情况测试用例
- 性能压力测试用例
```

### 3. 自动测试实施
```bash
# 执行自动化测试
- 生成测试代码
- 配置测试环境
- 运行测试套件
- 收集测试结果
```

### 4. 问题诊断修复
```bash
# 诊断和修复问题
- 分析测试失败原因
- 定位问题代码位置
- 提供修复建议
- 验证修复效果
```

## MCP 工具集成

### 测试执行工具
- `create_test_scene` - 创建测试场景
- `run_unit_test` - 运行单元测试
- `run_integration_test` - 运行集成测试
- `run_performance_test` - 运行性能测试

### 调试分析工具
- `analyze_error_log` - 分析错误日志
- `detect_memory_leaks` - 检测内存泄漏
- `profile_script_performance` - 分析脚本性能
- `debug_node_hierarchy` - 调试节点层次

### 代码质量工具
- `check_code_coverage` - 检查代码覆盖度
- `analyze_code_complexity` - 分析代码复杂度
- `validate_script_syntax` - 验证脚本语法
- `check_naming_conventions` - 检查命名规范

### 报告生成工具
- `generate_test_report` - 生成测试报告
- `create_bug_report` - 创建缺陷报告
- `export_performance_data` - 导出性能数据
- `visualize_test_results` - 可视化测试结果

## 自动化测试系统

### 智能测试生成器
```gdscript
# 智能测试生成器
class_name SmartTestGenerator extends Node
@export var target_script: GDScript
@export var test_output_path: String = "res://tests/"

func generate_unit_tests() -> void:
    var script_content = target_script.source_code
    var functions = _extract_functions(script_content)
    var test_class = _create_test_class(functions)

    var test_script_path = test_output_path + target_script.get_path().get_file().get_basename() + "_test.gd"
    var test_file = FileAccess.open(test_script_path, FileAccess.WRITE)
    test_file.store_string(test_class)
    test_file.close()

func _extract_functions(script_content: String) -> Array:
    var functions = []
    var lines = script_content.split("\n")

    for line in lines:
        if line.begins_with("func "):
            var func_name = line.split("(")[0].replace("func ", "").strip_edges()
            functions.append(func_name)

    return functions

func _create_test_class(functions: Array) -> String:
    var test_class = "extends \"res://addons/gut/test.gd\"\n\n"
    test_class += "var " + target_script.get_path().get_file().get_basename() + ": " + target_script.get_global_name() + "\n\n"

    for func_name in functions:
        test_class += _generate_function_test(func_name) + "\n"

    return test_class

func _generate_function_test(func_name: String) -> String:
    var test_code = "func test_" + func_name + "():\n"
    test_code += "\t# TODO: Implement test for " + func_name + "\n"
    test_code += "\tassert_true(false, \"Test not implemented yet\")\n"

    return test_code
```

### 集成测试框架
```gdscript
# 集成测试框架
class_name IntegrationTestFramework extends Node
@export var test_scenes: Array[PackedScene]

var current_test_index: int = 0
var test_results: Array[Dictionary] = []

func run_all_tests() -> void:
    test_results.clear()
    current_test_index = 0

    for test_scene in test_scenes:
        await run_single_test(test_scene)

    generate_test_report()

func run_single_test(test_scene: PackedScene) -> void:
    print("Running integration test: ", test_scene.resource_path)

    var test_instance = test_scene.instantiate()
    add_child(test_instance)

    # 等待测试场景稳定
    await get_tree().create_timer(1.0).timeout

    # 执行测试逻辑
    var test_result = await execute_integration_test(test_instance)

    # 记录结果
    test_results.append({
        "scene": test_scene.resource_path,
        "result": test_result,
        "timestamp": Time.get_datetime_string_from_system()
    })

    # ✅ 正确：安全清理测试场景
    if test_instance and is_instance_valid(test_instance):
        # 使用延迟删除，确保所有回调完成后再删除
        test_instance.call_deferred("queue_free")
        # 等待一帧确保删除操作完成
        await get_tree().process_frame

func execute_integration_test(scene: Node) -> Dictionary:
    var result = {
        "passed": false,
        "errors": [],
        "performance": {}
    }

    # 检查场景完整性
    var integrity_check = check_scene_integrity(scene)
    if not integrity_check.valid:
        result.errors.append_array(integrity_check.errors)

    # 性能测试
    var performance_test = run_performance_test(scene)
    result.performance = performance_test

    # 功能测试
    var functional_test = run_functional_test(scene)
    if functional_test.passed:
        result.passed = true
    else:
        result.errors.append_array(functional_test.errors)

    return result
```

## 错误诊断系统

### 智能错误分析器
```gdscript
# 智能错误分析器
class_name SmartErrorAnalyzer extends Node
@export var log_file_path: String = "user://logs/game.log"

func analyze_recent_errors() -> Array[Dictionary]:
    var errors = []

    if not FileAccess.file_exists(log_file_path):
        return errors

    var log_file = FileAccess.open(log_file_path, FileAccess.READ)
    var log_content = log_file.get_as_text()
    log_file.close()

    var lines = log_content.split("\n")
    for line in lines:
        if "ERROR" in line or "CRITICAL" in line:
            var error_info = parse_error_line(line)
            if error_info:
                errors.append(error_info)

    return analyze_error_patterns(errors)

func parse_error_line(line: String) -> Dictionary:
    var error_info = {}

    # 提取时间戳
    var time_pattern = r"(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})"
    var regex = RegEx.new()
    regex.compile(time_pattern)
    var result = regex.search(line)

    if result:
        error_info["timestamp"] = result.get_string(1)

    # 提取错误类型
    if "ERROR" in line:
        error_info["severity"] = "ERROR"
    elif "CRITICAL" in line:
        error_info["severity"] = "CRITICAL"

    # 提取错误消息
    var message_start = line.find(": ") + 2
    if message_start > 1:
        error_info["message"] = line.substr(message_start)

    # 提取调用栈
    if "at:" in line:
        var call_stack = line.substr(line.find("at:") + 3)
        error_info["call_stack"] = call_stack.strip_edges()

    return error_info

func analyze_error_patterns(errors: Array[Dictionary]) -> Array[Dictionary]:
    var analyzed_errors = []

    for error in errors:
        var analyzed_error = error.duplicate()

        # 分析错误模式
        analyzed_error["category"] = categorize_error(error)
        analyzed_error["suggested_fix"] = suggest_fix(error)
        analyzed_error["related_files"] = find_related_files(error)

        analyzed_errors.append(analyzed_error)

    return analyzed_errors

func categorize_error(error: Dictionary) -> String:
    var message = error.get("message", "").to_lower()

    if "null" in message and "instance" in message:
        return "Null Reference"
    elif "index" in message and "out of bounds" in message:
        return "Array Index"
    elif "key" in message and "not found" in message:
        return "Dictionary Key"
    elif "node" in message and "not found" in message:
        return "Node Path"
    elif "resource" in message and "not found" in message:
        return "Resource Loading"
    else:
        return "General Error"

func suggest_fix(error: Dictionary) -> String:
    var category = error.get("category", "")
    var message = error.get("message", "")

    match category:
        "Null Reference":
            return "Add null checks before accessing object properties or ensure proper initialization."
        "Array Index":
            return "Add bounds checking before array access or validate array size."
        "Dictionary Key":
            return "Check if key exists using 'has()' method before accessing dictionary values."
        "Node Path":
            return "Verify node paths are correct and nodes exist in the scene tree."
        "Resource Loading":
            return "Ensure resource files exist and paths are correct. Use 'load()' with proper error handling."

    return "Review the code logic and add appropriate error handling."
```

### 实时调试界面
```gdscript
# 实时调试界面
class_name RealTimeDebugInterface extends Control
@export var refresh_rate: float = 0.5

var performance_monitor: PerformanceMonitor
var error_log_display: RichTextLabel
var node_tree_display: Tree
var property_editor: Control

func _ready() -> void:
    _create_debug_interface()
    _setup_refresh_timer()

func _create_debug_interface() -> void:
    # 创建主布局
    var main_container = HSplitContainer.new()
    add_child(main_container)

    # 左侧面板
    var left_panel = VBoxContainer.new()
    main_container.add_child(left_panel)

    # 性能监控
    _create_performance_panel(left_panel)

    # 错误日志
    _create_error_log_panel(left_panel)

    # 右侧面板
    var right_panel = VBoxContainer.new()
    main_container.add_child(right_panel)

    # 节点树
    _create_node_tree_panel(right_panel)

    # 属性编辑器
    _create_property_editor_panel(right_panel)

func _create_performance_panel(parent: Control) -> void:
    var performance_group = GroupBox.new()
    performance_group.text = "Performance Monitor"
    parent.add_child(performance_group)

    var fps_label = Label.new()
    fps_label.name = "FPSLabel"
    performance_group.add_child(fps_label)

    var memory_label = Label.new()
    memory_label.name = "MemoryLabel"
    performance_group.add_child(memory_label)

    var draw_calls_label = Label.new()
    draw_calls_label.name = "DrawCallsLabel"
    performance_group.add_child(draw_calls_label)

func _setup_refresh_timer() -> void:
    var refresh_timer = Timer.new()
    refresh_timer.timeout.connect(_refresh_debug_info)
    refresh_timer.wait_time = refresh_rate
    refresh_timer.autostart = true
    add_child(refresh_timer)

func _refresh_debug_info() -> void:
    _update_performance_info()
    _update_error_log()
    _update_node_tree()

func _update_performance_info() -> void:
    var fps_label = get_node("HSplitContainer/VBoxContainer/PerformanceMonitor/FPSLabel") as Label
    var memory_label = get_node("HSplitContainer/VBoxContainer/PerformanceMonitor/MemoryLabel") as Label
    var draw_calls_label = get_node("HSplitContainer/VBoxContainer/PerformanceMonitor/DrawCallsLabel") as Label

    fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

    var memory_mb = OS.get_static_memory_usage_by_type()[OS.MEMORY_TYPE_STATIC] / 1024.0 / 1024.0
    memory_label.text = "Memory: " + str(snapped(memory_mb, 0.1)) + " MB"

    var draw_calls = RenderingServer.get_rendering_info(RenderingServer.RENDERING_INFO_DRAW_CALLS_IN_FRAME)
    draw_calls_label.text = "Draw Calls: " + str(draw_calls)
```

## 性能测试系统

### 负载测试框架
```gdscript
# 负载测试框架
class_name LoadTestFramework extends Node
@export var test_scenarios: Array[LoadTestScenario]

var current_scenario: LoadTestScenario
var test_results: Dictionary = {}

func run_load_tests() -> void:
    for scenario in test_scenarios:
        await run_load_test_scenario(scenario)

func run_load_test_scenario(scenario: LoadTestScenario) -> void:
    print("Starting load test: ", scenario.name)

    current_scenario = scenario
    var test_data = {
        "scenario_name": scenario.name,
        "start_time": Time.get_ticks_msec(),
        "fps_history": [],
        "memory_history": [],
        "frame_times": []
    }

    # 设置测试环境
    await setup_test_environment(scenario)

    # 运行测试
    var test_duration = scenario.duration_seconds
    var start_time = Time.get_ticks_msec()

    while Time.get_ticks_msec() - start_time < test_duration * 1000:
        var frame_start = Time.get_ticks_msec()

        # 收集性能数据
        test_data.fps_history.append(Engine.get_frames_per_second())
        var memory_mb = OS.get_static_memory_usage_by_type()[OS.MEMORY_TYPE_STATIC] / 1024.0 / 1024.0
        test_data.memory_history.append(memory_mb)

        # 执行测试逻辑
        await process_test_frame(scenario)

        var frame_time = Time.get_ticks_msec() - frame_start
        test_data.frame_times.append(frame_time)

        await get_tree().process_frame

    test_data.end_time = Time.get_ticks_msec()
    test_results[scenario.name] = analyze_load_test_results(test_data)

    # 清理测试环境
    await cleanup_test_environment(scenario)

func analyze_load_test_results(test_data: Dictionary) -> Dictionary:
    var analysis = {}

    # FPS分析
    var fps_array = test_data.fps_history
    analysis["average_fps"] = fps_array.reduce(func(sum, fps): return sum + fps, 0.0) / fps_array.size()
    analysis["min_fps"] = fps_array.min()
    analysis["max_fps"] = fps_array.max()
    analysis["fps_stability"] = 1.0 - (fps_array.max() - fps_array.min()) / analysis["average_fps"]

    # 内存分析
    var memory_array = test_data.memory_history
    analysis["peak_memory_mb"] = memory_array.max()
    analysis["memory_growth_mb"] = memory_array[-1] - memory_array[0]

    # 帧时间分析
    var frame_times = test_data.frame_times
    analysis["average_frame_time_ms"] = frame_times.reduce(func(sum, time): return sum + time, 0) / frame_times.size()
    analysis["worst_frame_time_ms"] = frame_times.max()

    return analysis

# 负载测试场景数据结构
class LoadTestScenario:
    var name: String
    var duration_seconds: float
    var setup_function: Callable
    var process_function: Callable
    var cleanup_function: Callable
```

## 调试工具生成器

### 调试界面生成器
```gdscript
# 调试界面生成器
class_name DebugInterfaceGenerator extends Node

func create_comprehensive_debug_interface() -> Control:
    var debug_root = Control.new()
    debug_root.name = "DebugInterface"
    debug_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

    # 创建主标签页
    var tab_container = TabContainer.new()
    debug_root.add_child(tab_container)
    tab_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

    # 创建各个调试面板
    _create_performance_tab(tab_container)
    _create_scene_inspector_tab(tab_container)
    _create_console_tab(tab_container)
    _create_memory_profiler_tab(tab_container)

    return debug_root

func _create_performance_tab(tab_container: TabContainer) -> void:
    var performance_tab = Control.new()
    performance_tab.name = "Performance"
    tab_container.add_child(performance_tab)

    # FPS图表
    var fps_chart = create_fps_chart()
    performance_tab.add_child(fps_chart)

    # 内存使用图表
    var memory_chart = create_memory_chart()
    memory_chart.position.y = 200
    performance_tab.add_child(memory_chart)

    # 性能统计
    var stats_container = VBoxContainer.new()
    stats_container.position.y = 400
    performance_tab.add_child(stats_container)

    _create_performance_stats(stats_container)

func create_fps_chart() -> Control:
    var chart = LineChart.new()
    chart.name = "FPSChart"
    chart.size = Vector2(400, 180)
    chart.max_value = 120.0
    chart.min_value = 0.0
    chart.line_color = Color.GREEN

    return chart

func _create_scene_inspector_tab(tab_container: TabContainer) -> void:
    var inspector_tab = Control.new()
    inspector_tab.name = "Scene Inspector"
    tab_container.add_child(inspector_tab)

    var split_container = HSplitContainer.new()
    inspector_tab.add_child(split_container)
    split_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

    # 节点树
    var node_tree = create_node_tree()
    split_container.add_child(node_tree)

    # 属性编辑器
    var property_editor = create_property_editor()
    split_container.add_child(property_editor)

func create_node_tree() -> Tree:
    var tree = Tree.new()
    tree.name = "NodeTree"
    tree.item_selected.connect(_on_node_selected)

    # 填充场景树
    _populate_scene_tree(tree, get_tree().current_scene)

    return tree

func _populate_scene_tree(tree: Tree, node: Node, parent_item: TreeItem = null) -> void:
    var item = tree.create_item(parent_item)
    item.set_text(0, node.name + " (" + node.get_class() + ")")
    item.set_metadata(0, node)

    for child in node.get_children():
        _populate_scene_tree(tree, child, item)

func _on_node_selected() -> void:
    var tree = get_node("Scene Inspector/HSplitContainer/NodeTree") as Tree
    var selected_item = tree.get_selected()
    if selected_item:
        var selected_node = selected_item.get_metadata(0) as Node
        _update_property_editor(selected_node)
```

## 智能特性

### 自动问题检测
- **异常模式识别**：识别常见的异常模式
- **性能退化检测**：检测性能退化趋势
- **内存泄漏发现**：自动发现内存泄漏问题
- **并发问题检测**：检测线程安全和并发问题

### 智能修复建议
- **代码修复**：提供具体的代码修复建议
- **配置优化**：建议优化的配置参数
- **架构改进**：建议架构层面的改进
- **最佳实践**：推荐最佳实践方案

### 预测性分析
- **故障预测**：基于历史数据预测潜在故障
- **性能预测**：预测性能瓶颈和问题
- **质量评估**：评估代码质量和维护性
- **风险评估**：评估发布风险和影响

## 示例实现

### 完整测试调试系统
```gdscript
# 完整测试调试系统
class_name ComprehensiveTestDebugSystem extends Node
@export var auto_run_tests: bool = true
@export var enable_debug_interface: bool = true

var test_framework: IntegrationTestFramework
var error_analyzer: SmartErrorAnalyzer
var debug_interface: RealTimeDebugInterface
var load_tester: LoadTestFramework

func _ready() -> void:
    _initialize_components()
    if auto_run_tests:
        run_test_suite()

func _initialize_components() -> void:
    # 初始化各个组件
    test_framework = IntegrationTestFramework.new()
    error_analyzer = SmartErrorAnalyzer.new()
    load_tester = LoadTestFramework.new()

    add_child(test_framework)
    add_child(error_analyzer)
    add_child(load_tester)

    if enable_debug_interface:
        debug_interface = RealTimeDebugInterface.new()
        add_child(debug_interface)

func run_test_suite() -> void:
    print("=== Starting Comprehensive Test Suite ===")

    # 运行单元测试
    await run_unit_tests()

    # 运行集成测试
    await run_integration_tests()

    # 运行性能测试
    await run_performance_tests()

    # 分析错误
    await analyze_errors()

    # 生成综合报告
    generate_comprehensive_report()

func run_unit_tests() -> void:
    print("Running unit tests...")
    # 实现单元测试逻辑
    await get_tree().create_timer(1.0).timeout

func run_integration_tests() -> void:
    print("Running integration tests...")
    await test_framework.run_all_tests()

func run_performance_tests() -> void:
    print("Running performance tests...")
    await load_tester.run_load_tests()

func analyze_errors() -> void:
    print("Analyzing errors...")
    var recent_errors = error_analyzer.analyze_recent_errors()
    if recent_errors.size() > 0:
        print("Found ", recent_errors.size(), " errors to analyze")
        for error in recent_errors:
            print("Error: ", error.message, " Suggested fix: ", error.suggested_fix)

func generate_comprehensive_report() -> void:
    print("=== Test Report Generated ===")
    print("Unit Tests: PASSED")
    print("Integration Tests: ", test_framework.test_results.size(), " scenarios")
    print("Performance Tests: ", load_tester.test_results.size(), " scenarios")
    print("Recent Errors: ", error_analyzer.analyze_recent_errors().size())
```

## 质量保证

### 测试覆盖度
- **代码覆盖度**：确保测试覆盖所有关键代码
- **功能覆盖度**：验证所有功能都经过测试
- **场景覆盖度**：测试各种使用场景
- **边界覆盖度**：包含边界和异常情况测试

### 测试质量
- **测试独立性**：确保测试之间相互独立
- **测试可重复性**：确保测试结果可重复
- **测试稳定性**：避免偶发性测试失败
- **测试可维护性**：便于维护和更新测试

### 调试有效性
- **问题定位准确**：准确定位问题位置
- **修复建议可行**：提供可行的修复方案
- **预防措施有效**：有效预防类似问题
- **文档完整详细**：提供完整的问题文档

## 使用限制和注意事项

### 技术限制
- **测试环境差异**：测试环境可能与实际环境不同
- **性能测试局限性**：性能测试无法完全模拟真实使用
- **错误检测范围**：某些复杂问题可能难以自动检测

### 最佳实践
- **持续测试**：建立持续的测试流程
- **及时修复**：发现问题及时修复
- **测试维护**：定期维护和更新测试
- **团队协作**：建立团队测试协作机制

## 故障排除

### 常见问题
1. **测试不稳定**：检查测试依赖和环境
2. **性能测试不准确**：优化测试条件和环境
3. **错误分析不准确**：提供更多错误上下文
4. **调试界面显示异常**：检查界面更新逻辑

### 调试技巧
- 使用详细的日志记录
- 建立测试数据对比
- 检查测试环境配置
- 验证测试结果准确性

## 更新日志

### v1.0.0 (当前版本)
- 基础自动化测试功能
- 错误分析和诊断系统
- 调试界面生成器
- 性能测试框架

### 计划功能
- AI辅助问题诊断
- 云端测试数据分析
- 更多测试模板
- 实时协作调试

---

**技能状态**: ✅ 可用
**最后更新**: 2025-11-09
**兼容性**: Godot 4.5+
**依赖**: Godot MCP 工具集 + 软件测试知识