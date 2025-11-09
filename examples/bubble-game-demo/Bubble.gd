# 泡泡类 - 符合Godot 4.x API标准
class_name Bubble
extends Area2D

# 信号定义
signal popped(score)
signal clicked

# 泡泡属性
var size: float = 30
var lifetime: float = 3.0
var fade_speed: float = 2.0
var is_fading: bool = false
var timer: Timer
var velocity: Vector2 = Vector2(0, 0)
var speed: float = randf_range(50, 100)

# 输入处理属性
var bubble_id: int = 0
static var next_id: int = 0

# 视觉效果属性
var bubble_shader: ShaderMaterial
var is_hovering: bool = false
var bubble_type: String = "normal"

# 节点引用
var main_sprite: Sprite2D
var highlight_sprite: Sprite2D

func _ready() -> void:
	# 设置唯一ID
	bubble_id = next_id
	next_id += 1

	# 将泡泡添加到bubbles组
	add_to_group("bubbles")

	# 只有当bubble_type还是默认值时才随机设置类型，避免覆盖GameManager设置的类型
	# 注意：在GameManager中已经设置了类型，这里只是作为后备
	if bubble_type == "normal":
		var rand_type = randf()
		if rand_type < 0.05:
			bubble_type = "golden"
		elif rand_type < 0.1:
			bubble_type = "rainbow"
		elif rand_type < 0.15:
			bubble_type = "large"
		else:
			bubble_type = "normal"

	# 打印当前泡泡类型，用于调试
	print("Bubble ready: Type set to ", bubble_type)

	# 移除现有的Sprite2D（如果存在），使用动态创建的
	var existing_sprite = $Sprite2D
	if existing_sprite:
		existing_sprite.queue_free()

	# 设置泡泡视觉效果
	setup_visual_effects()

	# 设置随机初始速度方向
	var angle: float = randf_range(0, TAU)
	velocity = Vector2(cos(angle), sin(angle)) * speed

	# 创建生命周期计时器 - 使用Godot 4.x推荐方式
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = lifetime
	timer.timeout.connect(start_fade)
	timer.start()

	# 确保碰撞区域已正确设置
	setup_collision()

	# 添加到输入处理组
	set_process_input(true)

func setup_collision() -> void:
	# 获取或创建碰撞形状
	var collision_shape = $CollisionShape2D
	if not collision_shape:
		collision_shape = CollisionShape2D.new()
		add_child(collision_shape)

	# 设置圆形碰撞形状
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = size
	collision_shape.shape = circle_shape

func setup_visual_effects() -> void:
	# 保持使用Sprite2D来显示圆形泡泡，但支持动态颜色变化
	main_sprite = Sprite2D.new()

	# 创建圆形纹理
	var bubble_texture = create_circle_texture(size)
	main_sprite.texture = bubble_texture
	main_sprite.centered = true
	add_child(main_sprite)

	# 设置基础纹理或颜色
	print("Setting visual effects for bubble type: ", bubble_type)
	match bubble_type:
		"normal":
			main_sprite.modulate = Color(0.8, 0.8, 1.0, 1.0)  # 蓝色
		"golden":
			main_sprite.modulate = Color.GOLD  # 金色
		"rainbow":
			main_sprite.modulate = Color(1.0, 0.5, 1.0, 1.0)  # 紫色
		"large":
			main_sprite.modulate = Color(0.5, 1.0, 1.0, 1.0)  # 青色
			size *= 1.5
			main_sprite.texture = create_circle_texture(size)

	# 创建一个小的亮点，使泡泡看起来更逼真
	highlight_sprite = Sprite2D.new()
	var highlight_texture = create_circle_texture(size / 3)
	highlight_sprite.texture = highlight_texture
	highlight_sprite.modulate = Color(1, 1, 1, 0.6)
	highlight_sprite.position = Vector2(-size / 3, -size / 3)
	add_child(highlight_sprite)

