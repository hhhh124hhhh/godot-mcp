# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 在此代码库中工作时提供指导。

## 架构概览

这是一个 **Godot 引擎 + Claude AI 集成**项目，使用模型上下文协议 (MCP)。项目采用 **客户端-服务器架构**：

- **Godot 插件 (客户端)**: 位于 `addons/godot_mcp/` - 作为 EditorPlugin 在 Godot 中运行
- **MCP 服务器 (后端)**: 位于 `server/` - 使用 FastMCP 的 Node.js/TypeScript 服务器

### 通信流程
```
Claude ↔ MCP 服务器 (FastMCP) ↔ WebSocket ↔ Godot 插件
```

Godot 插件创建 WebSocket 服务器（默认端口 9080），接受来自 MCP 服务器的连接。所有命令都通过此 WebSocket 连接使用 JSON 消息格式传输。

## 构建和运行命令

### MCP 服务器开发
- **安装依赖**: `cd server && npm install`
- **服务器构建**: `cd server && npm run build` (将 TypeScript 编译到 `dist/`)
- **启动服务器**: `cd server && npm run start`
- **开发模式**: `cd server && npm run dev` (使用 nodemon 自动重建)
- **类型检查**: `cd server && npx tsc --noEmit` (仅类型检查，不输出文件)

### Godot 项目
- **打开项目**: 在 Godot Editor 中打开 `project.godot`
- **插件位置**: `addons/godot_mcp/`
- **启用插件**: 项目设置 → 插件 → 启用 "Godot MCP"

### 测试连接
1. 启动 MCP 服务器: `cd server && npm run dev`
2. 在 Godot Editor 中打开项目（插件自动启动）
3. 检查 MCP 服务器日志，确认 WebSocket 连接到 `ws://localhost:9080`

## 核心组件

### Godot 插件端 (`addons/godot_mcp/`)
- **`mcp_server.gd`**: 主 EditorPlugin，创建 WebSocket 服务器
- **`command_handler.gd`**: 将 JSON 命令路由到相应的处理器
- **`commands/`**: 命令处理器（node_commands.gd, script_commands.gd, scene_commands.gd 等）
- **`ui/mcp_panel.gd`**: 编辑器 UI 面板，显示连接状态和日志

### MCP 服务器端 (`server/src/`)
- **`index.ts`**: FastMCP 服务器入口点，注册所有工具/资源
- **`utils/godot_connection.ts`**: WebSocket 连接管理，支持自动重连
- **`tools/`**: MCP 工具定义（node_tools.ts, script_tools.ts 等）
- **`resources/`**: MCP 资源提供器（scene_resources.ts, script_resources.ts 等）

## 开发模式

### 添加新命令
1. **Godot 端**: 在 `addons/godot_mcp/commands/` 中创建新命令类
   - 继承基础命令模式
   - 在 `command_handler.gd` 中注册
   - 遵循 snake_case 命名规范

2. **MCP 服务器端**: 在 `server/src/tools/` 中创建工具
   - 使用 FastMCP 工具构建器模式
   - 在 `server/src/index.ts` 中注册
   - 使用 Zod 进行参数验证

### 消息协议
**命令格式** (MCP → Godot):
```json
{
  "type": "command_name",
  "params": { /* 命令参数 */ },
  "commandId": "unique_id"
}
```

**响应格式** (Godot → MCP):
```json
{
  "status": "success|error",
  "result": { /* 响应数据 */ },
  "commandId": "matching_id"
}
```

## 代码风格指南

### TypeScript (服务器)
- 变量、方法和函数名使用 camelCase
- 类/接口使用 PascalCase
- 强类型：避免 `any` 类型，使用 Zod 进行运行时验证
- 优先使用 async/await 而非 Promise 链
- 导入结构：Node 模块在前，然后是本地模块
- 使用 ES 模块 (package.json 中设置 "type": "module")

