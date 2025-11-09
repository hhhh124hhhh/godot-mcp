extends Node

# 增强音频管理器 - 多层次音效系统
class_name AudioManager

# 音频播放器
var audio_player: AudioStreamPlayer
var score_player: AudioStreamPlayer  # 专门的分数音效播放器

# 音效生成器
var pop_generator: AudioStreamGenerator
var score_generator: AudioStreamGenerator

# 音量控制
var master_volume: float = 1.0  # 提高主音量
var sfx_volume: float = 1.0

# 音效参数
const SAMPLE_RATE: float = 44100.0
const POP_MAIN_FREQ: float = 150.0    # 主爆破音（更低频，更响亮）
const POP_IMPACT_FREQ: float = 400.0  # 冲击音
const POP_FRAGMENT_FREQ: float = 800.0 # 碎片音
const SCORE_FREQS: Array[float] = [523.25, 659.25]  # C5 + E5 和弦

const POP_DURATION: float = 0.3  # 延长爆破时间
const SCORE_DURATION: float = 0.2

func _ready() -> void:
	# 创建音频播放器
	audio_player = AudioStreamPlayer.new()
	score_player = AudioStreamPlayer.new()
	add_child(audio_player)
	add_child(score_player)

	# 初始化音效生成器
	setup_sound_generators()

	print("AudioManager: 增强音效系统初始化完成")

# 设置音效生成器
func setup_sound_generators() -> void:
	# 爆破音效生成器
	pop_generator = AudioStreamGenerator.new()
	pop_generator.mix_rate = SAMPLE_RATE
	pop_generator.buffer_length = POP_DURATION

	# 分数音效生成器
	score_generator = AudioStreamGenerator.new()
	score_generator.mix_rate = SAMPLE_RATE
	score_generator.buffer_length = SCORE_DURATION
	
	# 预先创建音频流，避免首次播放延迟
	audio_player.stream = pop_generator
	score_player.stream = score_generator
	
	print("AudioManager: 音频系统初始化完成")

# 增强的爆破音效（多层次混合）
func play_pop() -> void:
	# 增强的爆破音效（多层次混合）
	# 确保音频生成器和播放器已初始化
	if not pop_generator or not audio_player:
		print("AudioManager: 无法播放爆破音效，音频生成器或播放器未初始化")
		return
	
	# 主爆破（低频，响亮）
	_play_pop_layer(POP_MAIN_FREQ, 0.9, 0.4, "heavy")

	# 连续播放冲击音（中频，清脆）
	_play_pop_layer(POP_IMPACT_FREQ, 0.6, 0.15, "sharp")

	# 连续播放碎片音（高频，噪音）
	_play_noise_fragment(0.5, 0.2)
	
	print("AudioManager: 播放增强爆破音效")

# 播放点击音效（简短爆破声）
func play_click() -> void:
	# 简短的点击声，使用中等频率
	_play_pop_layer(600.0, 0.4, 0.08, "sharp")

# 播放分数音效（正向激励）
func play_score() -> void:
	_play_score_chord(SCORE_FREQS, 0.8)

# 播放爆破音效层次
func _play_pop_layer(frequency: float, volume: float, duration: float, layer_type: String) -> void:
	if not audio_player or not pop_generator:
		return

	audio_player.stream = pop_generator
	audio_player.volume_db = linear_to_db_custom(master_volume * sfx_volume * volume)
	audio_player.play()

	var playback = audio_player.get_stream_playback()
	if playback:
		if layer_type == "heavy":
			_generate_heavy_pop_data(playback, frequency, duration)
		elif layer_type == "sharp":
			_generate_sharp_pop_data(playback, frequency, duration)

# 播放噪音碎片音效
func _play_noise_fragment(volume: float, duration: float) -> void:
	if not audio_player or not pop_generator:
		return

	audio_player.stream = pop_generator
	audio_player.volume_db = linear_to_db_custom(master_volume * sfx_volume * volume)
	audio_player.play()

	var playback = audio_player.get_stream_playback()
	if playback:
		_generate_noise_fragment_data(playback, duration)

# 播放分数和弦音效
func _play_score_chord(frequencies: Array[float], volume: float) -> void:
	if not score_player or not score_generator:
		return

	score_player.stream = score_generator
	score_player.volume_db = linear_to_db_custom(master_volume * sfx_volume * volume)
	score_player.play()

	var playback = score_player.get_stream_playback()
	if playback:
		_generate_chord_data(playback, frequencies, SCORE_DURATION)

