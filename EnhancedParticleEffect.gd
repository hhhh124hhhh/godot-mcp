# 增强粒子效果系统 - 彩色爆炸粒子
# 符合Godot 4.x API标准，解决常见的解析错误
class_name EnhancedParticleEffect
extends Node2D

# 粒子系统节点
var particles: GPUParticles2D
var particle_material: ParticleProcessMaterial

# 安全的定时器创建方法
func safe_create_timer(delay: float) -> SceneTreeTimer:
	if get_tree():
		return get_tree().create_timer(delay)

	var main_loop = Engine.get_main_loop()
	if main_loop and main_loop is SceneTree:
		return main_loop.create_timer(delay)

	push_error("EnhancedParticleEffect: 无法创建定时器 - 节点不在场景树中")
	return null

# 初始化彩色爆炸粒子效果
static func create_explosion(position: Vector2, parent: Node = null) -> EnhancedParticleEffect:
	var effect = EnhancedParticleEffect.new()

	if parent:
		parent.add_child(effect)
	else:
		var scene_tree = Engine.get_main_loop() as SceneTree
		if scene_tree and scene_tree.current_scene:
			scene_tree.current_scene.add_child(effect)

	effect.global_position = position
	effect._setup_explosion()

	return effect

# 创建金色爆炸粒子效果
static func create_gold_explosion(position: Vector2, parent: Node = null) -> EnhancedParticleEffect:
	var effect = EnhancedParticleEffect.new()

	if parent:
		parent.add_child(effect)
	else:
		var scene_tree = Engine.get_main_loop() as SceneTree
		if scene_tree and scene_tree.current_scene:
			scene_tree.current_scene.add_child(effect)

	effect.global_position = position
	effect._setup_gold_explosion()

	return effect

# 创建彩虹爆炸粒子效果
static func create_rainbow_explosion(position: Vector2, parent: Node = null) -> EnhancedParticleEffect:
	var effect = EnhancedParticleEffect.new()

	if parent:
		parent.add_child(effect)
	else:
		var scene_tree = Engine.get_main_loop() as SceneTree
		if scene_tree and scene_tree.current_scene:
			scene_tree.current_scene.add_child(effect)

	effect.global_position = position
	effect._setup_rainbow_explosion()

	return effect

# 设置爆炸粒子效果
func _setup_explosion() -> void:
	_setup_particle_system(50, 1.5, Color(1.0, 0.7, 0.3, 1.0), 100.0, 300.0, -90.0, 90.0, 0.1, 0.3)

# 设置金色爆炸效果
func _setup_gold_explosion() -> void:
	_setup_particle_system(80, 2.0, Color.GOLD, 150.0, 400.0, -120.0, 120.0, 0.2, 0.5)

# 设置彩虹爆炸效果
func _setup_rainbow_explosion() -> void:
	_setup_particle_system(100, 2.5, Color.PURPLE, 200.0, 500.0, -180.0, 180.0, 0.15, 0.6)

# 通用粒子系统设置方法
func _setup_particle_system(amount: int, lifetime: float, color: Color, vel_min: float, vel_max: float, ang_min: float, ang_max: float, scale_min: float, scale_max: float) -> void:
	particles = GPUParticles2D.new()
	add_child(particles)

	particle_material = ParticleProcessMaterial.new()

	particles.amount = max(1, amount)
	particles.lifetime = lifetime

	particle_material.direction = Vector3.UP
	particle_material.spread = 45.0
	particle_material.initial_velocity_min = vel_min
	particle_material.initial_velocity_max = vel_max
	particle_material.angular_velocity_min = ang_min
	particle_material.angular_velocity_max = ang_max
	particle_material.scale_min = scale_min
	particle_material.scale_max = scale_max
	particle_material.color = color

	particles.process_material = particle_material
	particles.emitting = true

	_start_auto_destroy()

# 安全的自动销毁启动
func _start_auto_destroy() -> void:
	var timer = safe_create_timer(3.0)
	if timer:
		timer.timeout.connect(queue_free)
	else:
		call_deferred("queue_free")

# 立即停止粒子
func stop_particles() -> void:
	if particles:
		particles.emitting = false

# 获取粒子数量
func get_particle_count() -> int:
	if particles:
		return particles.amount
	return 0

# 设置粒子颜色
func set_particle_colors(colors: Array[Color]) -> void:
	if particle_material and colors.size() > 0:
		particle_material.color = colors[0]

# 设置粒子数量
func set_particle_count(count: int) -> void:
	if particles:
		var safe_amount = int(count)
		particles.amount = max(1, safe_amount)

# 设置粒子速度
func set_particle_speed(min_speed: float, max_speed: float) -> void:
	if particle_material:
		particle_material.initial_velocity_min = min_speed
		particle_material.initial_velocity_max = max_speed

# 设置粒子大小
func set_particle_size(min_size: float, max_size: float) -> void:
	if particle_material:
		particle_material.scale_min = min_size
		particle_material.scale_max = max_size

# 检查是否正在发射
func is_emitting() -> bool:
	if particles:
		return particles.emitting
	return false

# 暂停粒子
func pause_particles() -> void:
	if particles:
		particles.emitting = false

# 恢复粒子
func resume_particles() -> void:
	if particles:
		particles.emitting = true

# 清理资源
func cleanup() -> void:
	if particles:
		particles.queue_free()
		particles = null
	if particle_material:
		particle_material = null

# 延迟清理
func cleanup_after_delay(delay: float) -> void:
	var timer = safe_create_timer(delay)
	if timer:
		timer.timeout.connect(cleanup)
	else:
		call_deferred("cleanup")

# 复制粒子效果
func duplicate_effect() -> EnhancedParticleEffect:
	var new_effect = EnhancedParticleEffect.new()
	new_effect.particles = particles.duplicate()

	if particle_material:
		new_effect._setup_particle_system(
			particles.amount,
			particles.lifetime,
			particle_material.color,
			particle_material.initial_velocity_min,
			particle_material.initial_velocity_max,
			particle_material.angular_velocity_min,
			particle_material.angular_velocity_max,
			particle_material.scale_min,
			particle_material.scale_max
		)

	return new_effect

# Godot 4.x 入口点
func _ready() -> void:
	pass

# 清理时调用
func _exit_tree() -> void:
	cleanup()