### GDScript (Godot)
- 变量、方法和函数名使用 snake_case
- 类名使用 PascalCase
- 尽可能使用类型提示：`var player: Player`
- 遵循 Godot 单例约定（如 `Engine`, `OS`）
- 节点间通信优先使用信号
- 错误处理：开发检查使用断言和 `assert()`

## GDScript 缩进规范

### 基本缩进标准

#### 官方推荐标准
- **缩进字符**: 必须使用 **制表符 (Tab)**，而非空格
- **缩进宽度**: 显示为4个字符宽度（编辑器配置）
- **缩进层级**: 每个嵌套层级使用一个Tab
- **对齐**: 严格使用Tab缩进，避免Tab和空格混用

**为什么使用Tab而非空格？**
- Godot官方编辑器默认支持和推荐Tab缩进
- 文件大小更小，解析性能更好
- 避免空格/制表符混用导致的显示问题
- 团队协作时缩进一致性更容易保证

#### 具体缩进规则

**1. 类级别声明**
```gdscript
extends Node2D
class_name MyClass

# 这些声明不应该有前导缩进
var variable: int = 0
const CONSTANT: float = 1.0
signal my_signal()

func _ready() -> void:
    # 函数定义不应该有前导缩进
    pass
```

**2. 函数定义**
```gdscript
func my_function(param: int) -> void:
    # 函数体内的代码使用一个Tab缩进
    if condition:
        # 嵌套代码块使用两个Tab缩进
        nested_call()

    # 同级别的代码保持一个Tab缩进
    other_call()

static func static_function() -> void:
    # 静态函数同样遵循缩进规则
    pass
```

**3. 特殊情况处理**

**长行对齐**:
```gdscript
func long_function_call(
    param1: String,
    param2: int,
    param3: bool
) -> void:
    # 函数参数换行时，对齐到函数名位置
    function_body()
```

**链式调用**:
```gdscript
var tween = create_tween()
tween.tween_property(
    object, "property", value, duration
).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
```

**数组/字典**:
```gdscript
var array = [
    item1,
    item2,
    item3
]

var dictionary = {
    "key1": value1,
    "key2": value2,
    "key3": value3
}
```

### IDE 配置指南

#### VS Code
在项目 `.vscode/settings.json` 中添加：
```json
{
    "editor.insertSpaces": false,
    "editor.tabSize": 4,
    "editor.detectIndentation": false,
    "[gdscript]": {
        "editor.insertSpaces": false,
        "editor.tabSize": 4,
        "editor.renderWhitespace": "boundary"
    }
}
```

#### Godot 编辑器
- **自动缩进**: 启用 (默认)
- **缩进大小**: 4 空格宽度
- **使用制表符**: 启用 (默认)
- **显示空白字符**: 建议启用以发现缩进问题

#### 其他编辑器配置

**Sublime Text**:
```json
{
    "translate_tabs_to_spaces": false,
    "tab_size": 4,
    "detect_indentation": false,
    "show_whitespace": true
}
```

**Vim/Neovim**:
```vim
set noexpandtab
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:»·,trail:·
```

### 团队协作规则

#### 代码审查清单
在代码审查时，必须检查以下缩进问题：
- [ ] 文件中是否混用空格和制表符
- [ ] 函数定义前是否有多余的缩进
- [ ] 嵌套层级缩进是否正确
- [ ] 长行对齐是否一致
- [ ] 注释缩进是否与代码对齐

#### 协作流程规范

**新文件创建**:
1. 确保编辑器已正确配置缩进设置
2. 新文件开始时检查缩进是否使用Tab
3. 编写过程中定期显示空白字符检查

**文件修改**:
1. 打开文件时检查现有缩进模式
2. 修改时保持与现有代码一致的缩进
3. 提交前运行缩进检查工具

**Git 配置**:
```gitconfig
# .gitattributes 文件配置
*.gd text eol=lf
*.gdscript text eol=lf
```

### 常见错误预防

