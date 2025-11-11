---
name: Godot Resource Workflow
version: 1.0.0
description: 提供完整的Godot资源文件（.tres）管理能力，支持资源创建、修改、批量处理和依赖关系管理，优化资源工作流
---

# Godot 资源工作流程技能

本技能为Godot开发者提供完整的资源文件管理能力，支持.tres资源的创建、修改、批量处理、依赖解析和资源优化，构建高效的资源工作流。

## 触发条件

- 需要创建或修改资源文件（.tres, .res）
- 提及"资源管理"、"资源依赖"、"批量导入资源"
- 需要分析资源依赖关系或解决资源冲突
- 需要批量处理资源（如批量修改材质、纹理设置）
- 需要导入外部资源或优化现有资源

## 核心功能

### 1. 资源文件创建与管理
支持创建和编辑各种Godot资源类型：
- StandardMaterial3D / ShaderMaterial
- Texture2D / Texture3D / TextureArray
- Mesh 资源（ArrayMesh, PrimitiveMesh）
- Script 资源（GDScript）
- Scene 资源（PackedScene）
- Audio 资源（AudioStream）

### 2. 资源依赖关系管理
自动分析和处理资源间的依赖关系：
- 材质依赖纹理和Shader
- Script依赖其他脚本（继承）
- Scene依赖子场景和资源
- 依赖关系可视化
- 循环依赖检测和修复

### 3. 批量资源处理
支持批量操作多个资源：
- 批量修改资源属性
- 批量转换资源格式
- 批量重命名和整理
- 批量导入和导出

### 4. 资源优化与压缩
提供资源优化建议和实施：
- 纹理压缩（VRAM压缩、ETC2、S3TC）
- 网格优化（LOD、批量合并）
- 音频优化（压缩格式、比特率）
- 资源文件大小优化

## 执行步骤

### 创建资源文件

1. **规划资源类型**
   - 确定需要的资源类型
   - 设计资源属性（PBR材质、纹理分辨率等）
   - 考虑性能影响（移动端vs桌面端）

2. **准备资源素材**
   - 纹理图片（PNG, JPG, WebP）
   - 3D模型文件（GLTF, FBX, OBJ）
   - 音频文件（WAV, MP3, OGG）
   - Shader代码（.gdshader）

3. **执行资源创建**
   - 使用 Godot 编辑器或 MCP 工具创建资源
   - 配置资源属性
   - 设置资源导入参数

4. **验证和测试**
   - 在场景中测试资源
   - 检查视觉/音频效果
   - 验证性能

### 批量处理资源

1. **选择目标资源**
   - 确定资源路径或通配符模式
   - 筛选符合条件的资源

2. **定义处理操作**
   - 确定要执行的操作（修改属性、转换格式等）
   - 准备操作参数

3. **执行批量处理**
   - 遍历所有目标资源
   - 应用操作
   - 记录处理结果

4. **验证结果**
   - 检查处理后的资源
   - 验证项目仍然能正常运行

## 代码示例

### 示例 1: 创建标准材质资源

```bash
# 创建 StandardMaterial3D 资源
claude godot create_resource --project_path="/mnt/d/godot-projects/my-game" \
  --resource_type="StandardMaterial3D" \
  --resource_path="res://materials/ground.tres" \
  --properties='{
    "albedo_color": "Color(0.2, 0.5, 0.2, 1)",
    "metallic": 0.0,
    "roughness": 0.8
  }'
```

### 示例 2: 批量修改材质纹理

```bash
# 将所有材质的纹理过滤模式改为 Nearest
claude godot batch_update_resources --resource_pattern="res://materials/*.tres" \
  --property="texture_filter" \
  --value="BaseMaterial3D.TEXTURE_FILTER_NEAREST"
```

### 示例 3: 分析资源依赖关系

```bash
# 分析场景的资源依赖
claude godot analyze_dependencies --resource_path="res://scenes/main_level.tscn"

# 输出：列出所有依赖的纹理、材质、脚本等资源
```

### 示例 4: 批量导入纹理并设置参数

```bash
# 批量导入纹理并设置为重复模式
claude godot batch_import_textures --source_dir="assets/textures/tiles" \
  --import_to="res://textures/tiles" \
  --import_flags='{
    "repeat": true,
    "filter": false,
    "compress": "VRAM_COMPRESSED"
  }'
```

### 示例 5: 创建 ShaderMaterial 并应用Shader

```bash
# 创建 ShaderMaterial 并关联 Shader
claude godot create_shader_material --project_path="/mnt/d/godot-project" \
  --material_path="res://materials/water.tres" \
  --shader_path="res://shaders/water.gdshader" \
  --shader_params='{
    "wave_speed": 1.5,
    "wave_height": 0.2,
    "color": "Vector3(0.1, 0.3, 0.8)"
  }'
```

