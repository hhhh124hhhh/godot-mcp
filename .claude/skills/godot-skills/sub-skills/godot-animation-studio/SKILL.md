---
name: godot-animation-studio
description: Godot 资源与动画创建专家，支持自然语言描述自动完成精灵导入、动画配置、特效制作、音效集成等资源工作
---

# Godot 动画工作室专家技能

> **重要提示**: 本技能的所有代码示例均基于 **Godot 4.5** 最佳实践，使用 GDScript 语法。
> 确保在 Godot 4.x 环境中使用，注意 AnimationPlayer 和 Tween 系统的新 API 变化。

## 技能概述

`godot-animation-studio` 是专门用于 Godot 游戏资源创建和动画制作的智能化技能，能够根据用户的自然语言描述自动完成精灵导入与切片、动画配置与优化、粒子特效制作、音效集成、资源管理等完整资源制作流程。

## 核心功能

### 🎨 精灵资源管理
- **智能导入**：自动导入和配置精灵图集
- **切片优化**：智能精灵切片和网格布局
- **格式转换**：支持多种图片格式转换和优化
- **批量处理**：批量导入和处理大量精灵资源

### 🎬 动画系统制作
- **AnimationPlayer配置**：创建和配置动画播放器
- **AnimationTree状态机**：复杂的动画状态机设计
- **骨骼动画**：2D骨骼动画和蒙皮系统
- **动画混合**：流畅的动画过渡和混合

### ✨ 粒子特效制作
- **GPUParticles2D/3D**：GPU粒子系统配置
- **CPUParticles2D/3D**：CPU粒子系统优化
- **粒子材质**：自定义粒子着色器和材质
- **特效组合**：复杂特效的组合和层级管理

### 🎵 音效资源集成
- **音频导入**：多种音频格式的导入和优化
- **音效管理**：音效库的分类和管理
- **3D音效**：空间音效和音频听者设置
- **动态音效**：程序化音效生成和调制

## 使用方法

### 角色动画制作
```
用户: "我需要为一个骑士角色制作待机、行走、攻击、受伤四种动画"
系统: 自动实现：
- 导入骑士精灵图集
- 智能切片和命名规范
- 创建AnimationPlayer和动画轨道
- 配置动画时长和过渡
- 创建AnimationTree状态机
- 添加动画事件和回调
```

### 粒子特效制作
```
用户: "创建一个火焰爆炸特效，包含火花、烟雾和冲击波"
系统: 智能生成：
- GPUParticles2D火焰粒子系统
- 烟雾粒子配置
- 冲击波扩散效果
- 粒子材质和着色器
- 多层级特效组合
- 音效同步集成
```

### UI动画制作
```
用户: "为按钮制作悬停、点击、禁用三种状态的动画"
系统: 全面开发：
- 按钮精灵状态导入
- 悬停缩放动画
- 点击弹跳效果
- 禁用淡出效果
- 平滑过渡配置
- 音效集成
```

### 环境动画制作
```
用户: "制作一个动态的森林场景，包含摇曳的树木和飘落的叶子"
系统: 完整实现：
- 树木摇摆动画
- 叶子飘落粒子
- 风力方向变化
- 动态光照效果
- 环境音效集成
```

## 工作流程

### 1. 资源分析
```bash
# 分析资源需求
- 识别动画类型和复杂度
- 确定资源格式和规格
- 评估制作时间和技术要求
```

### 2. 资源准备
```bash
# 准备资源素材
- 导入和优化图片资源
- 处理音频文件
- 创建基础材质和着色器
```

### 3. 动画制作
```bash
# 制作动画内容
- 创建动画时间轴
- 设置关键帧和曲线
- 配置动画过渡和混合
```

### 4. 集成测试
```bash
# 测试和优化
- 运行时性能测试
- 视觉效果调整
- 音画同步验证
```

## MCP 工具集成

### 资源管理工具
- `import_asset` - 导入资源文件
- `create_resource` - 创建动画和特效资源
- `configure_resource` - 配置资源属性
- `optimize_asset` - 优化资源大小和质量