#### 错误识别指南

**1. 制表符和空格混用**
```gdscript
# ❌ 错误：混用空格和制表符
func bad_example() -> void:
	var variable = 0    # 这里可能使用了空格
        another_var = 1   # 这里可能使用了不同的缩进

# ✅ 正确：统一使用制表符
func good_example() -> void:
	var variable = 0
	another_var = 1
```

**2. 函数定义缩进错误**
```gdscript
# ❌ 错误：函数定义前有缩进
	func bad_function() -> void:
		pass

# ✅ 正确：函数定义无前导缩进
func good_function() -> void:
	pass
```

**3. 嵌套缩进不一致**
```gdscript
# ❌ 错误：缩进层级混乱
func bad_function() -> void:
if condition:
do_something()
		nested_call()

# ✅ 正确：清晰的层级缩进
func good_function() -> void:
	if condition:
		do_something()
		nested_call()
```

#### 自动化预防措施

**EditorConfig 配置**:
项目根目录的 `.editorconfig` 文件应包含：
```ini
[*.gd]
indent_style = tab
indent_size = 4
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
```

**Pre-commit Hook 检查**:
```bash
#!/bin/sh
# .git/hooks/pre-commit
# 检查GD文件中是否有空格缩进
if git diff --cached --name-only | grep -E '\.gd$'; then
    files_with_spaces=$(git diff --cached --name-only | xargs grep -l '^\s* \+')
    if [ -n "$files_with_spaces" ]; then
        echo "错误：以下文件包含空格缩进："
        echo "$files_with_spaces"
        exit 1
    fi
fi
```

#### 工具使用建议

**编辑器功能**:
- 启用显示空白字符功能
- 使用自动缩进功能
- 配置保存时自动格式化
- 使用代码检查插件

**检查命令**:
```bash
# 检查文件中的空格缩进
grep -n "^ " *.gd

# 检查文件中的制表符缩进
grep -n "^\t" *.gd

# 显示文件中的空白字符
cat -A file.gd
```

### 故障排除

#### 常见问题解决

**问题1：编辑器显示缩进不一致**
- **原因**: 编辑器配置与项目标准不符
- **解决**: 更新编辑器配置，使用项目的 `.editorconfig`

**问题2：Git diff 显示大量缩进差异**
- **原因**: 不同开发者使用不同的缩进设置
- **解决**: 统一团队编辑器配置，使用 `.editorconfig`

**问题3：代码在不同编辑器中显示不同**
- **原因**: Tab显示宽度设置不同
- **解决**: 统一Tab显示宽度为4字符

#### 紧急修复方法

如果发现文件缩进混乱，可以使用以下方法快速修复：

```python
# Python 脚本修复GD文件缩进
import re
import sys

def fix_gdscript_indentation(filename):
    with open(filename, 'r') as f:
        content = f.read()

    lines = content.split('\n')
    fixed_lines = []

    for line in lines:
        # 将前导空格转换为制表符（每4个空格转1个Tab）
        leading_spaces = len(line) - len(line.lstrip(' '))
        if leading_spaces > 0 and line.lstrip().startswith(('func', 'class_name', 'extends', 'var', 'const', 'signal')):
            # 类级别声明不应该有缩进
            fixed_lines.append(line.lstrip(' '))
        elif leading_spaces > 0:
            tabs = leading_spaces // 4
            spaces = leading_spaces % 4
            fixed_lines.append('\t' * tabs + ' ' * spaces + line.lstrip(' '))
        else:
            fixed_lines.append(line)

    with open(filename, 'w') as f:
        f.write('\n'.join(fixed_lines))

if __name__ == "__main__":
    for filename in sys.argv[1:]:
        fix_gdscript_indentation(filename)
        print(f"Fixed indentation in {filename}")
```

### 通用规范
- 使用描述性名称
- 保持函数小而专注
- 为复杂逻辑添加注释
- 错误处理：TS 中优先使用 try/catch，GDScript 中使用断言
- 扩展功能时遵循现有模式

