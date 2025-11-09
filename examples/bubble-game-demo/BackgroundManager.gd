extends Node2D
class_name BackgroundManager

# 背景管理器 - 动态粒子背景系统
var background_rect: TextureRect
var gradient_texture: GradientTexture2D
var color_tween: Tween
var decoration_bubbles: Array[Node2D] = []

# 动态粒子系统
var background_particles: Array[Node2D] = []
var particle_count: int = 15  # 粒子数量

# 渐变颜色配置
var gradient_colors: Array[Color] = [
	Color(0.4, 0.6, 1.0, 1.0),  # 天蓝色
	Color(0.6, 0.4, 1.0, 1.0),  # 淡紫色
	Color(0.4, 0.8, 1.0, 1.0),  # 青蓝色
	Color(0.7, 0.5, 0.9, 1.0)   # 淡紫色
]

var current_color_index: int = 0

func _ready() -> void:
	# 先设置背景，等待完成后再启动动画
	_setup_complete_background()

	# 监听窗口大小变化
	get_tree().root.size_changed.connect(_on_window_resized)

# 完整的背景设置流程
func _setup_complete_background() -> void:
	setup_background()
	create_decoration_bubbles()
	create_background_particles()  # 添加动态粒子

	# 等待一帧确保所有设置完成
	await get_tree().process_frame

	# 现在安全地启动背景动画
	start_background_animation()

func _on_window_resized() -> void:
	# 窗口大小改变时重新设置背景
	print("Window resized, updating background")
	update_background_size()

func update_background_size() -> void:
	if background_rect and gradient_texture:
		var viewport = get_viewport()
		if viewport:
			var screen_size = viewport.get_visible_rect().size
			print("New screen size: ", screen_size)

			# 更新纹理尺寸
			gradient_texture.width = max(1024, int(screen_size.x))
			gradient_texture.height = max(1024, int(screen_size.y))

# 设置渐变背景
func setup_background() -> void:
	# 等待一帧确保视窗已经初始化
	await get_tree().process_frame

	# 获取视窗大小
	var viewport = get_viewport()
	var screen_size = viewport.get_visible_rect().size
	print("Background viewport size: ", screen_size)

	# 创建渐变纹理 - 使用高分辨率
	gradient_texture = GradientTexture2D.new()
	var gradient = Gradient.new()

	# 设置渐变颜色点
	gradient.add_point(0.0, gradient_colors[0])
	gradient.add_point(0.5, gradient_colors[1])
	gradient.add_point(1.0, gradient_colors[2])

	# 使用固定的高质量尺寸确保背景铺满
	gradient_texture.gradient = gradient
	gradient_texture.width = 2048  # 使用固定的高分辨率
	gradient_texture.height = 2048
	gradient_texture.use_hdr = false
	gradient_texture.fill = GradientTexture2D.FILL_LINEAR  # Godot 4.x 正确的填充模式

	# 尝试使用TextureRect
	background_rect = TextureRect.new()
	background_rect.anchors_preset = Control.PRESET_FULL_RECT
	background_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	background_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE  # Godot 4.x 正确的展开模式
	background_rect.texture = gradient_texture
	add_child(background_rect)

	print("Background setup complete with TextureRect")

# 创建装饰性背景泡泡
func create_decoration_bubbles() -> void:
	var bubble_count: int = 8
	var screen_size = get_viewport_rect().size

	for i in range(bubble_count):
		var bubble = create_decoration_bubble(i)
		decoration_bubbles.append(bubble)
		add_child(bubble)

# 创建单个装饰泡泡
func create_decoration_bubble(index: int) -> Node2D:
	var container = Node2D.new()

	# 随机位置和大小
	var screen_size = get_viewport_rect().size
	container.position = Vector2(
		randf_range(0, screen_size.x),
		randf_range(0, screen_size.y)
	)

	# 创建泡泡精灵 - 使用动态圆形纹理
	var bubble_sprite = Sprite2D.new()
	var bubble_size = randf_range(15, 40)
	bubble_sprite.texture = create_circle_texture(bubble_size)
	bubble_sprite.modulate = Color.WHITE
	bubble_sprite.modulate.a = 0.1  # 很低的透明度

	container.add_child(bubble_sprite)

	# 添加缓慢的浮动动画
	animate_decoration_bubble(container, index)

	return container

