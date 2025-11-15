---
name: chinese-dev-guide
description: 为中文开发者提供完整的项目本地化、环境配置和开发工作流指导，确保中英文双语环境下的最佳开发体验
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash
---

# 中文开发指南技能

## 指令

当用户是中文开发者或需要中文环境支持时，自动提供本地化配置和开发指导：

### 触发条件
- 用户使用中文进行交流
- 询问中文相关的配置问题
- 需要中文化支持或本地化设置
- 遇到中文编码、显示或输入问题

## MCP工具使用说明

此技能主要使用以下MCP工具：
- **Bash MCP** - 执行系统命令和环境配置
- **Read/Write/Edit MCP** - 读取、写入和编辑配置文件
- **Context7 MCP** - 查询中文开发相关的最佳实践和文档

### MCP调用方式
```bash
# 使用Bash MCP执行系统配置
await bashMCP.execute('export LANG=zh_CN.UTF-8');

# 使用Read/Write MCP编辑配置文件
await writeMCP.editFile('.vscode/settings.json', {
  "files.encoding": "utf8",
  "editor.fontFamily": "'Microsoft YaHei', monospace"
});

# 使用Context7 MCP查询中文开发资源
await context7MCP.search('中文开发环境配置最佳实践');
```

## 系统环境配置

### 1. 终端和Shell中文配置
**目标**: 确保命令行环境正确支持中文显示和输入

**执行步骤**:
```bash
# 检查当前语言环境
locale

# 设置中文UTF-8环境 (Ubuntu/Debian)
sudo locale-gen zh_CN.UTF-8
sudo update-locale LANG=zh_CN.UTF-8

# 添加到shell配置文件
echo 'export LANG=zh_CN.UTF-8' >> ~/.bashrc
echo 'export LC_ALL=zh_CN.UTF-8' >> ~/.bashrc
echo 'export LANGUAGE=zh_CN:zh:en_US:en' >> ~/.bashrc

# 重新加载配置
source ~/.bashrc
```

### 2. Git中文支持配置
**目标**: 确保Git能够正确处理中文文件名和提交信息

**执行步骤**:
```bash
# 设置中文编码支持
git config --global i18n.commitencoding utf-8
git config --global i18n.logoutputencoding utf-8
git config --global core.quotepath false

# 创建中文提交模板
cat > ~/.gitmessage.txt << 'EOF'
# 中文提交信息模板
#
# 类型: feat(新功能), fix(修复), docs(文档), style(格式), refactor(重构), test(测试), chore(构建)
#
# 示例:
# feat(粒子系统): 添加彩色爆炸效果
# fix(兼容性): 修复Godot 4.x API兼容性问题
# docs(README): 更新中文安装说明
#
类型(影响范围): 简短描述

详细描述 (可选):
-
-

相关问题 (可选):
EOF

git config --global commit.template ~/.gitmessage.txt
```

### 3. 编辑器中文化配置

#### VS Code配置
**目标**: 配置VS Code完美支持中文开发

**配置文件位置**: `.vscode/settings.json`
```json
{
  "files.encoding": "utf8",
  "files.autoGuessEncoding": true,
  "editor.fontFamily": "'Microsoft YaHei', 'Source Code Pro', 'Consolas', monospace",
  "editor.fontSize": 14,
  "editor.lineHeight": 1.6,
  "terminal.integrated.fontFamily": "'Microsoft YaHei', 'Consolas', monospace",
  "terminal.integrated.fontSize": 13,
  "git.enableSmartCommit": true,
  "git.postCommitCommand": "none",
  "git.showInlineOpenFileAction": false,
  "[gdscript]": {
    "editor.fontFamily": "'Microsoft YaHei', 'Consolas', monospace",
    "editor.fontSize": 14
  },
  "explorer.confirmDelete": false,
  "workbench.colorTheme": "Default Dark+",
  "workbench.iconTheme": "material-icon-theme"
}
```

#### Godot编辑器配置
**目标**: 配置Godot编辑器支持中文界面和输入

**配置步骤**:
1. 打开Godot编辑器
2. 进入 `编辑器 -> 编辑器设置 -> 界面`
3. 设置 `编辑器语言` 为 `Chinese (Simplified)`
4. 配置 `字体` 为支持中文的字体

## MCP工具中文使用优化

### Context7中文查询映射
**目标**: 优化中文技术术语的英文查询效果