## MCP 工具使用指南

### 可用的 MCP 工具

本项目已配置了多个强大的 MCP 工具，可以大大提升开发效率：

#### 1. Godot 兼容性工具
- **detect_godot_version** - 检测项目 Godot 版本
- **check_godot_api_compatibility** - 检查代码兼容性问题
- **fix_godot_api_compatibility** - 自动修复兼容性问题
- **get_godot_migration_advice** - 获取迁移建议

#### 2. 标准开发工具
- **节点工具** - 创建、修改、删除节点
- **脚本工具** - 创建、编辑、删除脚本
- **场景工具** - 场景文件管理
- **编辑器工具** - 与 Godot 编辑器交互

#### 3. 增强开发工具
- **Chrome DevTools** - 网页调试和性能分析
- **Sequential Thinking** - 结构化思维和问题分解
- **Context7** - 获取最新库文档和 API 信息

### 自动使用 Context7 获取最新文档

**重要规则**：当需要进行代码生成、配置步骤或库/API 文档查询时，系统会自动使用 Context7 MCP 工具解析库 ID 并获取库文档，无需您明确要求。

#### 使用场景示例：

1. **代码生成时自动获取文档**：
   ```
   用户：我需要实现一个 React 粒子系统组件
   → 系统自动：查询 React 最新文档，提供现代实现方案
   ```

2. **配置步骤时自动获取最佳实践**：
   ```
   用户：帮我设置 Webpack 5 配置
   → 系统自动：获取最新 Webpack 配置指南
   ```

3. **API 使用时自动获取参考**：
   ```
   用户：使用最新的 Godot 4.x 粒子系统 API
   → 系统自动：提供最新 API 文档和示例代码
   ```

### MCP 工具集成工作流

```
1. Sequential Thinking: 分析复杂需求，设计解决方案
2. Context7: 获取最新技术文档和最佳实践
3. Godot MCP: 检查兼容性，自动修复问题
4. Chrome DevTools: 调试相关网页界面（如果有）
5. 验证和优化: 确保解决方案的正确性
```

### 获取帮助和调试

- 使用 `claude mcp list` 查看所有可用的 MCP 工具
- 每个工具都有详细的帮助文档和使用说明
- 工具支持中文交互，可以直接用中文询问

## 技能开发工作流

### 使用 superpowers 技能

当你需要执行复杂、多步骤的开发任务时，系统会自动激活相应的超级技能：

#### 常用超级技能
- **superpowers:brainstorming** - 创意构思和设计优化
- **superpowers:executing-plans** - 执行结构化计划
- **superpowers:writing-plans** - 创建详细的实施计划

#### 开发相关超级技能
- **superpowers:test-driven-development** - 测试驱动开发
- **superpowers:code-reviewer** - 代码审查
- **superpowers:using-superpowers** - 学习和使用超级技能

### 技能文件夹指南

项目包含 `skills/` 文件夹，其中包含了多个超级技能的详细使用说明：

- **skills/using-superpowers/SKILL.md** - 超级使用指南
- **skills/brainstorming/SKILL.md** - 创意构思指南
- **skills/executing-plans/SKILL.md** - 计划执行指南
- **skills/writing-plans/SKILL.md** - 计划编写指南

每个技能都包含：
- 详细的使用方法
- 具体场景示例
- 最佳实践建议
- 中文界面支持

### 自动化代码生成流程

当需要生成代码或配置时，系统会：

1. **自动识别需求**：理解您的代码生成需求
2. **使用 Context7**：获取最新的库文档和最佳实践
3. **应用专业知识**：结合项目实际情况提供最优解决方案
4. **确保兼容性**：自动检查 Godot 版本兼容性
5. **提供完整方案**：包含代码、文档和测试建议

### 实际应用示例

#### 场景：创建现代化的粒子系统