### 动画工具
- `create_animation_player` - 创建动画播放器
- `create_animation_tree` - 创建动画状态机
- `add_animation_track` - 添加动画轨道
- `set_animation_key` - 设置动画关键帧

### 粒子系统工具
- `create_particles` - 创建粒子系统
- `configure_particles` - 配置粒子参数
- `create_particle_material` - 创建粒子材质
- `add_particle_emitter` - 添加粒子发射器

### 音频工具
- `import_audio` - 导入音频文件
- `create_audio_stream` - 创建音频流
- `configure_audio_bus` - 配置音频总线
- `set_3d_audio` - 设置3D音频效果

## 动画制作系统

### 2D角色动画
```gdscript
# 智能角色动画生成器
class_name CharacterAnimationGenerator extends Node
@export var character_name: String
@export var animation_types: Array[String] = ["idle", "walk", "run", "jump", "attack", "hurt"]

func generate_character_animations(sprite_sheet: Texture2D) -> Dictionary:
    var animations = {}
    var frame_size = Vector2(64, 64)

    # 自动切片精灵图集
    var sprite_frames = SpriteFrames.new()
    _slice_sprite_sheet(sprite_sheet, frame_size, sprite_frames)

    # 为每种动画类型创建AnimationPlayer资源
    for anim_type in animation_types:
        var animation = Animation.new()
        _create_character_animation(animation, anim_type, sprite_frames)
        animations[anim_type] = animation

    return animations

func _create_character_animation(animation: Animation, anim_type: String, frames: SpriteFrames) -> void:
    var track_index = animation.add_track(Animation.TYPE_VALUE)
    animation.track_set_path(track_index, Sprite2D.get_path() + ":frame")

    match anim_type:
        "idle":
            _create_idle_animation(animation, track_index, frames)
        "walk":
            _create_walk_animation(animation, track_index, frames)
        "attack":
            _create_attack_animation(animation, track_index, frames)
```

### 状态机系统
```gdscript
# 智能动画状态机生成器
class_name AnimationStateMachineGenerator extends Node
@export var state_transitions: Dictionary = {}

func create_state_machine(character_name: String) -> AnimationNodeStateMachine:
    var state_machine = AnimationNodeStateMachine.new()

    # 创建基础状态节点
    var idle_state = AnimationNodeAnimation.new()
    idle_state.animation = "idle"

    var walk_state = AnimationNodeAnimation.new()
    walk_state.animation = "walk"

    var attack_state = AnimationNodeAnimation.new()
    attack_state.animation = "attack"

    # 添加状态到状态机
    state_machine.add_node("Idle", idle_state)
    state_machine.add_node("Walk", walk_state)
    state_machine.add_node("Attack", attack_state)

    # 创建状态转换
    _create_transition(state_machine, "Idle", "Walk", "is_moving")
    _create_transition(state_machine, "Walk", "Idle", "!is_moving")
    _create_transition(state_machine, "Idle", "Attack", "attack_pressed")
    _create_transition(state_machine, "Attack", "Idle", "animation_finished")

    return state_machine
```

## 粒子特效系统

### 智能粒子生成
```gdscript
# 粒子特效生成器
class_name ParticleEffectGenerator extends Node

func create_explosion_effect(position: Vector2) -> GPUParticles2D:
    var particles = GPUParticles2D.new()
    particles.position = position
    particles.emitting = true
    particles.one_shot = true

    # 配置火焰粒子
    var fire_material = create_fire_material()
    particles.process_material = fire_material

    # 设置粒子参数
    particles.amount = 100
    particles.lifetime = 2.0
    particles.explosiveness = 0.8
    particles.initial_velocity_min = 100.0
    particles.initial_velocity_max = 300.0

    return particles

func create_fire_material() -> ParticleProcessMaterial:
    var material = ParticleProcessMaterial.new()

    # 颜色渐变
    var gradient = Gradient.new()
    gradient.add_color_point(0.0, Color.YELLOW)
    gradient.add_color_point(0.5, Color.ORANGE)
    gradient.add_color_point(1.0, Color.RED)

    material.color = gradient
    material.scale_min = 0.1
    material.scale_max = 0.3
    material.scale_random = 0.5

    return material
```

