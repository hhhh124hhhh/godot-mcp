extends Node2D

var score: int = 0
var game_over: bool = false
var bubble_timer: Timer
var bubble_scene: PackedScene
var difficulty_timer: Timer
var difficulty_level: int = 1
var spawn_interval: float = 1.0
var max_bubbles: int = 3

# 音频管理器
var audio_manager: AudioManager

# 屏幕震动系统
var screen_shake: ScreenShake

func _ready() -> void:
	# 将游戏管理器添加到组中，方便其他节点查找
	add_to_group("game_manager")

	# 初始化音频管理器
	audio_manager = AudioManager.new()
	add_child(audio_manager)

	# 初始化屏幕震动系统
	# 检查是否已经有Camera2D节点
	var camera = get_node_or_null("Camera2D")
	if camera and camera is Camera2D:
		# 如果已有相机，创建ScreenShake作为相机的子节点
		screen_shake = ScreenShake.new()
		screen_shake.name = "ScreenShake"
		screen_shake.add_to_group("screen_shake")
		# 不设置position，让它跟随父相机
		camera.add_child(screen_shake)
		screen_shake.make_current()
	else:
		# 如果没有相机，直接使用ScreenShake作为主相机
		screen_shake = ScreenShake.new()
		screen_shake.name = "ScreenShake"
		screen_shake.add_to_group("screen_shake")
		screen_shake.make_current()
		add_child(screen_shake)

	# 预加载泡泡场景
	bubble_scene = preload("res://Bubble.tscn")
	if not bubble_scene:
		push_error("GameManager: 严重错误 - 无法加载Bubble.tscn场景")
		game_over = true  # 设置游戏结束状态，防止继续
		return

	# 创建泡泡生成计时器
	bubble_timer = Timer.new()
	add_child(bubble_timer)
	bubble_timer.wait_time = spawn_interval
	bubble_timer.timeout.connect(_on_bubble_timer_timeout)
	bubble_timer.start()

	# 创建难度增加计时器
	difficulty_timer = Timer.new()
	add_child(difficulty_timer)
	difficulty_timer.wait_time = 10.0
	difficulty_timer.timeout.connect(_on_difficulty_timer_timeout)
	difficulty_timer.start()

	# 更新UI显示
	update_score_label()
	update_difficulty_label()

func _on_bubble_timer_timeout() -> void:
	# 游戏状态检查
	if game_over:
		print("GameManager: Timer timeout but game_over is true")
		return

	if not bubble_scene:
		print("GameManager: 泡泡场景未加载，停止生成")
		game_over = true
		bubble_timer.stop()
		return

	# 限制同时存在的泡泡数量
	var current_bubbles: Array[Node] = get_tree().get_nodes_in_group("bubbles")
	print("GameManager: Current bubbles count: ", current_bubbles.size(), " max_bubbles: ", max_bubbles)

	if current_bubbles.size() < max_bubbles:
		spawn_bubble()
	else:
		print("GameManager: Max bubbles reached, not spawning new bubble")

func spawn_bubble() -> void:
	# 检查游戏是否已结束
	if game_over:
		return
	
	if not bubble_scene:
		push_error("spawn_bubble: 泡泡场景未加载")
		return

	var bubble: Area2D = bubble_scene.instantiate()
	if not bubble:
		push_error("spawn_bubble: 无法实例化泡泡")
		return
	
	# 设置随机泡泡类型
	var type_id = get_random_bubble_type()
	var bubble_type: String
	
	# 将类型ID映射到字符串类型
	match type_id:
		1:
			bubble_type = "normal"  # 普通泡泡
		2:
			bubble_type = "golden"  # 金色泡泡
		3:
			bubble_type = "rainbow"  # 彩虹泡泡
		4:
			bubble_type = "large"   # 大泡泡
		_:
			bubble_type = "normal"  # 默认类型
	
	# 设置泡泡类型
	# 安全设置bubble_type属性，使用try-except模式
	if bubble:
		# 直接设置属性，Bubble.gd中已定义此属性
		bubble.bubble_type = bubble_type
		print("GameManager: 生成了一个新泡泡，类型: ", bubble_type)

	# 获取非重叠的安全位置
	var safe_position: Vector2 = get_non_overlapping_spawn_position()
	if safe_position == Vector2.INF:
		# 如果找不到合适位置，跳过这次生成
		print("spawn_bubble: 无法找到合适的生成位置")
		bubble.queue_free()
		return

	bubble.position = safe_position
	# 将泡泡添加到GameLayer而不是直接添加到根节点
	var game_layer: CanvasLayer = get_node_or_null("GameLayer")
	if game_layer and game_layer is CanvasLayer:
		game_layer.add_child(bubble)
	else:
		# 如果没有GameLayer，直接添加到当前场景
		var current_scene = get_tree().current_scene
		if current_scene:
			current_scene.add_child(bubble)
		else:
			add_child(bubble)

	# 安全连接信号
	if not bubble.popped.is_connected(_on_bubble_popped):
		var popped_result = bubble.popped.connect(_on_bubble_popped)
		if popped_result != OK:
			push_error("GameManager: 无法连接popped信号 - 错误码: " + str(popped_result))

	if not bubble.clicked.is_connected(_on_bubble_clicked):
		var clicked_result = bubble.clicked.connect(_on_bubble_clicked)
		if clicked_result != OK:
			push_error("GameManager: 无法连接clicked信号 - 错误码: " + str(clicked_result))