# 生成重低频爆破数据
func _generate_heavy_pop_data(playback: AudioStreamPlayback, frequency: float, duration: float) -> void:
	var frames_to_fill: int = int(duration * SAMPLE_RATE)

	for i in range(frames_to_fill):
		var time: float = float(i) / SAMPLE_RATE
		var envelope: float = _get_heavy_pop_envelope(time, duration)

		# 低频正弦波 + 低频噪音混合
		var sine_component: float = sin(2.0 * PI * frequency * time) * 0.7
		var noise_component: float = (randf() - 0.5) * 0.3
		var sample: float = (sine_component + noise_component) * envelope

		playback.push_frame(Vector2(sample, sample))

# 生成清脆冲击音数据
func _generate_sharp_pop_data(playback: AudioStreamPlayback, frequency: float, duration: float) -> void:
	var frames_to_fill: int = int(duration * SAMPLE_RATE)

	for i in range(frames_to_fill):
		var time: float = float(i) / SAMPLE_RATE
		var envelope: float = _get_sharp_pop_envelope(time, duration)

		# 高频正弦波
		var sample: float = sin(2.0 * PI * frequency * time) * envelope

		playback.push_frame(Vector2(sample, sample))

# 生成噪音碎片数据
func _generate_noise_fragment_data(playback: AudioStreamPlayback, duration: float) -> void:
	var frames_to_fill: int = int(duration * SAMPLE_RATE)

	for i in range(frames_to_fill):
		var time: float = float(i) / SAMPLE_RATE
		var envelope: float = _get_noise_envelope(time, duration)

		# 高频噪音
		var sample: float = (randf() - 0.5) * 2.0 * envelope

		playback.push_frame(Vector2(sample, sample))

# 生成和弦数据
func _generate_chord_data(playback: AudioStreamPlayback, frequencies: Array[float], duration: float) -> void:
	var frames_to_fill: int = int(duration * SAMPLE_RATE)

	for i in range(frames_to_fill):
		var time: float = float(i) / SAMPLE_RATE
		var envelope: float = _get_score_envelope(time, duration)

		# 混合多个频率形成和弦
		var sample: float = 0.0
		for freq in frequencies:
			sample += sin(2.0 * PI * freq * time) * 0.5

		sample *= envelope * 0.6  # 调整音量

		playback.push_frame(Vector2(sample, sample))

# 重低频爆破包络（缓慢起音，较长持续时间）
func _get_heavy_pop_envelope(time: float, duration: float) -> float:
	var attack_time: float = 0.02   # 20ms起音
	var sustain_time: float = 0.1   # 100ms持续
	var decay_time: float = duration - sustain_time

	if time < attack_time:
		return time / attack_time
	elif time < sustain_time:
		return 1.0
	else:
		var decay_progress: float = (time - sustain_time) / decay_time
		return 1.0 - decay_progress

# 清脆冲击包络（快速起音和衰减）
func _get_sharp_pop_envelope(time: float, duration: float) -> float:
	var attack_time: float = 0.001   # 1ms快速起音
	var decay_time: float = 0.05    # 50ms快速衰减

	if time < attack_time:
		return time / attack_time
	else:
		var decay_progress: float = (time - attack_time) / (duration - attack_time)
		return (1.0 - decay_progress) * 0.8

# 噪音包络（快速衰减）
func _get_noise_envelope(time: float, duration: float) -> float:
	return exp(-time * 8.0)  # 指数衰减

# 分数音效包络（柔和起音，缓慢衰减）
func _get_score_envelope(time: float, duration: float) -> float:
	var attack_time: float = 0.01   # 10ms起音
	var decay_time: float = duration - 0.05

	if time < attack_time:
		return time / attack_time
	elif time < decay_time:
		return 1.0
	else:
		return exp(-(time - decay_time) * 15.0)

# 设置主音量
func set_master_volume(volume: float) -> void:
	master_volume = clamp(volume, 0.0, 1.0)

# 设置音效音量
func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)

# 线性转分贝
func linear_to_db_custom(linear: float) -> float:
	if linear <= 0.001:
		return -80.0
	# 使用GDScript内置的log函数
	return 20.0 * log(linear)

# 测试所有增强音效
func test_all_enhanced_sounds() -> void:
	print("增强音效系统测试开始")

	# 测试爆破音效
	play_pop()
	print("播放增强爆破音效")

	# 测试分数音效
	play_score()
	print("播放分数音效")

	print("增强音效系统测试完成")