### 复杂特效组合
```gdscript
# 多层级特效系统
class_name CompositeEffectSystem extends Node
var effect_layers: Array[GPUParticles2D] = []

func create_magic_spell_effect(cast_position: Vector2, target_position: Vector2) -> Node2D:
    var effect_container = Node2D.new()

    # 创建魔法轨迹
    var trail_particles = create_magic_trail(cast_position, target_position)
    effect_container.add_child(trail_particles)

    # 创建爆炸效果
    var explosion_particles = create_magic_explosion(target_position)
    effect_container.add_child(explosion_particles)

    # 创建光环效果
    var aura_particles = create_magic_aura(target_position)
    effect_container.add_child(aura_particles)

    return effect_container

func create_magic_trail(start: Vector2, end: Vector2) -> GPUParticles2D:
    var trail = GPUParticles2D.new()
    trail.emitting = true

    # 配置轨迹粒子
    var trail_material = ParticleProcessMaterial.new()
    trail_material.direction = Vector3(end - start, 0).normalized()
    trail_material.initial_velocity_min = 200.0
    trail_material.initial_velocity_max = 300.0

    # 紫色魔法粒子
    var gradient = Gradient.new()
    gradient.add_color_point(0.0, Color.MAGENTA)
    gradient.add_color_point(1.0, Color.PURPLE)
    trail_material.color = gradient

    trail.process_material = trail_material
    return trail
```

## 音效集成系统

### 智能音效管理
```gdscript
# 音效管理器
class_name AudioManager extends Node
@export var audio_bus_layout: AudioBusLayout

var sound_library: Dictionary = {}
var music_player: AudioStreamPlayer
var sound_players: Array[AudioStreamPlayer]

func _ready() -> void:
    _setup_audio_bus()
    _create_sound_players()
    _load_default_sounds()

func play_sound(sound_name: String, position: Vector2 = Vector2.ZERO) -> void:
    var audio_stream = sound_library.get(sound_name)
    if not audio_stream:
        push_warning("Sound not found: " + sound_name)
        return

    var player = _get_available_player()
    player.stream = audio_stream
    player.play()

    # 如果指定了位置，使用2D音效
    if position != Vector2.ZERO:
        var audio_player_2d = AudioStreamPlayer2D.new()
        audio_player_2d.stream = audio_stream
        audio_player_2d.global_position = position

        # ✅ 正确：安全检查场景树和添加节点
        if get_tree() and get_tree().current_scene:
            get_tree().current_scene.add_child(audio_player_2d)
            audio_player_2d.play()
            await audio_player_2d.finished
            # ✅ 正确：使用延迟删除避免在回调中直接删除
            audio_player_2d.call_deferred("queue_free")
        else:
            push_warning("场景树未准备就绪，无法播放2D音效")

func play_footstep_sound(surface_type: String) -> void:
    var footstep_variants = sound_library.get("footstep_" + surface_type, [])
    if footstep_variants.size() > 0:
        var random_sound = footstep_variants[randi() % footstep_variants.size()]
        play_sound(random_sound)
```