func get_non_overlapping_spawn_position() -> Vector2:
	var screen_size: Vector2i = get_viewport_rect().size
	var bubble_size: float = 70.0  # 泡泡大小，包含一些间距
	var margin: float = 80.0  # 边缘和UI区域的边距
	var max_attempts: int = 20  # 最大尝试次数

	# 获取当前所有泡泡的位置
	var current_bubbles: Array[Node] = get_tree().get_nodes_in_group("bubbles")
	var existing_positions: Array[Vector2] = []

	for bubble_node in current_bubbles:
		if bubble_node and bubble_node is Area2D:
			existing_positions.append(bubble_node.position)

	# 定义安全区域（避开顶部UI区域）
	var safe_rect: Rect2 = Rect2(
		margin,
		margin + 60.0,  # 避开顶部分数显示区域
		screen_size.x - margin * 2.0,
		screen_size.y - margin * 2.0 - 60.0
	)

	for attempt in range(max_attempts):
		# 在安全区域内随机生成位置
		var x_pos: float = randf_range(safe_rect.position.x + bubble_size / 2.0, safe_rect.position.x + safe_rect.size.x - bubble_size / 2.0)
		var y_pos: float = randf_range(safe_rect.position.y + bubble_size / 2.0, safe_rect.position.y + safe_rect.size.y - bubble_size / 2.0)
		var candidate_pos: Vector2 = Vector2(x_pos, y_pos)

		# 检查是否与现有泡泡重叠
		var overlaps: bool = false
		for existing_pos in existing_positions:
			var distance: float = candidate_pos.distance_to(existing_pos)
			if distance < bubble_size * 1.2:  # 1.2倍的安全距离
				overlaps = true
				break

		if not overlaps:
			return candidate_pos

	# 如果找不到合适位置，返回Vector2.INF表示失败
	print("get_non_overlapping_spawn_position: 无法找到非重叠位置")
	return Vector2.INF

func get_safe_spawn_position() -> Vector2:
	# 保留原函数作为备用
	var screen_size: Vector2i = get_viewport_rect().size
	var bubble_size: float = 60.0
	var margin: float = 80.0

	var safe_rect: Rect2 = Rect2(
		margin,
		margin + 50.0,
		screen_size.x - margin * 2.0,
		screen_size.y - margin * 2.0 - 50.0
	)

	if safe_rect.size.x < bubble_size or safe_rect.size.y < bubble_size:
		push_warning("get_safe_spawn_position: 安全区域太小，使用基本边界检测")
		return Vector2(
			randf_range(bubble_size / 2.0, float(screen_size.x) - bubble_size / 2.0),
			randf_range(bubble_size / 2.0, float(screen_size.y) - bubble_size / 2.0)
		)

	var x_pos: float = randf_range(safe_rect.position.x + bubble_size / 2.0, safe_rect.position.x + safe_rect.size.x - bubble_size / 2.0)
	var y_pos: float = randf_range(safe_rect.position.y + bubble_size / 2.0, safe_rect.position.y + safe_rect.size.y - bubble_size / 2.0)

	return Vector2(x_pos, y_pos)

func _on_bubble_popped(score_value: int, bubble_position: Vector2) -> void:
	# 游戏状态安全检查
	if game_over:
		print("GameManager: 游戏已结束，忽略泡泡破裂")
		return

	# 调试信息
	print("GameManager: Bubble popped with score: ", score_value, " at position: ", bubble_position, " Game over: ", game_over)

	# 泡泡破裂得分
	score += score_value
	update_score_label()

	# 播放增强音效和震动
	play_enhanced_click_feedback()

	# 显示得分飘出特效，在泡泡位置附近
	display_score_popup_at_position(bubble_position, score_value)

	print("GameManager: Bubble pop processed. Score: ", score)