```
用户：我需要一个高性能的粒子系统，支持多种特效

系统自动流程：
1. Sequential Thinking: 分析粒子系统需求
2. Context7: 查询最新 Godot 4.x 粒子系统文档
3. Godot MCP: 检查兼容性并自动修复
4. 提供完整的实现代码和最佳实践
```

#### 场景：配置构建流程

```
用户：帮我设置完整的开发环境配置

系统自动流程：
1. Sequential Thinking: 分析项目需求
2. Context7: 获取最新工具配置指南
3. 结合实际项目情况提供配置方案
4. 验证配置正确性
```

## 配置

### WebSocket 设置
- **默认端口**: 9080（在 Godot 插件中可配置）
- **连接**: 仅本地连接以确保安全
- **自动重连**: 内置于 MCP 服务器连接管理

### TypeScript 配置
- **目标**: ES Next 配合 Node 模块
- **输出**: `dist/` 目录
- **严格模式**: 已启用
- **源映射**: 为调试生成

## 主要依赖

### MCP 服务器依赖
- **fastmcp**: MCP 协议实现
- **ws**: WebSocket 客户端/服务器库
- **zod**: 模式验证
- **websocket**: 额外的 WebSocket 工具

### 开发依赖
- **typescript**: TypeScript 编译器
- **nodemon**: 开发期间自动重启
- **@types/node**: Node.js 类型定义

## Godot API 版本兼容性系统

### 系统概述

这是一个完整的Godot API版本兼容性问题解决方案，专门用于检测、修复和预防Godot 3.x与4.x之间的API差异问题。该系统能够彻底解决AI处理Godot项目时遇到的版本混淆问题。

### 系统架构

#### 核心组件

1. **版本检测器** (`server/src/utils/godot_version_detector.ts`)
   - 自动检测项目使用的Godot版本
   - 解析`project.godot`配置文件
   - 提供版本兼容性提示和建议

2. **API兼容性数据库** (`server/src/data/godot_api_compatibility.ts`)
   - 完整的API变化映射表
   - 破坏性变化、废弃功能和更新说明
   - 智能修复规则和示例代码

3. **实时代码验证器** (`server/src/utils/godot_code_validator.ts`)
   - 静态代码分析和兼容性检查
   - 性能、安全性、最佳实践全方位验证
   - 智能错误分类和修复建议

4. **MCP工具集成** (`server/src/tools/godot_compatibility_tools.ts`)
   - 4个专用的兼容性工具
   - 与现有MCP架构无缝集成
   - 自动修复和迁移建议

### 可用工具

#### 1. detect_godot_version
**功能**：检测项目中使用的Godot版本和配置信息

**参数**：
- `projectPath` (可选)：项目路径

**使用场景**：
- 开始新项目时确认目标版本
- 遇到版本相关错误时的诊断
- 自动化构建流程中的版本检查

#### 2. check_godot_api_compatibility
**功能**：检查GDScript代码中的API兼容性问题

**参数**：
- `code` (必需)：要检查的GDScript代码
- `targetVersion` (可选)：目标版本 ('3.x', '4.x', 'auto')
- `projectPath` (可选)：项目路径

**使用场景**：
- 代码审查时的兼容性检查
- 导入第三方代码时的验证
- 升级项目前的风险评估

#### 3. fix_godot_api_compatibility
**功能**：自动修复GDScript代码中的API兼容性问题

**参数**：
- `code` (必需)：要修复的GDScript代码
- `issueIds` (可选)：要修复的问题ID列表
- `targetVersion` (可选)：目标版本
- `projectPath` (可选)：项目路径

**使用场景**：
- 项目升级时的批量修复
- IDE插件的一键修复功能
- CI/CD流程中的自动修复

#### 4. get_godot_migration_advice
**功能**：获取Godot版本迁移建议和最佳实践

**参数**：
- `fromVersion` (可选)：源版本
- `toVersion` (可选)：目标版本
- `projectPath` (可选)：项目路径