func create_circle_texture(radius: float) -> ImageTexture:
	# 创建一个圆形纹理
	var image = Image.create(radius * 2, radius * 2, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)

	# 绘制圆形
	var center = Vector2(radius, radius)
	for x in range(radius * 2):
		for y in range(radius * 2):
			var pos = Vector2(x, y)
			var distance = pos.distance_to(center)
			if distance <= radius:
				# 添加边缘渐变效果
				var alpha = 1.0
				if distance > radius * 0.8:
					alpha = (radius - distance) / (radius * 0.2)
				image.set_pixel(x, y, Color(1, 1, 1, alpha))

	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	# 处理鼠标输入事件
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if get_viewport_rect().has_point(event.position):
				pop()

func pop() -> void:
	# 发出泡泡被戳破的信号（包含分数和位置）
	popped.emit(10, global_position)

	# 发出点击信号
	clicked.emit()

	# 创建简单的爆炸效果
	create_pop_effect()

	# 创建粒子效果（如果EnhancedParticleEffect可用）
	create_particle_effect()

	# 移除泡泡
	queue_free()

func create_pop_effect() -> void:
	# 创建简单的视觉爆炸效果
	for i in range(8):
		var particle = Sprite2D.new()
		var particle_texture = create_circle_texture(5)
		particle.texture = particle_texture
		add_child(particle)
		particle.position = Vector2(0, 0)
		# 使用main_sprite作为颜色参考
		if main_sprite:
			particle.modulate = main_sprite.modulate

		# 设置粒子的移动方向
		var angle = i * TAU / 8
		var particle_velocity = Vector2(cos(angle), sin(angle)) * 100

		# 创建动画
		var tween = create_tween()
		tween.tween_property(particle, "position", particle.position + particle_velocity, 0.3)
		tween.parallel().tween_property(particle, "modulate:a", 0.0, 0.3)
		tween.tween_callback(func(): particle.queue_free())

func create_particle_effect() -> void:
	# 尝试创建增强粒子效果
	if ClassDB.class_exists("EnhancedParticleEffect"):
		# 使用EnhancedParticleEffect创建效果
		match bubble_type:
			"golden":
				EnhancedParticleEffect.create_gold_explosion(global_position, get_tree().current_scene)
			"rainbow":
				EnhancedParticleEffect.create_rainbow_explosion(global_position, get_tree().current_scene)
			"large":
				EnhancedParticleEffect.create_explosion(global_position, get_tree().current_scene)
			_:
				EnhancedParticleEffect.create_explosion(global_position, get_tree().current_scene)

func _physics_process(delta: float) -> void:
	# 移动泡泡
	position += velocity * delta

	# 屏幕边界碰撞检测
	var screen_size: Vector2i = get_viewport_rect().size
	var bubble_radius: float = size

	if position.x - bubble_radius < 0 or position.x + bubble_radius > screen_size.x:
		velocity.x = -velocity.x
		# 确保泡泡不会卡在边界外
		position.x = clamp(position.x, bubble_radius, screen_size.x - bubble_radius)

	if position.y - bubble_radius < 0 or position.y + bubble_radius > screen_size.y:
		velocity.y = -velocity.y
		# 确保泡泡不会卡在边界外
		position.y = clamp(position.y, bubble_radius, screen_size.y - bubble_radius)

func start_fade() -> void:
	is_fading = true

func _process(delta: float) -> void:
	if is_fading:
		# 使用main_sprite进行透明度控制
		if main_sprite:
			var current_alpha = main_sprite.modulate.a
			var new_alpha = max(0, current_alpha - fade_speed * delta)
			main_sprite.modulate.a = new_alpha

			# 如果完全透明，移除泡泡
			if new_alpha <= 0:
				queue_free()
		else:
			# 如果找不到main_sprite，直接移除泡泡
			queue_free()

# 设置泡泡大小
func set_size(new_size: float) -> void:
	size = new_size
	# 使用main_sprite更新大小
	if main_sprite:
		main_sprite.texture = create_circle_texture(size)

	# 更新碰撞形状
	var collision_shape = $CollisionShape2D
	if collision_shape:
		var circle_shape = collision_shape.shape as CircleShape2D
		if circle_shape:
			circle_shape.radius = size

# 获取泡泡类型
func get_type() -> String:
	return bubble_type

# 设置泡泡类型
func set_type(type: String) -> void:
	bubble_type = type
	setup_visual_effects()