func _on_bubble_clicked() -> void:
	# 游戏状态安全检查
	if game_over:
		print("GameManager: 游戏已结束，忽略点击")
		return

	# 改进的检查逻辑：即使bubble_scene为null，也不应立即结束游戏
	if not bubble_scene:
		print("GameManager: 泡泡场景未加载，但仍允许点击处理")
		# 尝试重新加载泡泡场景
		try_reload_bubble_scene()

	# 调试信息
	print("GameManager: Bubble clicked event received")

	# 播放增强音效和震动
	play_enhanced_click_feedback()

	print("GameManager: Bubble click processed")

# 播放增强的点击反馈
func play_enhanced_click_feedback() -> void:
	# 播放增强音效
	if audio_manager:
		audio_manager.play_click()
	# 使用定时器延迟播放分数音效
	var timer = get_tree().create_timer(0.05)
	timer.timeout.connect(func():
		if audio_manager:
			audio_manager.play_score()
	)

	# 添加屏幕震动
	if screen_shake:
		screen_shake.add_small_shake()

# 播放泡泡弹出音效
func play_bubble_pop() -> void:
	if audio_manager:
		audio_manager.play_pop()

# 尝试重新加载泡泡场景
func try_reload_bubble_scene() -> void:
	print("GameManager: 尝试重新加载泡泡场景")
	# 使用GDScript的错误处理方式
	var scene_path = "res://Bubble.tscn"
	if ResourceLoader.exists(scene_path):
		bubble_scene = load(scene_path)
		if bubble_scene:
			print("GameManager: 泡泡场景重新加载成功")
		else:
			print("GameManager: 重新加载泡泡场景失败")
	else:
		print("GameManager: 泡泡场景文件不存在")

func update_score_label() -> void:
	# 先尝试从UILayer查找，如果失败则尝试从当前场景查找
	var score_label: Label = null

	var ui_layer = get_node_or_null("UILayer")
	if ui_layer:
		score_label = ui_layer.get_node_or_null("ScoreContainer/ScoreLabel") as Label

	if not score_label and get_tree().current_scene:
		score_label = get_tree().current_scene.get_node_or_null("UILayer/ScoreContainer/ScoreLabel") as Label

	if score_label:
		score_label.text = "分数: " + str(score)
	else:
		push_warning("update_score_label: 未找到ScoreLabel节点")

func update_difficulty_label() -> void:
	# 先尝试从UILayer查找，如果失败则尝试从当前场景查找
	var difficulty_label: Label = null

	var ui_layer = get_node_or_null("UILayer")
	if ui_layer:
		difficulty_label = ui_layer.get_node_or_null("ScoreContainer/DifficultyLabel") as Label

	if not difficulty_label and get_tree().current_scene:
		difficulty_label = get_tree().current_scene.get_node_or_null("UILayer/ScoreContainer/DifficultyLabel") as Label

	if difficulty_label:
		difficulty_label.text = "难度: " + str(difficulty_level)
	else:
		push_warning("update_difficulty_label: 未找到DifficultyLabel节点")

func _on_difficulty_timer_timeout() -> void:
	if game_over:
		return

	# 增加难度
	difficulty_level += 1
	spawn_interval = max(0.2, spawn_interval - 0.1)
	max_bubbles = min(10, max_bubbles + 1)

	# 更新计时器
	bubble_timer.wait_time = spawn_interval

	# 重置难度计时器
	difficulty_timer.start()

	# 更新难度显示
	update_difficulty_label()

func end_game():
	game_over = true
	bubble_timer.stop()
	difficulty_timer.stop()

	# 创建游戏结束UI容器
	var game_over_container = VBoxContainer.new()
	var ui_layer: CanvasLayer = get_node_or_null("UILayer")
	if ui_layer:
		ui_layer.add_child(game_over_container)
	else:
		add_child(game_over_container)

	game_over_container.position = Vector2(get_viewport_rect().size.x / 2 - 100, get_viewport_rect().size.y / 2 - 50)

	# 显示游戏结束信息
	var game_over_label = Label.new()
	game_over_container.add_child(game_over_label)
	game_over_label.text = "游戏结束！最终得分: " + str(score)
	game_over_label.add_theme_font_size_override("font_size", 32)
	game_over_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	# 添加重新开始按钮
	var restart_button = Button.new()
	game_over_container.add_child(restart_button)
	restart_button.text = "重新开始"
	restart_button.custom_minimum_size = Vector2(200, 60)
	restart_button.add_theme_font_size_override("font_size", 20)
	restart_button.pressed.connect(restart_game)