# 创建圆形纹理（从Bubble.gd复制）
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

# 装饰泡泡动画
func animate_decoration_bubble(bubble: Node2D, index: int) -> void:
	animate_decoration_bubble_loop(bubble)

# 泡泡循环动画
func animate_decoration_bubble_loop(bubble: Node2D) -> void:
	var tween = bubble.create_tween().set_parallel(true)

	# 垂直浮动
	var float_distance: float = randf_range(20, 50)
	var float_duration: float = randf_range(8, 12)
	tween.tween_property(bubble, "position:y", bubble.position.y - float_distance, float_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(bubble, "position:y", bubble.position.y, float_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_delay(float_duration)

	# 轻微旋转
	var rotation_amount: float = randf_range(10, 30)
	var rotation_duration: float = randf_range(15, 25)
	tween.tween_property(bubble, "rotation", deg_to_rad(rotation_amount), rotation_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(bubble, "rotation", deg_to_rad(-rotation_amount), rotation_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_delay(rotation_duration)

	# 动画结束后重新开始循环
	tween.tween_callback(animate_decoration_bubble_loop.bind(bubble))

# 启动背景动画
func start_background_animation() -> void:
	color_tween = create_tween()

	# 颜色渐变动画
	animate_color_transition()

# 颜色过渡动画
func animate_color_transition() -> void:
	# 安全检查：确保gradient_texture已初始化
	if gradient_texture == null:
		print("警告: gradient_texture还未初始化，跳过颜色过渡")
		return

	if gradient_texture.gradient == null:
		print("警告: gradient_texture.gradient还未初始化，跳过颜色过渡")
		return

	var gradient = gradient_texture.gradient

	# 过渡到下一个颜色组合
	current_color_index = (current_color_index + 1) % gradient_colors.size()
	var next_color1 = gradient_colors[current_color_index]
	var next_color2 = gradient_colors[(current_color_index + 1) % gradient_colors.size()]
	var next_color3 = gradient_colors[(current_color_index + 2) % gradient_colors.size()]

	# 使用Tween直接插值颜色，而不是读取现有颜色
	var transition_tween = create_tween()
	transition_tween.set_parallel(false)

	# 直接使用颜色插值，避免get_color_at_offset
	transition_tween.tween_method(
		func(value: float):
			# 计算当前插值颜色
			var current_color1 = gradient.get_color(0).lerp(next_color1, value)
			var current_color2 = gradient.get_color(1).lerp(next_color2, value)
			var current_color3 = gradient.get_color(2).lerp(next_color3, value)

			# 更新渐变点
			gradient.set_color(0, current_color1)
			gradient.set_color(1, current_color2)
			gradient.set_color(2, current_color3)
	, 0.0, 1.0, 5.0
	)

	# 动画完成后继续下一个循环
	transition_tween.tween_callback(animate_color_transition)

# 设置背景颜色主题
func set_background_theme(theme_name: String) -> void:
	match theme_name:
		"ocean":
			gradient_colors = [
				Color(0.2, 0.6, 1.0, 1.0),  # 深海蓝
				Color(0.4, 0.8, 1.0, 1.0),  # 海蓝色
				Color(0.6, 0.9, 1.0, 1.0)   # 浅海蓝
			]
		"sunset":
			gradient_colors = [
				Color(1.0, 0.6, 0.4, 1.0),  # 橙红色
				Color(1.0, 0.4, 0.6, 1.0),  # 粉红色
				Color(0.8, 0.3, 0.5, 1.0)   # 玫瑰色
			]
		"forest":
			gradient_colors = [
				Color(0.4, 0.8, 0.4, 1.0),  # 绿色
				Color(0.5, 0.9, 0.5, 1.0),  # 浅绿色
				Color(0.3, 0.7, 0.3, 1.0)   # 深绿色
			]
		_:
			gradient_colors = [
				Color(0.4, 0.6, 1.0, 1.0),  # 默认蓝色系
				Color(0.6, 0.4, 1.0, 1.0),
				Color(0.4, 0.8, 1.0, 1.0)
			]

	# 重新应用颜色
	if gradient_texture and gradient_texture.gradient:
		update_gradient_immediately()

# 立即更新渐变
func update_gradient_immediately() -> void:
	# 安全检查：确保gradient_texture和gradient已初始化
	if gradient_texture == null:
		print("警告: gradient_texture还未初始化，无法更新渐变")
		return

	if gradient_texture.gradient == null:
		print("警告: gradient_texture.gradient还未初始化，无法更新渐变")
		return

	var gradient = gradient_texture.gradient
	gradient.remove_point(2)
	gradient.remove_point(1)
	gradient.remove_point(0)
	gradient.add_point(0.0, gradient_colors[0])
	gradient.add_point(0.5, gradient_colors[1])
	gradient.add_point(1.0, gradient_colors[2])

# 创建动态背景粒子
func create_background_particles() -> void:
	var screen_size = get_viewport_rect().size

	for i in range(particle_count):
		var particle = create_background_particle(i)
		background_particles.append(particle)
		add_child(particle)

# 创建单个背景粒子
func create_background_particle(index: int) -> Node2D:
	var container = Node2D.new()

	# 随机位置（全屏范围）
	var screen_size = get_viewport_rect().size
	container.position = Vector2(
		randf_range(0, screen_size.x),
		randf_range(0, screen_size.y)
	)

	# 创建发光粒子精灵
	var particle_sprite = Sprite2D.new()
	var particle_size = randf_range(3, 8)  # 小粒子
	particle_sprite.texture = create_glow_texture(particle_size)

	# 随机颜色（从渐变色中选择）
	var color_choice = gradient_colors[randi() % gradient_colors.size()]
	particle_sprite.modulate = color_choice
	particle_sprite.modulate.a = randf_range(0.3, 0.7)  # 半透明

	container.add_child(particle_sprite)

	# 添加缓慢的漂浮动画
	animate_background_particle(container, index)

	return container

# 创建发光纹理（圆形带光晕效果）
func create_glow_texture(radius: float) -> ImageTexture:
	var image = Image.create(radius * 4, radius * 4, false, Image.FORMAT_RGBA8)
	image.fill(Color.TRANSPARENT)

	var center = Vector2(radius * 2, radius * 2)

	# 绘制多层光晕效果
	for x in range(radius * 4):
		for y in range(radius * 4):
			var pos = Vector2(x, y)
			var distance = pos.distance_to(center)

			if distance <= radius * 2:
				# 外层光晕
				if distance > radius:
					var alpha = (radius * 2 - distance) / (radius)
					alpha *= 0.3  # 较弱的透明度
					image.set_pixel(x, y, Color(1, 1, 1, alpha))
				# 内核
				else:
					var alpha = 1.0 - (distance / radius) * 0.5
					image.set_pixel(x, y, Color(1, 1, 1, alpha))

	var texture = ImageTexture.new()
	texture.set_image(image)
	return texture

# 背景粒子动画
func animate_background_particle(particle: Node2D, index: int) -> void:
	animate_background_particle_loop(particle)

# 背景粒子循环动画
func animate_background_particle_loop(particle: Node2D) -> void:
	var tween = particle.create_tween().set_parallel(true)

	# 随机漂浮运动
	var float_duration: float = randf_range(15, 25)
	var move_x = randf_range(-100, 100)
	var move_y = randf_range(-80, 80)

	# 位置动画
	tween.tween_property(particle, "position:x", particle.position.x + move_x, float_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(particle, "position:y", particle.position.y + move_y, float_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

	# 透明度呼吸效果
	var sprite = particle.get_child(0) as Sprite2D
	tween.tween_property(sprite, "modulate:a", sprite.modulate.a * 0.3, float_duration / 2) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "modulate:a", sprite.modulate.a, float_duration / 2) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_delay(float_duration / 2)

	# 轻微旋转
	var rotation_amount: float = randf_range(-45, 45)
	tween.tween_property(particle, "rotation", deg_to_rad(rotation_amount), float_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)

	# 动画结束后重新开始循环
	tween.tween_callback(animate_background_particle_loop.bind(particle))
