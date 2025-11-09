class_name Bubble
extends Area2D

# 泡泡的属性
var size = 30
var speed = Vector2(0, -100)  # 向上移动的速度
var color = Color(0.8, 0.8, 1.0, 1.0)

# 信号
signal popped(score)
signal reached_top

func _ready():
	# 设置碰撞区域
	$CollisionShape2D.shape.radius = size

	# 设置随机颜色
	color = Color(randf_range(0.5, 1.0), randf_range(0.5, 1.0), 1.0, 1.0)

	# 添加鼠标点击检测 - Godot 4.x 新的信号连接语法
	connect("input_event", _on_input_event)

	# 添加物理处理
	pass

func _physics_process(delta):
	# 移动泡泡
	position += speed * delta

	# 如果泡泡到达屏幕顶部，发出信号并移除
	if position.y < -size * 2:
		reached_top.emit()
		queue_free()

func _on_input_event(viewport, event, shape_idx):
	# 检测鼠标点击 - Godot 4.x 鼠标按钮常量保持不变
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		pop()

func pop():
	# 发出泡泡被戳破的信号 - 修复：opopped改为popped
	popped.emit(10)  # 每个泡泡得10分

	# 创建简单的粒子效果（视觉反馈）- Godot 4.x 兼容版本
	for i in range(8):
		var particle = Node2D.new()
		add_child(particle)
		particle.position = Vector2(0, 0)
		particle.modulate = color

		# 设置粒子的移动方向
		var angle = i * TAU / 8
		var particle_speed = Vector2(cos(angle), sin(angle)) * 100

		# 创建Tween - Godot 4.x 新的Tween系统
		var tween = create_tween()

		# 设置Tween属性动画 - Godot 4.x 语法
		tween.tween_property(particle, "position", particle.position + particle_speed, 0.3)
		tween.parallel().tween_property(particle, "modulate:a", 0.0, 0.3)

		# 使用新的await语法替代yield - Godot 4.x
		await get_tree().create_timer(0.3).timeout

		# 安全删除粒子和Tween
		particle.queue_free()
		# Tween会自动清理，无需手动删除

	# 移除泡泡 - 使用call_deferred确保安全删除
	call_deferred("queue_free")

func set_size(new_size):
	size = new_size
	$CollisionShape2D.shape.radius = size