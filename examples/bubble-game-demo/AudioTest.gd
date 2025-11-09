extends Node

# 音效测试脚本
class_name AudioTest

# 测试所有音效
func test_all_audio_effects() -> void:
	print("音效系统测试开始")

	# 查找游戏管理器
	var game_manager = get_game_manager()
	if not game_manager:
		print("错误：未找到游戏管理器")
		return

	if not game_manager.audio_manager:
		print("错误：未找到音频管理器")
		return

	print("找到音频管理器，开始测试...")

	# 测试点击音效
	test_click_sound(game_manager.audio_manager)

	# 测试爆炸音效
	test_pop_sound(game_manager.audio_manager)

	print("音效系统测试完成")

# 测试点击音效
func test_click_sound(audio_manager: AudioManager) -> void:
	print("🔊 测试点击音效...")
	audio_manager.play_click()
	print("   ✅ 点击音效已播放（应该听到高音调的'滴'声）")

# 测试爆炸音效
func test_pop_sound(audio_manager: AudioManager) -> void:
	print("🔊 测试爆炸音效...")
	audio_manager.play_pop()
	print("   ✅ 爆炸音效已播放（应该听到低沉的'噗'声）")

# 查找游戏管理器
func get_game_manager() -> Node:
	# 方法1：通过组查找（最安全的方式）
	var managers = get_tree().get_nodes_in_group("game_manager")
	if managers.size() > 0:
		return managers[0]

	# 方法2：通过场景树查找（备用方式）
	if get_tree().current_scene:
		var game_manager = get_tree().current_scene.find_child("GameManager", true, false)
		if game_manager:
			return game_manager

	push_warning("AudioTest: 无法找到游戏管理器")
	return null

# 测试音效参数调整
func test_volume_adjustment(audio_manager: AudioManager) -> void:
	print("测试音量调节...")

	# 低音量测试
	audio_manager.set_sfx_volume(0.3)
	audio_manager.play_click()
	print("低音量点击音效已播放")

	# 高音量测试
	audio_manager.set_sfx_volume(1.0)
	audio_manager.play_click()
	print("高音量点击音效已播放")

	# 恢复正常音量
	audio_manager.set_sfx_volume(0.8)
