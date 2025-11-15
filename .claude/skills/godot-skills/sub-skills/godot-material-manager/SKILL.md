---
name: Godot Material Manager
version: 1.0.0
description: 专业的Godot材质管理系统，支持StandardMaterial3D和ShaderMaterial的创建、配置、批量操作和性能优化，与Context7集成获取最新材质技术
---

# Godot 材质管理技能

本技能为Godot开发者提供专业的材质创建和管理能力，支持StandardMaterial3D和ShaderMaterial的创建、配置、批量操作和性能优化，与Context7集成获取最新材质技术。

## 触发条件

- 需要创建或修改材质（StandardMaterial3D、ShaderMaterial）
- 提及"材质"、"material"、"着色器"、"Shader"
- 需要批量创建或修改多个材质
- 需要设置PBR材质属性（metallic、roughness、albedo等）
- 需要创建自定义ShaderMaterial
- 需要优化材质性能或减少Draw Call

## 核心功能

### 1. StandardMaterial3D 管理
- 创建PBR材质
- 配置基础颜色（albedo）、金属度（metallic）、粗糙度（roughness）
- 设置法线贴图、AO贴图、高度贴图
- 配置透明度和混合模式
- 设置UV缩放和偏移

### 2. ShaderMaterial 管理
- 创建ShaderMaterial并关联.gdshader文件
- 配置Shader参数
- 动态修改Shader uniform变量
- Shader模板和复用

### 3. 批量材质操作
- 批量创建材质
- 批量修改材质属性
- 材质继承和变体创建
- 材质库管理

### 4. 性能优化
- Draw Call优化建议
- 材质合并和图集使用
- 移动平台材质优化
- Shader复杂度分析

## 执行步骤

### 创建 StandardMaterial3D

1. **确定材质类型**
   - 不透明材质（Opaque）
   - 透明材质（Transparency）
   - 镂空材质（Alpha Scissor）
   - 混合材质（Alpha Blend）

2. **配置基础属性**
   - albedo_color: 基础颜色
   - metallic: 金属度（0.0-1.0）
   - roughness: 粗糙度（0.0-1.0）
   - specular: 高光强度

3. **设置纹理贴图**
   - albedo_texture: 颜色贴图
   - normal_texture: 法线贴图
   - roughness_texture: 粗糙度贴图
   - metallic_texture: 金属度贴图

4. **测试和调整**
   - 在场景中应用材质
   - 调整光照查看效果
   - 微调参数

### 创建 ShaderMaterial

1. **编写或选择Shader**
   - 编写 .gdshader 文件
   - 或使用现有的Shader模板

2. **创建ShaderMaterial**
   - 创建 ShaderMaterial 资源
   - 关联 .gdshader 文件

3. **配置Shader参数**
   - 设置Shader的uniform变量
   - 关联纹理参数

4. **应用和测试**
   - 将材质应用到Mesh
   - 运行场景查看效果

### 批量材质操作

1. **选择目标材质**
   - 按路径模式匹配
   - 或按材质类型筛选

2. **定义操作**
   - 确定修改的属性
   - 准备新值

3. **执行批量修改**
   - 遍历所有匹配材质
   - 应用修改

4. **验证结果**
   - 检查修改后的材质
   - 确保项目正常运行

## 代码示例

### 示例 1: 创建标准PBR材质

```bash
# 创建草地材质
claude godot create_standard_material --project_path="/mnt/d/godot-project" \
  --material_path="res://materials/ground_grass.tres" \
  --albedo_color="Color(0.2, 0.5, 0.2, 1)" \
  --roughness="0.9" \
  --metallic="0.0" \
  --albedo_texture="res://textures/grass_diffuse.png" \
  --normal_texture="res://textures/grass_normal.png"
```

### 示例 2: 创建ShaderMaterial

```bash
# 创建水面ShaderMaterial
claude godot create_shader_material \
  --material_path="res://materials/water.tres" \
  --shader_path="res://shaders/water.gdshader" \
  --shader_params='{
    "wave_speed": 1.5,
    "wave_height": 0.3,
    "color": "Vector3(0.1, 0.4, 0.8)"
  }'
```

### 示例 3: 批量修改材质属性

```bash
# 将所有材质的metallic设为0
claude godot batch_modify_materials --material_pattern="res://materials/*.tres" \
  --property="metallic" \
  --value="0.0"
```

### 示例 4: 创建材质变体

```bash
# 基于已有材质创建变体
claude godot create_material_variant \
  --base_material="res://materials/base_metal.tres" \
  --variant_path="res://materials/rusty_metal.tres" \
  --overrides='{
    "albedo_color": "Color(0.6, 0.4, 0.2, 1)",
    "roughness": "0.8"
  }'
```

### 示例 5: Godot场景设置材质（GDScript）

