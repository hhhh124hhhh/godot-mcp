# 简单测试脚本 - 验证EnhancedParticleEffect类修复
extends Node2D

func _ready() -> void:
	print("EnhancedParticleEffect类测试开始...")

	# 测试类是否能正常解析
	test_class_resolution()

func test_class_resolution() -> void:
	# 如果类能正常解析，这个实例化不会出错
	var particle_effect = EnhancedParticleEffect.new()

	if particle_effect:
		print("✅ EnhancedParticleEffect类解析成功!")
		print("✅ 类实例化成功!")

		# 测试基本方法
		var count = particle_effect.get_particle_count()
		print(f"✅ get_particle_count()方法正常，返回: {count}")

		var is_emitting = particle_effect.is_emitting()
		print(f"✅ is_emitting()方法正常，返回: {is_emitting}")

		# 清理
		particle_effect.cleanup()
		print("✅ cleanup()方法正常")

		print("🎉 所有测试通过！EnhancedParticleEffect类已完全修复")
	else:
		print("❌ 类实例化失败")

# 测试静态方法
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			print("测试静态方法...")

			# 测试静态工厂方法
			var explosion = EnhancedParticleEffect.create_explosion(Vector2(300, 300), self)

			if explosion:
				print("✅ create_explosion()静态方法正常!")

				# 2秒后清理
				await get_tree().create_timer(2.0).timeout
				explosion.cleanup()
				print("✅ 测试完成，粒子效果已清理")
			else:
				print("❌ create_explosion()静态方法失败")