func restart_game():
	# 重置游戏状态
	score = 0
	game_over = false
	difficulty_level = 1
	spawn_interval = 1.0
	max_bubbles = 3

	# 清除游戏结束UI
	var ui_layer: CanvasLayer = get_node_or_null("UILayer")
	if ui_layer:
		for child in ui_layer.get_children():
			if child is VBoxContainer:
				child.queue_free()
				break

	# 清除所有剩余的泡泡
	for bubble in get_tree().get_nodes_in_group("bubbles"):
		bubble.queue_free()

	# 重新启动计时器
	bubble_timer.wait_time = spawn_interval
	bubble_timer.start()
	difficulty_timer.start()

	# 更新分数和难度显示
	update_score_label()
	update_difficulty_label()

func remove_bubble(bubble: Node2D) -> void:
	# 安全检查
	if not bubble or not bubble.is_inside_tree():
		return

	# 安全断开连接信号
	if bubble.has_signal("popped") and bubble.popped.is_connected(_on_bubble_popped):
		bubble.popped.disconnect(_on_bubble_popped)

	if bubble.has_signal("clicked") and bubble.clicked.is_connected(_on_bubble_clicked):
		bubble.clicked.disconnect(_on_bubble_clicked)

	# 从场景中移除泡泡
	bubble.queue_free()

func get_random_bubble_type() -> int:
	# 基于概率返回随机的泡泡类型
	var rand_val = randf() * 100
	
	if rand_val < 5:
		return 2  # 金色泡泡 (5%)
	elif rand_val < 10:
		return 3  # 彩虹泡泡 (5%)
	elif rand_val < 15:
		return 4  # 大泡泡 (5%)
	else:
		return 1  # 普通泡泡 (85%)

func play_special_sound(sound_name: String) -> void:
	if audio_manager:
		audio_manager.play_special_sound(sound_name)

# 在指定位置显示得分飘出动画
func display_score_popup_at_position(position: Vector2, score_value: int) -> void:
	# 使用专业的ScorePopup系统
	ScorePopup.create_score_popup(position, score_value, get_node("UILayer"))

# 显示得分弹出动画（保留原函数作为备用）
func display_score_popup() -> void:
	# 创建分数弹出标签
	var score_label = Label.new()
	score_label.text = "+1"
	score_label.add_theme_color_override("font_color", Color(1, 1, 0))  # 黄色文字
	score_label.add_theme_font_size_override("font_size", 24)
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# 设置位置在屏幕中心或得分标签附近
	var ui_layer = get_node_or_null("UILayer")
	var score_container = null
	var target_position = Vector2()

	if ui_layer:
		score_container = ui_layer.get_node_or_null("ScoreContainer")

	if score_container:
		target_position = score_container.global_position + Vector2(100, 0)
	else:
		target_position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)

	score_label.global_position = target_position

	# 添加到场景
	if ui_layer:
		ui_layer.add_child(score_label)
	else:
		add_child(score_label)

	# 创建动画序列
	var tween = create_tween()
	# 放大效果
	tween.tween_property(score_label, "scale", Vector2(1.5, 1.5), 0.1)
	# 缩小回原始大小
	tween.tween_property(score_label, "scale", Vector2.ONE, 0.2)
	# 向上移动
	tween.tween_property(score_label, "position", score_label.position - Vector2(0, 30), 0.5)
	# 淡出效果
	tween.tween_property(score_label, "modulate:a", 0.0, 0.3)
	# 动画结束后移除节点
	tween.tween_callback(func():
		score_label.queue_free()
	)

	print("GameManager: 显示得分+1特效")

func create_rainbow_burst(position: Vector2) -> void:
	# 创建彩虹爆炸效果
	# 这个函数可以在未来实现更多特效
	pass

func create_big_bubble_explosion(position: Vector2) -> void:
	# 创建大泡泡爆炸效果
	# 这个函数可以在未来实现更多特效
	pass

func show_level_up_message() -> void:
	# 创建升级消息标签
	var level_up_label = Label.new()
	level_up_label.text = "升级! 等级: " + str(difficulty_level)
	level_up_label.position = Vector2(get_viewport_rect().size.x / 2 - 50, get_viewport_rect().size.y / 2 - 15)
	level_up_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	level_up_label.add_theme_color_override("font_color", Color(1, 0.8, 0))
	
	# 添加到场景
	add_child(level_up_label)
	
	# 使用Tween来实现动画效果
	var tween = Tween.new()
	add_child(tween)
	
	# 动画序列
	tween.interpolate_property(level_up_label, "custom_minimum_size", Vector2(100, 30), Vector2(150, 45), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.interpolate_property(level_up_label, "position", level_up_label.position, level_up_label.position - Vector2(25, -30), 1.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(level_up_label, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.5)
	
	# 开始动画并设置清理
	tween.start()
	tween.finished.connect(func():
		level_up_label.queue_free()
		tween.queue_free()
	)
