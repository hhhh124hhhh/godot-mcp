extends Node2D

# 分数飘出动画系统
class_name ScorePopup

var score_label: Label
var tween: Tween

# 初始化分数飘出效果
static func create_score_popup(position: Vector2, score: int = 1, parent: Node = null) -> ScorePopup:
	var popup = ScorePopup.new()
	popup.setup(position, score)

	if parent:
		parent.add_child(popup)
	else:
		# 获取场景树并添加到根节点
		var scene_tree = Engine.get_main_loop() as SceneTree
		if scene_tree and scene_tree.current_scene:
			scene_tree.current_scene.add_child(popup)

	return popup

# 设置分数飘出
func setup(position: Vector2, score: int) -> void:
	# 设置初始位置，减少偏移让飘字更贴近泡泡
	global_position = position + Vector2(0, -5)  # 向上偏移5像素，让飘字从泡泡边缘出现

	# 创建分数标签
	score_label = Label.new()
	add_child(score_label)

	# 设置分数文本
	score_label.text = "+" + str(score)

	# 设置字体样式
	score_label.add_theme_font_size_override("font_size", 36)  # 稍微小一点的字体
	score_label.add_theme_color_override("font_color", Color.GOLD)
	score_label.add_theme_color_override("font_shadow_color", Color(0.2, 0.1, 0.0, 0.8))
	score_label.add_theme_constant_override("shadow_offset_x", 2)
	score_label.add_theme_constant_override("shadow_offset_y", 2)

	# 设置初始状态
	score_label.position = Vector2.ZERO
	score_label.scale = Vector2(0.1, 0.1)  # 从很小开始
	score_label.modulate = Color.WHITE
	score_label.modulate.a = 1.0

	# 居中对齐
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# 启动动画
	start_score_animation()

# 开始分数飘出动画
func start_score_animation() -> void:
	tween = create_tween()
	tween.set_parallel(true)  # 允许并行动画

	# 位置动画：向上飘出，减少距离让飘字更贴近泡泡
	tween.tween_property(score_label, "position", Vector2(0, -25), 0.8)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	# 缩放动画：弹跳效果
	tween.tween_property(score_label, "scale", Vector2.ONE, 0.2)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	# 弹跳回来
	tween.tween_property(score_label, "scale", Vector2(1.2, 1.2), 0.1)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)\
		.set_delay(0.2)

	# 恢复正常大小
	tween.tween_property(score_label, "scale", Vector2.ONE, 0.15)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_delay(0.3)

	# 透明度动画：渐变消失
	tween.tween_property(score_label, "modulate:a", 0.0, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)\
		.set_delay(0.4)

	# 颜色渐变：金色到橙色
	var color_tween = create_tween()
	color_tween.tween_property(score_label, "modulate", Color.ORANGE, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_delay(0.4)

	# 轻微旋转
	tween.tween_property(score_label, "rotation", deg_to_rad(5), 0.8)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	# 动画完成后移除 - 缩短时间让效果更紧凑
	tween.tween_callback(destroy_score_popup).set_delay(1.0)

# 销毁分数飘出对象
func destroy_score_popup() -> void:
	# 确保平滑消失
	if is_inside_tree():
		queue_free()

# 创建组合分数飘出（连击奖励）
static func create_combo_popup(position: Vector2, combo_count: int, parent: Node = null) -> ScorePopup:
	var popup = ScorePopup.new()
	popup.setup_combo(position, combo_count)

	if parent:
		parent.add_child(popup)
	else:
		var scene_tree = Engine.get_main_loop() as SceneTree
		if scene_tree and scene_tree.current_scene:
			scene_tree.current_scene.add_child(popup)

	return popup

# 设置连击分数飘出
func setup_combo(position: Vector2, combo_count: int) -> void:
	global_position = position

	# 创建连击标签
	score_label = Label.new()
	add_child(score_label)

	# 设置连击文本
	if combo_count >= 10:
		score_label.text = "COMBO x" + str(combo_count) + "! 🔥"
	elif combo_count >= 5:
		score_label.text = "COMBO x" + str(combo_count) + "!"
	else:
		score_label.text = "x" + str(combo_count)

	# 根据连击数设置样式
	var font_size: int = 36 + min(combo_count * 2, 48)
	score_label.add_theme_font_size_override("font_size", font_size)

	# 连击特效颜色
	if combo_count >= 10:
		score_label.add_theme_color_override("font_color", Color.RED)
	elif combo_count >= 5:
		score_label.add_theme_color_override("font_color", Color.ORANGE)
	else:
		score_label.add_theme_color_override("font_color", Color.YELLOW)

	# 阴影效果
	score_label.add_theme_color_override("font_shadow_color", Color(0.2, 0.1, 0.0, 0.9))
	score_label.add_theme_constant_override("shadow_offset_x", 3)
	score_label.add_theme_constant_override("shadow_offset_y", 3)

	# 初始状态
	score_label.position = Vector2.ZERO
	score_label.scale = Vector2(0.1, 0.1)
	score_label.modulate = Color.WHITE
	score_label.modulate.a = 1.0

	# 居中对齐
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# 启动连击动画
	start_combo_animation(combo_count)

# 开始连击动画
func start_combo_animation(combo_count: int) -> void:
	tween = create_tween()
	tween.set_parallel(true)

	# 更夸张的位置动画
	var move_distance: float = -150 - min(combo_count * 5, 100)
	tween.tween_property(score_label, "position", Vector2(0, move_distance), 1.5)\
		.set_trans(Tween.TRANS_EXPO)\
		.set_ease(Tween.EASE_OUT)

	# 更大的缩放动画
	var target_scale: float = 1.5 + min(combo_count * 0.1, 2.0)
	tween.tween_property(score_label, "scale", Vector2(target_scale, target_scale), 0.3)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	# 弹跳效果
	tween.tween_property(score_label, "scale", Vector2(target_scale * 1.3, target_scale * 1.3), 0.15)\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_OUT)\
		.set_delay(0.3)

	# 恢复
	tween.tween_property(score_label, "scale", Vector2.ONE, 0.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_delay(0.45)

	# 更长的透明度动画
	tween.tween_property(score_label, "modulate:a", 0.0, 0.8)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)\
		.set_delay(0.7)

	# 更大的旋转效果
	var rotation_amount: float = deg_to_rad(10 + combo_count)
	tween.tween_property(score_label, "rotation", rotation_amount, 1.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	# 颜色闪烁效果
	if combo_count >= 5:
		var flash_tween = create_tween()
		flash_tween.tween_property(score_label, "modulate", Color.WHITE, 0.2)\
			.set_trans(Tween.TRANS_SINE)
		flash_tween.tween_property(score_label, "modulate", Color.ORANGE, 0.2)\
			.set_trans(Tween.TRANS_SINE)
		flash_tween.set_delay(0.4)

	# 动画完成后移除
	tween.tween_callback(destroy_score_popup).set_delay(2.0)