## 最佳实践

### ✅ 应该做的

1. **使用一致的命名规范**
   - 材质：`material_材质名.tres`
   - 纹理：`tex_用途名.png`
   - 脚本：`class_类名.gd`
   - 音频：`sfx_音效名.wav`, `bgm_音乐名.ogg`

2. **组织清晰的目录结构**
   ```
   res://
   ├── materials/      # 材质资源
   ├── textures/       # 纹理图片
   ├── meshes/         # 3D模型
   ├── shaders/        # Shader文件
   ├── audio/          # 音频文件
   │   ├── sfx/        # 音效
   │   └── bgm/        # 背景音乐
   └── fonts/          # 字体
   ```

3. **合理使用资源继承**
   - 创建基础材质，其他材质继承并覆盖
   - 基础脚本提供通用功能

4. **资源导入优化**
   - 移动端：使用 VRAM 压缩，降低分辨率
   - 桌面端：可使用高分辨率，减少压缩
   - UI纹理：关闭过滤，使用精确尺寸

5. **定期清理未使用资源**
   - 使用 Godot 的 "Find in Files" 检查资源引用
   - 删除未使用的旧资源

### ❌ 不应该做的

1. **避免在运行时创建大量资源**
   - 运行时创建资源会导致性能问题
   - 应在编辑器中预创建资源

2. **不要将纹理保持为超大尺寸**
   - 根据实际显示尺寸调整纹理大小
   - 2D精灵通常不需要 4K 纹理

3. **避免循环依赖**
   - 材质 A 依赖材质 B，材质 B 又依赖材质 A
   - 使用基础材质打破循环

4. **不要使用绝对路径**
   - 使用 `res://` 相对路径
   - 避免跨项目引用

5. **不要提交导入缓存**
   - `.import/` 目录不应提交到版本控制
   - 只提交源文件（PNG, GDScript等）

## 性能优化技巧

### 纹理优化
- 使用 2 的幂次方尺寸（如 256x256, 512x512）
- 对于不需要透明的纹理，关闭 Alpha 通道
- 使用纹理图集（Atlas）减少Draw Call

### 音频优化
- 背景音乐使用 OGG Vorbis 格式
- 短音效使用 WAV（无压缩）
- 根据平台调整采样率（移动端 22kHz-44kHz）

### 3D模型优化
- 合并小物体减少Draw Call
- 使用LOD（Level of Detail）
- 合理使用遮挡剔除

## 常见问题

### Q: 资源文件(.tres)丢失依赖怎么办？
A: 使用 Godot 编辑器的依赖查看器，手动重新指定路径，或使用 MCP 工具批量修复。

### Q: 批量处理后游戏变慢了？
A: 检查纹理压缩设置，确保使用了合适的压缩格式。检查是否创建了过多小纹理，考虑使用图集。

### Q: 如何找出未使用的资源？
A: 使用编辑器的查找功能搜索资源引用，或使用第三方工具分析项目。

### Q: ShaderMaterial 修改后没有效果？
A: 确保 Shader 代码正确编译，检查 Shader 参数是否正确传递。使用 MCP 工具验证 Shader 参数类型。

## MCP 工具集成

本技能与以下 Godot MCP 工具配合使用：

### 已支持的工具
- `update_node_property` - 将资源应用到节点
- `get_node_properties` - 检查节点当前资源
- `create_node` - 创建节点并附加资源
- `create_material` - 创建材质资源（需要开发支持）

### 计划开发的工具
基于本技能需求，需要在 Godot MCP 中添加：
- `create_resource` - 创建资源文件
- `modify_resource` - 修改资源属性
- `analyze_dependencies` - 分析资源依赖
- `batch_modify_resources` - 批量修改资源

## Context7 集成

本技能与 Context7 MCP 集成，可自动获取：
- 最新 Godot 资源系统文档
- 材质参数说明和最佳实践
- 性能优化建议
- 版本兼容性信息

当需要创建特定资源的实现代码时，自动使用 Context7 获取最新 API 文档和示例。

## 版本控制

### Git LFS 推荐配置
对于大型资源（纹理、音频、模型），建议使用 Git LFS：

```
# .gitattributes
*.png filter=lfs diff=lfs merge=lfs -text
*.jpg filter=lfs diff=lfs merge=lfs -text
*.wav filter=lfs diff=lfs merge=lfs -text
*.mp3 filter=lfs diff=lfs merge=lfs -text
*.fbx filter=lfs diff=lfs merge=lfs -text
*.gltf filter=lfs diff=lfs merge=lfs -text
```

### .gitignore 配置
```
# Godot 4+ specific ignores
.import/
export.cfg
export_presets.cfg
.idea/
.vscode/
```