### 动态音效生成
```gdscript
# 程序化音效生成器
class_name ProceduralAudioGenerator extends Node

func generate_laser_sound() -> AudioStream:
    var generator = AudioStreamGenerator.new()
    generator.sample_rate = 44100
    generator.buffer_length = 0.5

    var playback = generator.instantiate_playback()
    var frames_to_fill = int(generator.sample_rate * generator.buffer_length)

    # 生成激光音效（频率扫描）
    for i in range(frames_to_fill):
        var t = float(i) / generator.sample_rate
        var frequency = 800.0 - 400.0 * t  # 从800Hz扫描到400Hz
        var amplitude = exp(-t * 3.0)  # 指数衰减

        var sample = amplitude * sin(2.0 * PI * frequency * t)
        playback.push_frame(Vector2.ONE * sample)

    return generator

func generate_impact_sound(velocity: float) -> AudioStream:
    var generator = AudioStreamGenerator.new()
    generator.sample_rate = 44100
    generator.buffer_length = 0.2

    var playback = generator.instantiate_playback()
    var frames_to_fill = int(generator.sample_rate * generator.buffer_length)

    # 基于速度生成冲击音效
    var base_frequency = clamp(velocity * 10.0, 100.0, 1000.0)

    for i in range(frames_to_fill):
        var t = float(i) / generator.sample_rate
        var amplitude = exp(-t * 10.0)  # 快速衰减
        var frequency = base_frequency + randf_range(-50.0, 50.0)

        var sample = amplitude * (sin(2.0 * PI * frequency * t) + randf_range(-0.1, 0.1))
        playback.push_frame(Vector2.ONE * sample)

    return generator
```

## 资源优化系统

### 智能压缩
```gdscript
# 资源优化器
class_name AssetOptimizer extends Node

func optimize_texture(texture: Texture2D, target_size: Vector2) -> Texture2D:
    var image = texture.get_image()

    # 调整尺寸
    image.resize(target_size.x, target_size.y, Image.INTERPOLATE_LANCZOS)

    # 压缩格式
    var compressed_texture = ImageTexture.new()
    compressed_texture.set_image(image)

    return compressed_texture

func optimize_audio(audio_stream: AudioStream) -> AudioStream:
    if audio_stream is AudioStreamMP3:
        # 转换为OGG格式以获得更好的压缩比
        var ogg_stream = AudioStreamOggVorbis.new()
        # 转换逻辑...
        return ogg_stream

    return audio_stream
```

### 批量处理
```gdscript
# 批量资源处理器
class_name BatchAssetProcessor extends Node

func process_sprite_sheets(input_folder: String, output_folder: String) -> void:
    var dir = DirAccess.open(input_folder)
    if not dir:
        push_error("Cannot open input folder: " + input_folder)
        return

    dir.list_dir_begin()
    var file_name = dir.get_next()

    while file_name != "":
        if file_name.ends_with(".png"):
            var input_path = input_folder + "/" + file_name
            var output_path = output_folder + "/" + file_name.get_basename() + ".tres"

            _process_sprite_sheet(input_path, output_path)

        file_name = dir.get_next()

func _process_sprite_sheet(input_path: String, output_path: String) -> void:
    var texture = load(input_path)
    var sprite_frames = SpriteFrames.new()

    # 自动检测和切片
    var frame_size = _detect_frame_size(texture)
    _slice_texture(texture, frame_size, sprite_frames)

    # 保存资源
    ResourceSaver.save(sprite_frames, output_path)
```

## 智能特性

### 自动化工作流
- **批量处理**：一键处理大量资源文件
- **智能检测**：自动检测精灵尺寸和动画帧
- **格式优化**：自动选择最优的资源格式
- **质量平衡**：在质量和大小之间找到最佳平衡

### AI辅助制作
- **动画预测**：基于角色类型预测动画需求
- **特效推荐**：根据场景推荐合适的特效
- **音效匹配**：自动匹配音效和视觉效果
- **风格统一**：确保所有资源风格一致

### 实时预览
- **即时预览**：制作过程中实时预览效果
- **性能监控**：监控资源对性能的影响
- **版本对比**：对比不同版本的效果差异
- **团队协作**：多人协作制作和审核

## 示例实现

### 完整角色动画系统
```gdscript
# 智能角色动画系统
class_name SmartCharacterAnimationSystem extends Node
@export var character_data: CharacterData

func generate_complete_animation_system() -> Node:
    var animation_container = Node.new()
    animation_container.name = character_data.character_name + "_Animations"

    # 创建精灵帧资源
    var sprite_frames = create_sprite_frames()

    # 创建动画播放器
    var animation_player = create_animation_player(sprite_frames)
    animation_container.add_child(animation_player)

    # 创建动画状态机
    var animation_tree = create_animation_tree(sprite_frames)
    animation_container.add_child(animation_tree)

    # 创建音效管理
    var audio_manager = create_character_audio_manager()
    animation_container.add_child(audio_manager)

    return animation_container

func create_sprite_frames() -> SpriteFrames:
    var frames = SpriteFrames.new()

    for animation_name in character_data.animations.keys():
        var animation_data = character_data.animations[animation_name]
        _load_animation_frames(frames, animation_name, animation_data)

    return frames
```

