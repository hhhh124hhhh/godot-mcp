class_name GameManager
extends Node

# 游戏状态变量
var score = 0
var game_running = true
var bubble_scene = preload("res://Bubble.tscn")
var spawn_timer = 0
var spawn_interval = 1.0  # 每秒生成一个泡泡
var min_speed = -80
var max_speed = -150
var min_size = 20
var max_size = 50

func _ready():
	# 初始化随机数生成器
	randomize()
	
	# 设置游戏窗口大小
	DisplayServer.window_set_size(Vector2(800, 600))
	
	# 开始游戏
	start_game()

func _process(delta):
	if game_running:
		# 更新生成计时器
		spawn_timer += delta
		
		# 生成新泡泡
		if spawn_timer >= spawn_interval:
			spawn_bubble()
			spawn_timer = 0
			
			# 随着游戏进行，增加生成速度
			spawn_interval = max(0.3, spawn_interval - 0.01)

func start_game():
	# 重置游戏状态
	score = 0
	game_running = true
	spawn_timer = 0
	spawn_interval = 1.0
	
	# 更新分数显示
	update_score()

func spawn_bubble():
	# 实例化泡泡场景
	var bubble_instance = bubble_scene.instantiate()
	add_child(bubble_instance)
	
	# 设置泡泡属性
	var bubble = bubble_instance as Bubble
	
	# 随机大小
	var size = randf_range(min_size, max_size)
	bubble.set_size(size)
	
	# 随机水平位置（确保在屏幕内）
	var screen_width = 800
	var x_pos = randf_range(size, screen_width - size)
	bubble.position = Vector2(x_pos, 600 + size)
	
	# 随机速度（向上移动）
	var speed = randf_range(min_speed, max_speed)
	bubble.speed = Vector2(0, speed)
	
	# 连接泡泡被戳破的信号
	bubble.connect("popped", self, "_on_bubble_popped")
	# 连接泡泡到达顶部的信号
	bubble.connect("reached_top", self, "_on_bubble_reached_top")

func _on_bubble_popped(points):
	# 更新分数
	score += points
	update_score()

func _on_bubble_reached_top():
	# 如果有泡泡到达顶部，游戏结束
	end_game()

func update_score():
	# 更新分数显示标签
	var score_label = get_node("/root/ScoreLabel")
	if score_label:
		score_label.text = "分数: " + str(score)

func end_game():
	# 结束游戏
	game_running = false
	
	# 显示游戏结束信息
	var score_label = get_node("/root/ScoreLabel")
	if score_label:
		score_label.text = "分数: " + str(score) + "\n游戏结束！"