**使用场景**：
- 制定迁移计划时
- 团队培训和技术分享
- 文档编写和知识管理

### 支持的API变化

#### Tween系统
- ✅ `interpolate_property()` → `tween_property()`
- ✅ `set_looped()` → callback循环模式
- ✅ 缓动常量和过渡方式更新

#### Gradient系统
- ✅ `get_color_at_offset()` → `get_color(index)`
- ✅ `set_color(index, color)` 替代方案

#### 输入系统
- ✅ 信号连接语法现代化
- ✅ 鼠标事件处理更新
- ✅ 输入映射系统变化

#### 节点操作
- ✅ 安全的节点访问模式
- ✅ `call_deferred("queue_free")` 安全删除
- ✅ 节点路径处理优化

#### 信号系统
- ✅ lambda表达式支持
- ✅ 新的连接语法
- ✅ 自动断开机制

#### 粒子系统
- ✅ `ParticlesMaterial` → `ParticleProcessMaterial`
- ✅ `explosiveness` → `direction + spread`
- ✅ `scale_amount_min/max` → `scale_min/max`

#### Shader参数
- ✅ `get_shader_parameter()` 类型安全
- ✅ 算术运算前的类型转换
- ✅ null值检查和预防

### 使用指南

#### 问题检测流程

1. **遇到错误时**：
   ```bash
   # 示例错误：
   # Invalid call. Nonexistent function 'set_looped' in base 'Tween'
   ```

2. **使用兼容性检查**：
   ```gdscript
   # 调用检查工具
   check_godot_api_compatibility({
       code: "tween.set_looped(true)",
       targetVersion: "4.x"
   })
   ```

3. **查看检测结果**：
   ```json
   {
     "success": true,
     "data": {
       "issues": {
         "breaking": 1,
         "details": [{
           "category": "tween",
           "description": "set_looped()在Godot 4.x中已被移除",
           "autoFixAvailable": true
         }]
       }
     }
   }
   ```

#### 自动修复流程

1. **使用自动修复工具**：
   ```gdscript
   # 调用修复工具
   fix_godot_api_compatibility({
       code: "tween.set_looped(true)",
       targetVersion: "4.x"
   })
   ```

2. **获取修复结果**：
   ```json
   {
     "success": true,
     "data": {
       "fixedCode": "func animate_loop():\n    var tween = create_tween()\n    # 动画代码...\n    tween.tween_callback(animate_loop)",
       "fixes": [{"success": true, "category": "tween"}]
     }
   }
   ```

#### 最佳实践

##### 开发阶段预防
1. **版本检测**：项目开始时检测Godot版本
2. **实时检查**：代码编写时进行兼容性验证
3. **自动修复**：遇到问题时立即应用修复

##### 代码审查检查清单
- [ ] 是否使用了过时的API方法
- [ ] 粒子系统是否使用`ParticleProcessMaterial`
- [ ] Tween是否使用新的callback循环模式
- [ ] Shader参数是否有适当的类型转换
- [ ] 节点操作是否使用安全模式

##### 团队协作规范
1. **统一开发环境**：
   - 团队使用相同的Godot版本
   - 配置统一的代码检查工具
   - 建立API变化通知机制

2. **知识共享**：
   - 定期更新API兼容性文档
   - 分享新发现的兼容性问题
   - 培训团队成员使用检查工具

3. **代码质量**：
   - CI/CD中集成兼容性检查
   - 代码审查时重点关注兼容性
   - 建立兼容性问题追踪机制

### 常见问题快速参考

#### Tween相关问题

**问题**：`set_looped()`不存在
```gdscript
# 错误
tween.set_looped(true)

# 修复
func animate_loop():
    var tween = create_tween()
    # 动画代码...
    tween.tween_callback(animate_loop)
```