```gdscript
# 在脚本中创建并应用材质
func _ready():
    # 创建StandardMaterial3D
    var material = StandardMaterial3D.new()
    material.albedo_color = Color(1, 0, 0, 1)  # 红色
    material.metallic = 0.5
    material.roughness = 0.2

    # 应用到MeshInstance3D
    if self is MeshInstance3D:
        self.material_override = material
```

### 示例 6: ShaderMaterial动态参数

```gdscript
# 动态修改Shader参数
func update_shader_time(material: ShaderMaterial, time: float):
    if material and material.shader:
        material.set_shader_parameter("time", time)
        material.set_shader_parameter("color", Vector3(0.5, 0.8, 1.0))
```

## 最佳实践

### ✅ 应该做的

1. **PBR原则**
   - metallic + roughness 总和应接近 1.0
   - 真实材质参考物理参数
   - 使用适当的高光（specular 0.0-1.0）

2. **纹理使用**
   - 法线贴图使用正确的空间（OpenGL或DirectX）
   - 纹理尺寸使用2的幂（256, 512, 1024...）
   - UI纹理关闭过滤，设置为Nearest

3. **移动平台优化**
   - 使用简单Shader，避免复杂计算
   - 纹理压缩使用ETC2或ASTC
   - 减少纹理采样次数

4. **着色器优化**
   - 避免在fragment shader中复杂计算
   - 预计算能移到vertex shader的内容
   - 使用uniform而不是硬编码值

5. **材质复用**
   - 创建基础材质，变体使用继承
   - 相同属性的材质合并

### ❌ 不应该做的

1. **过度使用透明材质**
   - 透明材质有排序性能开销
   - 能用不透明+镂空（Alpha Scissor）的就不用透明

2. **Shader中复杂分支**
   - 避免在shader中使用if-else
   - 使用step、smoothstep等内置函数

3. **过高纹理分辨率**
   - 根据显示尺寸选择纹理大小
   - 移动端避免使用2K+纹理

4. **运行时创建材质**
   - 预创建材质资源文件
   - 运行时使用material.duplicate()创建实例

5. **忽略性能分析**
   - 使用 Godot 的 Profiler
   - 检查每帧的Draw Call数

## Context7 集成

当创建材质时，自动使用 Context7 MCP 获取：
- 最新 Godot 材质系统文档
- PBR参数最佳实践
- Shader语言最新特性
- 性能优化建议

示例工作流程：
1. 用户请求创建特定材质
2. 触发 Context7 查询 Godot 材质文档
3. 获取参数说明和示例代码
4. 结合本技能生成完整材质
5. 提供优化建议

## MVP 模式

MVP（Minimum Viable Product）策略推荐：

如果项目对材质系统要求不高，可以：
- 创建少数几个基础材质（不透明、透明、发光）
- 使用 StandardMaterial3D 而非自定义Shader
- 适当使用纹理而非程序化纹理

示例MVP材质设置：
```bash
claude godot mvp_materials_setup --project_path="/mnt/d/game" \
  --create_basic_materials=true
```

## 版本控制

材质文件（.tres）应该：
- 提交到版本控制（文本格式）
- 使用相对路径引用纹理
- 避免硬编码的绝对路径

## ShaderMaterial vs StandardMaterial3D

### StandardMaterial3D 适用场景
- 常规PBR材质
- 不需要自定义效果
- 性能优先
- 快速迭代

### ShaderMaterial 适用场景
- 特殊视觉效果（水面、熔岩、魔法）
- 需要动态参数
- 顶点动画
- 高级光照计算

## 常见问题

### Q: 材质看起来太暗/太亮？
A: 检查albedo_color是否使用了纯白色（Color(1,1,1)），这会导致过曝。调整roughness和metallic值。

### Q: 法线贴图看起来不对？
A: 检查法线贴图空间（OpenGL vs DirectX），在材质设置中调整Normal Map的Flip Y选项。

### Q: 透明材质排序错误？
A: 在材质设置中调整Render Priority，或使用Alpha Scissor代替Alpha Blend。

### Q: Shader编译错误？
A: 使用Context7查询Shader语法，确保uniform类型匹配，检查Shader Mode（Spatial, CanvasItem, Particle）。

## 性能监控

使用 Godot 的 Debugger Monitor 检查：
- Draw Calls：每个材质至少增加1个Draw Call
- Shader 编译时间
- VRAM 使用量：纹理 + 材质

## 相关资源

- **Godot 官方材质文档**: https://docs.godotengine.org/zh-cn/stable/tutorials/3d/standard_material_3d.html
- **PBR指南**: https://docs.godotengine.org/zh-cn/stable/tutorials/3d/pbr.html
- **Shader教程**: https://docs.godotengine.org/zh-cn/stable/tutorials/shaders/shader_reference/index.html
- **Context7 Godot文档**: 自动获取最新材质API和最佳实践
