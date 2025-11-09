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

	# 添加鼠标点击检测 - 使用 Godot 4.x 信号连接语法
	input_event.connect(_on_input_event)

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
	# 检测鼠标点击
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		pop()

func pop():
	# 发出泡泡被戳破的信号 - 修复信号名称错误
	popped.emit(10)  # 每个泡泡得10分
	
	# 创建简单的粒子效果（视觉反馈）
	for i in range(8):
		var particle = Node2D.new()
		add_child(particle)
		particle.position = Vector2(0, 0)
		particle.modulate = color
		
		# 设置粒子的移动方向
		var angle = i * TAU / 8
		var particle_speed = Vector2(cos(angle), sin(angle)) * 100
		
		# 创建一个Tween来移动粒子 - 使用 Godot 4.x API
		var tween = create_tween()
		tween.tween_property(particle, "position", particle.position + particle_speed, 0.3).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		tween.tween_property(particle, "modulate:a", 0.0, 0.3)

		# 延迟后移除粒子 - 使用 Godot 4.x await
		await get_tree().create_timer(0.3).timeout
		particle.queue_free()
	
	# 移除泡泡
	queue_free()

func set_size(new_size):
	size = new_size
	$CollisionShape2D.shape.radius = size