**关键词映射表**:
```javascript
const chineseKeywordMappings = {
  "粒子系统": ["Godot particle system", "GPUParticles2D", "ParticleProcessMaterial", "particle effects"],
  "动画系统": ["Godot animation system", "AnimationPlayer", "tween", "animation blending"],
  "物理引擎": ["Godot physics engine", "RigidBody2D", "CollisionShape2D", "physics materials"],
  "场景管理": ["Godot scene management", "SceneTree", "node hierarchy", "scene switching"],
  "信号系统": ["Godot signal system", "connect signals", "event handling", "signal parameters"],
  "输入处理": ["Godot input handling", "InputEvent", "input mapping", "input actions"],
  "UI界面": ["Godot UI system", "Control nodes", "interface design", "GUI layout"],
  "资源管理": ["Godot resource management", "ResourceLoader", "preload", "resource paths"],
  "性能优化": ["Godot performance optimization", "profiling", "optimization techniques"],
  "调试工具": ["Godot debugging tools", "print statements", "debugger", "remote debugging"],
  "脚本编程": ["Godot scripting", "GDScript", "script organization", "code patterns"],
  "材质着色": ["Godot materials shaders", "ShaderLanguage", "visual shaders", "material properties"],
  "音频系统": ["Godot audio system", "AudioStreamPlayer", "sound effects", "music management"],
  "网络功能": ["Godot networking", "HTTP requests", "multiplayer", "WebSocket"],
  "平台导出": ["Godot export templates", "platform export", "HTML5 export", "mobile builds"]
};
```

### 自动查询转换
```javascript
function enhanceChineseQuery(userQuery) {
  let enhancedQuery = userQuery;

  // 检测中文关键词并添加英文对应
  for (const [chinese, englishList] of Object.entries(chineseKeywordMappings)) {
    if (userQuery.includes(chinese)) {
      // 添加主要英文术语
      enhancedQuery += ` ${englishList[0]}`;
      // 添加其他相关术语作为备选
      enhancedQuery += ` OR ${englishList.slice(1).join(' OR ')}`;
      break;
    }
  }

  return enhancedQuery;
}
```

## 中文开发工作流

### 1. 项目结构中文化
**目标**: 创建符合中文习惯的项目目录结构

**执行步骤**:
```bash
# 创建中文友好的项目结构
mkdir -p "我的Godot项目"/{场景,脚本,资源,文档,测试,配置}

# 创建中文README
cat > "我的Godot项目/README.md" << 'EOF'
# 我的项目名称

## 项目简介
这是一个使用Godot引擎开发的游戏项目，支持中英文双语环境。

## 功能特性
- 🎮 完整的游戏玩法机制
- 🎨 精美的视觉效果和动画
- 🎵 动态音效和背景音乐
- 🌐 多语言支持 (中文/英文)
- 📱 跨平台兼容 (PC/移动端/网页)

## 技术栈
- **游戏引擎**: Godot 4.2+
- **脚本语言**: GDScript
- **开发工具**: Claude Code + MCP工具链
- **版本控制**: Git
- **自动化**: Context7文档研究

## 开发环境要求
- Godot编辑器 4.2+
- Node.js 18+ (MCP服务器)
- Git 2.30+
- 支持UTF-8的终端和编辑器

## 快速开始
1. 克隆项目到本地
2. 在Godot编辑器中打开 `project.godot`
3. 启动MCP服务器: `npm run dev`
4. 开始游戏开发！

## 项目结构
```
我的Godot项目/
├── 场景/           # .tscn场景文件
├── 脚本/           # .gd脚本文件
├── 资源/           # 图片、音频、字体等资源
├── 文档/           # 设计文档、API文档
├── 测试/           # 单元测试、集成测试
└── 配置/           # 项目配置、导出设置
```

## 贡献指南
欢迎提交Issue和Pull Request！

## 许可证
MIT License
EOF
```

### 2. 中文代码注释规范
**目标**: 建立清晰一致的中文注释标准

