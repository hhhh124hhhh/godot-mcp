extends Camera2D

# 屏幕震动效果系统
class_name ScreenShake

# 震动参数
var shake_intensity: float = 0.0
var shake_duration: float = 0.0
var shake_time: float = 0.0
var original_offset: Vector2 = Vector2.ZERO
var current_offset: Vector2 = Vector2.ZERO
var is_shaking: bool = false
var _dir_shake: Vector2 = Vector2.ZERO  # 用于方向性震动

# 震动预设
const SMALL_SHAKE: float = 2.0
const MEDIUM_SHAKE: float = 5.0
const LARGE_SHAKE: float = 10.0

const SHORT_SHAKE: float = 0.2
const MEDIUM_DURATION: float = 0.4
const LONG_SHAKE: float = 0.8

func _ready() -> void:
	original_offset = offset
	set_process(false)  # 初始不处理

func _process(delta: float) -> void:
	if not is_shaking:
		return

	# 更新震动时间
	shake_time += delta

	# 计算当前震动强度（随时间衰减）
	var current_intensity: float = shake_intensity * (1.0 - (shake_time / shake_duration))

	if shake_time >= shake_duration:
		# 震动结束
		stop_shake()
	else:
		if _dir_shake.length() > 0:
			# 方向性震动
			var noise_value = get_noise_value(shake_time * 10.0)
			# 在指定方向上加上随机扰动
			var direction_offset = _dir_shake.normalized() * current_intensity * noise_value
			# 添加一些横向扰动
			var perpendicular = Vector2(-_dir_shake.y, _dir_shake.x).normalized()
			var perpendicular_offset = perpendicular * current_intensity * 0.3 * get_noise_value(shake_time * 15.0)
			
			current_offset = direction_offset + perpendicular_offset
		else:
			# 普通随机震动
			# 应用随机偏移
			var shake_offset = Vector2(
				randf_range(-current_intensity, current_intensity),
				randf_range(-current_intensity, current_intensity)
			)

			# 使用噪声函数让震动更自然
			var noise_value = get_noise_value(shake_time * 10.0)
			current_offset = shake_offset * noise_value
		
		offset = original_offset + current_offset

# 开始屏幕震动
func start_shake(intensity: float, duration: float) -> void:
	shake_intensity = intensity
	shake_duration = duration
	shake_time = 0.0
	is_shaking = true

	set_process(true)

# 停止震动
func stop_shake() -> void:
	is_shaking = false
	current_offset = Vector2.ZERO
	_dir_shake = Vector2.ZERO  # 重置方向震动
	offset = original_offset
	set_process(false)

# 获取噪声值（用于更自然的震动）
func get_noise_value(time: float) -> float:
	# 简单的伪随机噪声
	return (sin(time * 7.0) * 0.5 + sin(time * 13.0) * 0.3 + sin(time * 17.0) * 0.2)

# 预设震动效果

# 小震动（轻微点击反馈）
func add_small_shake() -> void:
	start_shake(SMALL_SHAKE, SHORT_SHAKE)

# 中等震动（普通爆炸）
func add_medium_shake() -> void:
	start_shake(MEDIUM_SHAKE, MEDIUM_DURATION)

# 大震动（强烈爆炸）
func add_large_shake() -> void:
	start_shake(LARGE_SHAKE, LONG_SHAKE)

# 渐进式震动（从弱到强）
func add_progressive_shake(max_intensity: float, duration: float) -> void:
	# 分段震动，强度递增
	var segments: int = 3
	var segment_duration: float = duration / segments

	for i in range(segments):
		var segment_intensity: float = max_intensity * float(i + 1) / segments
		# 使用定时器延迟执行每个分段
		var timer = get_tree().create_timer(i * segment_duration)
		timer.timeout.connect(func():
			start_shake(segment_intensity, segment_duration)
		)

# 方向性震动（特定方向震动）
func add_directional_shake(direction: Vector2, intensity: float, duration: float) -> void:
	# 设置方向标记，供_process使用
	_dir_shake = direction

	# 启动震动
	start_shake(intensity, duration)

# 脉冲震动（短促强烈的震动）
func add_impulse_shake(intensity: float) -> void:
	var pulse_tween = create_tween()

	# 短促震动序列 - 使用回调函数
	pulse_tween.tween_method(_shake_callback.bind(intensity), intensity, 0.0, 0.1)
	pulse_tween.tween_method(_shake_callback.bind(intensity * 0.7), intensity * 0.7, 0.0, 0.1).set_delay(0.15)
	pulse_tween.tween_method(_shake_callback.bind(intensity * 0.4), intensity * 0.4, 0.0, 0.1).set_delay(0.3)

# 震动回调函数
func _shake_callback(shake_intensity: float) -> void:
	start_shake(shake_intensity, 0.1)

# 震动测试
func test_shake_patterns() -> void:
	# 简单调用不使用异步的方法进行测试
	add_small_shake()
	print("屏幕震动测试：小震动已触发")

# 设置震动强度（全局设置）
func set_shake_intensity(intensity: float) -> void:
	shake_intensity = clamp(intensity, 0.0, 50.0)

# 设置震动持续时间
func set_shake_duration(duration: float) -> void:
	shake_duration = clamp(duration, 0.1, 5.0)

# 获取当前震动状态
func is_shaking_active() -> bool:
	return is_shaking

# 获取当前震动强度
func get_current_intensity() -> float:
	if not is_shaking:
		return 0.0
	var progress: float = shake_time / shake_duration
	return shake_intensity * (1.0 - progress)

# 平滑震动（用于连续输入）
func add_smooth_shake(intensity: float, duration: float) -> void:
	if is_shaking:
		# 如果已经在震动，增强现有震动
		shake_intensity = max(shake_intensity, intensity)
		shake_duration = max(shake_duration, duration)
	else:
		# 新的平滑震动
		start_shake(intensity, duration)

# 震动减弱效果（逐渐减弱到停止）
func fade_out_shake(fade_duration: float) -> void:
	if not is_shaking:
		return

	var fade_tween = create_tween()
	var start_intensity = shake_intensity

	# 正确的淡出方式
	shake_time = 0.0
	fade_tween.tween_property(self, "shake_intensity", 0.0, fade_duration)

	# 同时缩短震动持续时间
	var new_duration = min(shake_duration, fade_duration)
	shake_duration = new_duration
