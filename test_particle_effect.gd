# 测试EnhancedParticleEffect类的使用示例
# 演示如何正确使用EnhancedParticleEffect避免解析错误

extends Node2D

func _ready() -> void:
	print("开始测试EnhancedParticleEffect类...")

	# 测试1: 基本爆炸效果
	test_basic_explosion()

	# 测试2: 金色爆炸效果
	test_gold_explosion()

	# 测试3: 彩虹爆炸效果
	test_rainbow_explosion()

func test_basic_explosion() -> void:
	print("测试基本爆炸效果...")

	# 创建基本爆炸效果
	var explosion = EnhancedParticleEffect.create_explosion(Vector2(200, 200), self)

	# 验证创建成功
	if explosion:
		print("✅ 基本爆炸效果创建成功")
		print(f"   粒子数量: {explosion.get_particle_count()}")
		print(f"   是否正在发射: {explosion.is_emitting()}")
	else:
		print("❌ 基本爆炸效果创建失败")

func test_gold_explosion() -> void:
	print("测试金色爆炸效果...")

	# 创建金色爆炸效果
	var gold_explosion = EnhancedParticleEffect.create_gold_explosion(Vector2(400, 200), self)

	# 验证创建成功
	if gold_explosion:
		print("✅ 金色爆炸效果创建成功")
		print(f"   粒子数量: {gold_explosion.get_particle_count()}")
		print(f"   是否正在发射: {gold_explosion.is_emitting()}")
	else:
		print("❌ 金色爆炸效果创建失败")

func test_rainbow_explosion() -> void:
	print("测试彩虹爆炸效果...")

	# 创建彩虹爆炸效果
	var rainbow_explosion = EnhancedParticleEffect.create_rainbow_explosion(Vector2(600, 200), self)

	# 验证创建成功
	if rainbow_explosion:
		print("✅ 彩虹爆炸效果创建成功")
		print(f"   粒子数量: {rainbow_explosion.get_particle_count()}")
		print(f"   是否正在发射: {rainbow_explosion.is_emitting()}")
	else:
		print("❌ 彩虹爆炸效果创建失败")

# 演示如何在输入事件中使用
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# 在鼠标位置创建爆炸效果
			var mouse_pos = get_global_mouse_position()
			var explosion = EnhancedParticleEffect.create_explosion(mouse_pos, self)
			print(f"在位置 {mouse_pos} 创建了爆炸效果")

# 演示动态配置粒子效果
func _on_timer_timeout() -> void:
	# 创建自定义配置的粒子效果
	var custom_explosion = EnhancedParticleEffect.create_explosion(Vector2(400, 400), self)

	# 自定义粒子属性
	custom_explosion.set_particle_count(100)
	custom_explosion.set_particle_speed(50.0, 250.0)
	custom_explosion.set_particle_size(0.2, 0.8)

	# 设置自定义颜色
	var colors: Array[Color] = [Color.CYAN, Color.MAGENTA, Color.YELLOW]
	custom_explosion.set_particle_colors(colors)

	print("创建了自定义配置的粒子效果")