**注释规范示例**:
```gdscript
# 玩家角色类 - 处理玩家的移动、动画和交互逻辑
class_name 玩家角色
extends CharacterBody2D

# === 常量定义 ===
const 移动速度: float = 300.0    # 水平移动速度 (像素/秒)
const 跳跃速度: float = -400.0   # 跳跃初始速度 (像素/秒)
const 重力加速度: float = 980.0  # 重力加速度 (像素/秒²)

# === 组件引用 ===
@onready var 动画播放器: AnimationPlayer = $AnimationPlayer
@onready var 精子: Sprite2D = $Sprite2D
@onready var 碰撞形状: CollisionShape2D = $CollisionShape2D

# === 状态变量 ===
var 正在跳跃: bool = false      # 当前是否处于跳跃状态
var 面向右侧: bool = true       # 当前角色朝向 (true=右侧, false=左侧)
var 当前生命值: int = 100       # 当前生命值
var 无敌时间: float = 0.0       # 剩余无敌时间 (秒)

# === 核心方法 ===
func _ready() -> void:
    """初始化玩家角色"""
    print("玩家角色初始化完成")
    重置玩家状态()

func _physics_process(delta: float) -> void:
    """每帧物理处理 - 处理移动和跳跃逻辑

    Args:
        delta: 距离上一帧的时间间隔 (秒)
    """
    # 获取水平输入方向
    var 水平方向: float = Input.get_axis("ui_left", "ui_right")
    velocity.x = 水平方向 * 移动速度

    # 处理跳跃输入
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        开始跳跃()

    # 应用重力
    if not is_on_floor():
        velocity.y += 重力加速度 * delta

    # 执行移动
    move_and_slide()

    # 更新动画状态
    更新动画状态(水平方向)

# === 辅助方法 ===
func 开始跳跃() -> void:
    """执行跳跃动作"""
    velocity.y = 跳跃速度
    正在跳跃 = true
    播放跳跃动画()
    print("玩家跳跃!")

func 播放跳跃动画() -> void:
    """播放跳跃动画并等待完成"""
    动画播放器.play("跳跃")
    await 动画播放器.animation_finished
    正在跳跃 = false

func 更新动画状态(移动方向: float) -> void:
    """根据移动状态更新角色动画

    Args:
        移动方向: 水平移动方向 (-1.0 到 1.0)
    """
    if abs(移动方向) > 0.1:
        # 移动状态
        动画播放器.play("奔跑")

        # 处理角色朝向翻转
        if 移动方向 > 0 and not 面向右侧:
            翻转角色(true)
        elif 移动方向 < 0 and 面向右侧:
            翻转角色(false)
    else:
        # 静止状态
        动画播放器.play("待机")

func 翻转角色(面向右: bool) -> void:
    """翻转角色朝向

    Args:
        面向右: 是否面向右侧
    """
    面向右侧 = 面向右
    精子.flip_h = not 面向右

func 重置玩家状态() -> void:
    """重置玩家到初始状态"""
    velocity = Vector2.ZERO
    正在跳跃 = false
    面向右侧 = true
    当前生命值 = 100
    无敌时间 = 0.0
    动画播放器.play("待机")
    print("玩家状态已重置")

# === 信号处理 ===
func _on_伤害区域_body_entered(body: Node2D) -> void:
    """当敌人进入伤害区域时触发

    Args:
        body: 进入区域的碰撞体
    """
    if body.is_in_group("敌人") and 无敌时间 <= 0:
        处理伤害碰撞(body)

func 处理伤害碰撞(敌人: Node2D) -> void:
    """处理与敌人的碰撞伤害

    Args:
        敌人: 造成伤害的敌人节点
    """
    当前生命值 -= 10
    无敌时间 = 1.0  # 1秒无敌时间

    # 播放受伤动画
    动画播放器.play("受伤")

    # 计算击退方向和力度
    var 击退方向 = (global_position - 敌人.global_position).normalized()
    velocity = 击退方向 * 200.0

    print("玩家受到伤害! 剩余生命值:", 当前生命值)

    if 当前生命值 <= 0:
        玩家死亡()
```

## 中文测试框架

### 测试工具类
```gdscript
# 中文测试工具类 - 提供中文友好的测试功能
class_name 中文测试工具
extends RefCounted

static func 运行所有测试() -> void:
    """运行项目的所有单元测试"""
    print("🚀 开始运行测试套件...")
    print("=" * 50)

    var 测试结果列表: Array[Dictionary] = []
    var 开始时间 = Time.get_ticks_msec()

    # 执行各项测试
    测试结果列表.append(测试玩家移动功能())
    测试结果列表.append(测试跳跃机制())
    测试结果列表.append(测试动画系统())
    测试结果列表.append(测试生命值系统())

    var 结束时间 = Time.get_ticks_msec()
    var 总耗时 = (结束时间 - 开始时间) / 1000.0

    # 输出测试结果摘要
    输出测试结果摘要(测试结果列表, 总耗时)

static func 测试玩家移动功能() -> Dictionary:
    """测试玩家移动功能"""
    print("📝 测试玩家移动功能...")

    try:
        var 玩家 = 玩家角色.new()

        # 测试初始化状态
        assert(玩家.移动速度 == 300.0, "移动速度初始化错误")
        assert(玩家.面向右侧 == true, "初始朝向错误")
        assert(玩家.velocity == Vector2.ZERO, "初始速度应为零")

        # 测试右移
        玩家.velocity.x = 玩家.移动速度
        玩家.move_and_slide()
        assert(玩家.velocity.x > 0, "向右移动失败")

        # 测试左移
        玩家.velocity.x = -玩家.移动速度
        玩家.move_and_slide()
        assert(玩家.velocity.x < 0, "向左移动失败")

        print("✅ 玩家移动功能测试通过")
        return {"名称": "玩家移动功能", "状态": "通过", "耗时": 0.05}

    except:
        print("❌ 玩家移动功能测试失败")
        return {"名称": "玩家移动功能", "状态": "失败", "错误": "移动逻辑异常"}

static func 输出测试结果摘要(结果列表: Array[Dictionary], 总耗时: float) -> void:
    """输出格式化的测试结果摘要

    Args:
        结果列表: 所有测试的结果数组
        总耗时: 测试总耗时 (秒)
    """
    var 通过数量 = 0
    var 失败数量 = 0

    print("\n" + "=" * 50)
    print("📊 测试结果摘要")
    print("=" * 50)

    # 详细结果
    for 结果 in 结果列表:
        var 状态图标 = "✅" if 结果.状态 == "通过" else "❌"
        print(f"{状态图标} {结果.名称}")

        if 结果.状态 == "失败":
            print(f"   错误: {结果.get('错误', '未知错误')}")

        if 结果.has("耗时"):
            print(f"   耗时: {结果.耗时:.2f}秒")

        if 结果.状态 == "通过":
            通过数量 += 1
        else:
            失败数量 += 1

    # 统计信息
    print("\n📈 统计信息:")
    print(f"   总测试数: {通过数量 + 失败数量}")
    print(f"   通过数量: {通过数量}")
    print(f"   失败数量: {失败数量}")
    print(f"   成功率: {(通过数量 / (通过数量 + 失败数量) * 100):.1f}%")
    print(f"   总耗时: {总耗时:.2f}秒")

    # 总结
    if 失败数量 == 0:
        print("\n🎉 恭喜! 所有测试都通过了!")
    else:
        print(f"\n⚠️  警告: 有 {失败数量} 个测试失败，请检查相关代码")
```