## 质量保证

### 视觉质量
- **帧率一致性**：确保动画帧率稳定
- **颜色准确性**：保持颜色还原准确
- **边缘处理**：优化精灵边缘和抗锯齿
- **视觉一致性**：确保整体视觉风格统一

### 技术质量
- **性能优化**：优化资源加载和运行性能
- **内存管理**：合理控制内存使用
- **兼容性**：确保跨平台兼容性
- **可扩展性**：便于后续添加新资源

### 用户体验
- **加载速度**：优化资源加载时间
- **流畅度**：确保动画和特效流畅
- **音画同步**：精确的音画同步
- **响应速度**：快速的交互响应

## 使用限制和注意事项

### 技术限制
- **文件大小**：大型资源文件可能影响性能
- **格式支持**：某些特殊格式可能不兼容
- **硬件要求**：复杂特效需要较高硬件配置

### 最佳实践
- **资源优化**：定期优化和压缩资源
- **备份管理**：做好资源文件的备份
- **版本控制**：使用版本控制管理资源

## 故障排除

### 常见问题
1. **动画卡顿**：检查帧率和资源大小
2. **特效不显示**：验证粒子系统配置
3. **音效播放失败**：检查音频文件格式
4. **资源加载慢**：优化资源大小和格式

### 调试技巧
- 使用Godot的调试工具
- 检查控制台错误信息
- 监控性能指标
- 逐步排除故障

## 更新日志

### v1.0.0 (当前版本)
- 基础动画制作功能
- 粒子特效系统
- 音效集成功能
- 资源优化工具

### 计划功能
- AI动画生成
- 实时协作制作
- 更多特效模板
- 高级音效处理

## Camera2D与动画系统集成最佳实践

### 🎬 角色显示问题诊断系统
```gdscript
# 角色可见性诊断器 - 解决角色看不到的问题
class_name CharacterVisibilityDiagnostic extends Node

@export var character: AnimatedSprite2D
@export var camera: Camera2D
@export var diagnostic_enabled: bool = true

func run_diagnostic_check() -> void:
    print("=== 角色可见性诊断开始 ===")

    # 1. 检查AnimatedSprite2D配置
    _check_animated_sprite_configuration()

    # 2. 检查SpriteFrames资源
    _check_sprite_frames_resource()

    # 3. 检查相机配置
    _check_camera_configuration()

    # 4. 检查世界坐标和视野关系
    _check_world_coordinates()

    print("=== 角色可见性诊断完成 ===")

func _check_animated_sprite_configuration() -> void:
    if not character:
        print("❌ 错误: AnimatedSprite2D引用为空")
        return

    print("✅ AnimatedSprite2D配置正常")
    print("   - 位置:", character.global_position)
    print("   - 可见性:", character.visible)

    if character.sprite_frames:
        print("✅ SpriteFrames资源已加载")
        print("   - 可用动画:", character.sprite_frames.get_animation_names())
    else:
        print("❌ 错误: SpriteFrames资源为空")

func _check_camera_configuration() -> void:
    if not camera:
        print("❌ 错误: Camera2D引用为空")
        return

    print("✅ Camera2D配置正常")
    print("   - 位置:", camera.global_position)
    print("   - 缩放:", camera.zoom)
    print("   - 平滑跟随:", camera.position_smoothing_enabled)
```