**问题**：`interpolate_property()`不存在
```gdscript
# 错误
tween.interpolate_property(object, "property", start, end, 1.0)

# 修复
var tween = create_tween()
tween.tween_property(object, "property", end, 1.0)
```

#### 粒子系统相关问题

**问题**：`ParticlesMaterial`不存在
```gdscript
# 错误
var material = ParticlesMaterial.new()

# 修复
var material = ParticleProcessMaterial.new()
```

**问题**：`explosiveness`属性不存在
```gdscript
# 错误
material.explosiveness = 1.0

# 修复
material.direction = Vector3.UP
material.spread = 45.0
```

#### Shader相关问题

**问题**：`get_shader_parameter()`返回null导致算术错误
```gdscript
# 错误
material.get_shader_parameter("param") + 0.1

# 修复
var param_value = material.get_shader_parameter("param") as float
param_value + 0.1
```

### 技术实现细节

#### 版本检测算法
```typescript
// 基于config_version推断Godot版本
function inferGodotVersion(configVersion: number): VersionInfo {
  if (configVersion === 5) {
    return { major: 4, minor: 2 }; // Godot 4.x
  } else if (configVersion === 4) {
    return { major: 4, minor: 0 }; // Godot 4.0
  } else if (configVersion === 3) {
    return { major: 3, minor: 5 }; // Godot 3.x
  }
}
```

#### 兼容性检查规则
```typescript
// Tween系统检查规则
{
  pattern: /\.set_looped\s*\(/,
  check: async (matches) => ({
    category: 'tween',
    description: 'set_looped()在Godot 4.x中已被移除',
    migrationNotes: '使用callback循环代替',
    severity: 'breaking'
  })
}
```

#### 自动修复算法
```typescript
// 基于规则的自动修复
function generateFix(code: string, issue: APIChange): string | null {
  if (issue.category === 'tween' && issue.godot3Method === 'set_looped') {
    return code.replace(/(\w+)\.set_looped\([^)]*\)/g,
      '# $1.set_looped() 已移除，请使用callback循环');
  }
  return null;
}
```

### 扩展和维护

#### 添加新的API变化
1. **更新数据库**：
   ```typescript
   this.apiChanges.set('new_category', [
     {
       category: 'new_category',
       godot3Method: 'old_method',
       godot4Method: 'new_method',
       description: 'API变化描述',
       migrationNotes: '迁移指导',
       severity: 'breaking'
     }
   ]);
   ```

2. **添加检查规则**：
   ```typescript
   rules.push({
     pattern: /old_method_pattern/,
     check: async (matches) => ({
       category: 'new_category',
       description: '问题描述',
       migrationNotes: '修复建议'
     })
   });
   ```

3. **测试验证**：
   - 编写测试用例验证修复效果
   - 更新文档和示例代码
   - 进行实际项目测试

#### 系统监控和优化
- 定期检查修复成功率
- 收集用户反馈和新的兼容性问题
- 优化检查算法和修复逻辑
- 更新数据库以提高准确性

### 故障排除

#### 常见系统问题

**问题1：版本检测失败**
- **原因**：`project.godot`文件损坏或不存在
- **解决**：检查文件格式和权限，确保文件可访问

**问题2：修复代码语法错误**
- **原因**：复杂场景下的自动修复不完善
- **解决**：手动调整修复结果，提供反馈改进系统

**问题3：性能问题**
- **原因**：大文件检查时的性能开销
- **解决**：使用缓存机制，优化检查算法

### 未来发展规划

#### 短期目标
- 扩展支持更多API变化
- 优化修复算法准确性
- 添加更多Godot版本支持

#### 中期目标
- 集成IDE插件
- 支持批量项目修复
- 建立用户反馈系统

#### 长期目标
- 机器学习驱动的智能修复
- 跨引擎兼容性支持
- 社区贡献的兼容性数据库

---

**版本**: 1.0.0
**最后更新**: 2025-11-08
**维护者**: Godot MCP开发团队