## 常见中文问题解决方案

### 1. 字符编码问题
```gdscript
# UTF-8编码验证工具
func 验证文件UTF8编码(文件路径: String) -> bool:
    """验证文件是否使用有效的UTF-8编码

    Args:
        文件路径: 要验证的文件路径

    Returns:
        bool: true表示编码有效，false表示编码有问题
    """
    var 文件 = FileAccess.open(文件路径, FileAccess.READ)
    if 文件 == null:
        push_error(f"无法打开文件: {文件路径}")
        return false

    var 内容 = 文件.get_as_text()
    文件.close()

    var 有效长度 = 内容.validate_utf8()
    if 有效长度 < 内容.length():
        push_warning(f"文件 {文件路径} 包含无效的UTF-8字符")
        return false

    return true

func 修复文件编码(文件路径: String) -> bool:
    """尝试修复文件的编码问题

    Args:
        文件路径: 需要修复的文件路径

    Returns:
        bool: true表示修复成功
    """
    if not 验证文件UTF8编码(文件路径):
        push_error(f"文件 {文件路径} 存在编码问题，需要手动修复")
        return false

    print(f"文件 {文件路径} 编码正常")
    return true
```

### 2. 中文输入处理
```gdscript
# 中文输入法支持配置
func 配置中文输入映射() -> void:
    """设置中文游戏操作的按键映射"""
    # 移动控制
    InputMap.add_action("移动前")
    InputMap.add_action("移动后")
    InputMap.add_action("移动左")
    InputMap.add_action("移动右")

    # 添加键盘事件
    var 移动前事件 = InputEventKey.new()
    移动前事件.keycode = KEY_W
    InputMap.action_add_event("移动前", 移动前事件)

    var 移动后事件 = InputEventKey.new()
    移动后事件.keycode = KEY_S
    InputMap.action_add_event("移动后", 移动后事件)

    var 移动左事件 = InputEventKey.new()
    移动左事件.keycode = KEY_A
    InputMap.action_add_event("移动左", 移动左事件)

    var 移动右事件 = InputEventKey.new()
    移动右事件.keycode = KEY_D
    InputMap.action_add_event("移动右", 移动右事件)

    # 动作控制
    InputMap.add_action("跳跃")
    var 跳跃事件 = InputEventKey.new()
    跳跃事件.keycode = KEY_SPACE
    InputMap.action_add_event("跳跃", 跳跃事件)

    print("中文按键映射配置完成")
```

## 输出格式

1. **配置概述** - 说明要配置的中文环境组件
2. **执行步骤** - 详细的配置步骤和命令
3. **验证方法** - 如何验证配置是否成功
4. **常见问题** - 可能遇到的问题和解决方案
5. **进阶优化** - 进一步的优化建议

## 注意事项

- 确保所有文件都使用UTF-8编码保存
- 在跨平台开发时注意不同系统的中文支持差异
- 定期备份中文配置文件和自定义设置
- 在团队协作时统一中文编码和命名规范
- 测试中文显示、输入、处理等各个环节
- 考虑不同地区中文用户的习惯差异