### 📷 智能相机跟随系统
```gdscript
# 动画驱动的相机系统
class_name AnimationDrivenCameraSystem extends Node
@export var target_character: AnimatedSprite2D
@export var camera: Camera2D
@export var follow_speed: float = 5.0

# 动画状态对应的相机参数
var animation_camera_settings = {
    "idle": {"zoom": Vector2(1.0, 1.0), "offset": Vector2(0, -80)},
    "walk": {"zoom": Vector2(1.1, 1.1), "offset": Vector2(0, -90)},
    "attack": {"zoom": Vector2(1.2, 1.2), "offset": Vector2(0, -70)}
}

func _process(delta):
    if target_character and camera:
        _update_camera_follow(delta)

func _update_camera_follow(delta: float) -> void:
    var current_anim = target_character.animation
    var settings = animation_camera_settings.get(current_anim, animation_camera_settings["idle"])

    # 平滑跟随
    var target_position = target_character.global_position + settings.offset
    camera.global_position = camera.global_position.lerp(target_position, follow_speed * delta)
    camera.zoom = camera.zoom.lerp(settings.zoom, follow_speed * delta * 0.5)
```

### 🛠️ 常见问题解决方案

#### 问题1: 角色掉落到屏幕外
```gdscript
# 修复角色物理和位置
func fix_character_physics(character: CharacterBody2D):
    # 设置合理的初始位置
    character.position = Vector2(character.position.x, 145)  # 地面以上

    # 配置物理参数
    if character.has_method("set_gravity_scale"):
        character.set_gravity_scale(1.0)

    # 确保启用碰撞
    character.set_collision_layer_value(1, true)
    character.set_collision_mask_value(1, true)
```

#### 问题2: 相机不跟随角色
```gdscript
# 修复相机跟随
func fix_camera_follow(camera: Camera2D, target: Node2D):
    camera.position_smoothing_enabled = true
    camera.position_smoothing_speed = 5.0

    # 设置相机边界
    camera.limit_left = -1024
    camera.limit_right = 1024
    camera.limit_top = -600
    camera.limit_bottom = 600
```

#### 问题3: SpriteFrames资源缺失
```gdscript
# 修复SpriteFrames资源
func fix_sprite_frames(character: AnimatedSprite2D):
    if not character.sprite_frames:
        # 创建默认SpriteFrames
        var frames = SpriteFrames.new()

        # 添加基本动画
        _add_default_animations(frames)

        character.sprite_frames = frames

func _add_default_animations(frames: SpriteFrames):
    # 使用颜色块作为占位符纹理
    var placeholder_texture = _create_colored_texture(Color.RED, Vector2(64, 64))

    # 添加idle动画
    frames.add_animation("idle")
    frames.add_frame("idle", placeholder_texture)

    # 添加walk动画
    frames.add_animation("walk")
    frames.add_frame("walk", placeholder_texture)
    frames.add_frame("walk", placeholder_texture)

func _create_colored_texture(color: Color, size: Vector2) -> ImageTexture:
    var image = Image.create(size.x, size.y, false, Image.FORMAT_RGB8)
    image.fill(color)
    var texture = ImageTexture.new()
    texture.set_image(image)
    return texture
```

### 🎯 调试工具
```gdscript
# 实时调试显示
class_name AnimationDebugDisplay extends Control
@export var character: AnimatedSprite2D
@export var camera: Camera2D

func _process(delta):
    queue_redraw()

func _draw():
    if not character or not camera:
        return

    # 绘制角色边界框
    var char_rect = Rect2(character.global_position - camera.global_position + size/2,
                          character.sprite_frames.get_frame_texture(character.animation, 0).get_size())
    draw_rect(char_rect, Color.GREEN, false, 2.0)

    # 绘制相机视野中心
    var center = size / 2
    draw_circle(center, 5.0, Color.RED)

    # 显示状态信息
    var debug_text = "角色: %s\n位置: %s\n动画: %s\n相机: %s" % [
        character.name,
        character.global_position,
        character.animation,
        camera.global_position
    ]
    draw_string(ThemeDB.fallback_font, Vector2(10, 30), debug_text, HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color.WHITE)
```

---

**技能状态**: ✅ 可用
**最后更新**: 2025-11-09
**兼容性**: Godot 4.5+
**新增功能**: Camera2D集成、角色显示问题诊断
**依赖**: Godot MCP 工具集 + 动画制作知识