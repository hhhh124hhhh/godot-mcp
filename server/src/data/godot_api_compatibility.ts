/**
 * Godot API兼容性数据库
 * 包含Godot 3.x和4.x之间的API差异映射
 */

export interface APIChange {
  category: 'tween' | 'gradient' | 'input' | 'node' | 'signal' | 'general' | 'particles' | 'shader' | 'property';
  godot3Method?: string;
  godot4Method?: string;
  description: string;
  migrationNotes: string;
  exampleCode?: {
    godot3?: string;
    godot4?: string;
  };
  severity: 'breaking' | 'deprecated' | 'changed';
}

export interface CompatibilityRule {
  pattern: RegExp;
  check: (matches: RegExpMatchArray, context: any) => Promise<APIChange | null>;
}

export class GodotAPICompatibilityDatabase {
  private apiChanges: Map<string, APIChange[]> = new Map();

  constructor() {
    this.initializeDatabase();
  }

  private initializeDatabase(): void {
    // Tween系统变化
    this.apiChanges.set('tween', [
      {
        category: 'tween',
        godot3Method: 'interpolate_property',
        godot4Method: 'tween_property',
        description: 'Tween系统完全重写，方法名和用法发生变化',
        migrationNotes: '在Godot 4.x中，Tween需要先创建，然后调用tween_property。set_looped()已被移除，使用callback循环代替。',
        exampleCode: {
          godot3: `# Godot 3.x
$Tween.interpolate_property(self, "position", start_pos, end_pos, 1.0, Tween.TRANS_SINE)
$Tween.start()`,
          godot4: `# Godot 4.x
var tween = create_tween()
tween.tween_property(self, "position", end_pos, 1.0).set_trans(Tween.TRANS_SINE)`
        },
        severity: 'breaking'
      },
      {
        category: 'tween',
        godot3Method: 'set_looped',
        godot4Method: 'callback_based_loop',
        description: 'Tween.set_looped()方法已被移除',
        migrationNotes: '使用tween_callback()实现循环动画',
        exampleCode: {
          godot3: `# Godot 3.x
tween.set_looped(true)`,
          godot4: `# Godot 4.x
func animate_loop():
    var tween = create_tween()
    # 动画代码...
    tween.tween_callback(animate_loop)  # 循环调用`
        },
        severity: 'breaking'
      }
    ]);

    // Gradient系统变化
    this.apiChanges.set('gradient', [
      {
        category: 'gradient',
        godot3Method: 'get_color_at_offset',
        godot4Method: 'get_color',
        description: 'Gradient.get_color_at_offset()方法已被移除',
        migrationNotes: '使用基于索引的get_color(index)和set_color(index, color)方法',
        exampleCode: {
          godot3: `# Godot 3.x
var color = gradient.get_color_at_offset(0.5)`,
          godot4: `# Godot 4.x
var color = gradient.get_color(1)  # 假设0.5对应第2个点
gradient.set_color(1, new_color)`
        },
        severity: 'breaking'
      }
    ]);

    // 输入系统变化
    this.apiChanges.set('input', [
      {
        category: 'input',
        godot3Method: 'is_action_just_pressed',
        godot4Method: 'Input.is_action_just_pressed',
        description: '输入系统API略有调整',
        migrationNotes: '大部分输入方法保持不变，但一些常量和方法位置发生变化',
        exampleCode: {
          godot3: `# Godot 3.x
if Input.is_action_just_pressed("ui_accept"):`,
          godot4: `# Godot 4.x
if Input.is_action_just_pressed("ui_accept"):`
        },
        severity: 'changed'
      },
      {
        category: 'input',
        godot3Method: 'MOUSE_BUTTON_LEFT',
        godot4Method: 'MOUSE_BUTTON_LEFT',
        description: '鼠标按钮常量保持不变，但使用方式略有调整',
        migrationNotes: 'InputEventMouseButton的button_index属性使用相同的常量值',
        exampleCode: {
          godot3: `# Godot 3.x
if event.button_index == BUTTON_LEFT:`,
          godot4: `# Godot 4.x
if event.button_index == MOUSE_BUTTON_LEFT:`
        },
        severity: 'changed'
      }
    ]);

    // 节点和场景树变化
    this.apiChanges.set('node', [
      {
        category: 'node',
        godot3Method: 'get_node',
        godot4Method: 'get_node',
        description: 'get_node()方法保持不变，但安全性检查更严格',
        migrationNotes: '建议使用has_node()进行安全检查，或使用get_node_or_null()',
        exampleCode: {
          godot3: `# Godot 3.x
var node = get_node("Path/To/Node")`,
          godot4: `# Godot 4.x
# 安全的节点访问
var node = get_node_or_null("Path/To/Node")
if node:
    # 使用节点`
        },
        severity: 'changed'
      },
      {
        category: 'node',
        godot3Method: 'queue_free',
        godot4Method: 'queue_free',
        description: 'queue_free()方法保持不变，但调用时机需要注意',
        migrationNotes: '避免在信号处理过程中直接调用queue_free()，使用call_deferred()延迟执行',
        exampleCode: {
          godot3: `# Godot 3.x
emit_signal("some_signal")
queue_free()`,
          godot4: `# Godot 4.x
emit_signal("some_signal")
call_deferred("queue_free")  # 更安全`
        },
        severity: 'changed'
      }
    ]);

    // 信号系统变化
    this.apiChanges.set('signal', [
      {
        category: 'signal',
        godot3Method: 'connect',
        godot4Method: 'connect',
        description: '信号连接语法略有变化',
        migrationNotes: '在Godot 4.x中，可以使用更简洁的lambda表达式语法',
        exampleCode: {
          godot3: `# Godot 3.x
button.connect("pressed", self, "_on_button_pressed")`,
          godot4: `# Godot 4.x
button.pressed.connect(_on_button_pressed)
# 或者使用lambda
button.pressed.connect(func(): print("Button pressed"))`
        },
        severity: 'changed'
      }
    ]);

    // 属性检查方法变化
    this.apiChanges.set('property', [
      {
        category: 'property',
        godot3Method: 'has_property',
        godot4Method: 'direct_get_or_null_check',
        description: 'has_property()方法在Godot 4.x中已被移除',
        migrationNotes: '使用直接get()方法并检查返回值，或使用get_property_list()进行属性检查',
        exampleCode: {
          godot3: `# Godot 3.x
if node.has_property("custom_property"):
    value = node.get("custom_property")`,
          godot4: `# Godot 4.x - 方法1：直接获取并检查
var value = node.get("custom_property")
if value != null:
    # 属性存在

# 方法2：使用属性列表（如果需要名称检查）
var property_list = node.get_property_list()
for prop in property_list:
    if prop.name == "custom_property":
        # 找到属性`
        },
        severity: 'breaking'
      }
    ]);

    // 通用API变化
    this.apiChanges.set('general', [
      {
        category: 'general',
        godot3Method: 'ColorRect',
        godot4Method: 'TextureRect',
        description: '对于渐变背景，TextureRect比ColorRect更适合',
        migrationNotes: 'TextureRect支持GradientTexture2D，提供更好的渐变支持',
        exampleCode: {
          godot3: `# Godot 3.x
var color_rect = ColorRect.new()
color_rect.color = Color.BLUE`,
          godot4: `# Godot 4.x
var texture_rect = TextureRect.new()
var gradient = GradientTexture2D.new()
texture_rect.texture = gradient`
        },
        severity: 'deprecated'
      },
      {
        category: 'general',
        godot3Method: 'ParticlesMaterial',
        godot4Method: 'ParticleProcessMaterial',
        description: '粒子材质重命名，属性也发生变化',
        migrationNotes: 'ParticlesMaterial重命名为ParticleProcessMaterial，属性名称也更新',
        exampleCode: {
          godot3: `# Godot 3.x
var material = ParticlesMaterial.new()
material.explosiveness = 1.0
material.initial_velocity_min = 100.0`,
          godot4: `# Godot 4.x
var material = ParticleProcessMaterial.new()
material.direction = Vector3.UP
material.initial_velocity_min = 100.0`
        },
        severity: 'breaking'
      }
    ]);

    // 粒子系统属性变化
    this.apiChanges.set('particles', [
      {
        category: 'particles',
        godot3Method: 'explosiveness',
        godot4Method: 'direction + spread',
        description: 'explosiveness属性被direction和spread替代',
        migrationNotes: '使用direction和spread属性控制粒子发射方向和扩散程度',
        exampleCode: {
          godot3: `# Godot 3.x
material.explosiveness = 1.0`,
          godot4: `# Godot 4.x
material.direction = Vector3.UP
material.spread = 45.0  # 扩散角度`
        },
        severity: 'breaking'
      },
      {
        category: 'particles',
        godot3Method: 'amount',
        godot4Method: 'emission_amount',
        description: 'amount属性重命名为emission_amount',
        migrationNotes: 'ParticleProcessMaterial中amount改为emission_amount',
        exampleCode: {
          godot3: `# Godot 3.x
material.amount = 50`,
          godot4: `# Godot 4.x
material.emission_amount = 50`
        },
        severity: 'breaking'
      },
      {
        category: 'particles',
        godot3Method: 'material.emission_amount',
        godot4Method: 'particles.amount',
        description: 'emission_amount应该在GPUParticles节点而非Material上设置',
        migrationNotes: '在Godot 4.x中，粒子数量应该设置在GPUParticles2D/3D节点的amount属性上，而不是ParticleProcessMaterial上',
        exampleCode: {
          godot3: `# Godot 3.x (或Godot 4.x错误用法)
material.emission_amount = 50  # 错误！会导致类型不匹配`,
          godot4: `# Godot 4.x 正确用法
particles.amount = 50  # 在GPUParticles2D/3D节点上设置`
        },
        severity: 'breaking'
      },
      {
        category: 'particles',
        godot3Method: 'scale_amount_min/max',
        godot4Method: 'scale_min/max',
        description: '缩放属性名称简化',
        migrationNotes: 'scale_amount_min和scale_amount_max改为scale_min和scale_max',
        exampleCode: {
          godot3: `# Godot 3.x
material.scale_amount_min = 0.1
material.scale_amount_max = 0.3`,
          godot4: `# Godot 4.x
material.scale_min = 0.1
material.scale_max = 0.3`
        },
        severity: 'breaking'
      },
      {
        category: 'particles',
        godot3Method: 'material.lifetime',
        godot4Method: 'particles.lifetime',
        description: 'lifetime应该在GPUParticles节点而非Material上设置',
        migrationNotes: '在Godot 4.x中，粒子生命周期应该设置在GPUParticles2D/3D节点的lifetime属性上，而不是ParticleProcessMaterial上',
        exampleCode: {
          godot3: `# Godot 3.x (或Godot 4.x错误用法)
material.lifetime = 2.0  # 错误！会导致类型不匹配`,
          godot4: `# Godot 4.x 正确用法
particles.lifetime = 2.0  # 在GPUParticles2D/3D节点上设置`
        },
        severity: 'breaking'
      },
      {
        category: 'particles',
        godot3Method: 'material.one_shot',
        godot4Method: 'particles.one_shot',
        description: 'one_shot应该在GPUParticles节点而非Material上设置',
        migrationNotes: '在Godot 4.x中，单次发射模式应该设置在GPUParticles2D/3D节点的one_shot属性上，而不是ParticleProcessMaterial上',
        exampleCode: {
          godot3: `# Godot 3.x (或Godot 4.x错误用法)
material.one_shot = true  # 错误！会导致类型不匹配`,
          godot4: `# Godot 4.x 正确用法
particles.one_shot = true  # 在GPUParticles2D/3D节点上设置`
        },
        severity: 'breaking'
      },
      {
        category: 'particles',
        godot3Method: 'material.randomness',
        godot4Method: 'particles.randomness',
        description: 'randomness应该在GPUParticles节点而非Material上设置',
        migrationNotes: '在Godot 4.x中，随机性应该设置在GPUParticles2D/3D节点的randomness属性上，而不是ParticleProcessMaterial上',
        exampleCode: {
          godot3: `# Godot 3.x (或Godot 4.x错误用法)
material.randomness = 0.5  # 错误！会导致类型不匹配`,
          godot4: `# Godot 4.x 正确用法
particles.randomness = 0.5  # 在GPUParticles2D/3D节点上设置`
        },
        severity: 'breaking'
      },
      {
        category: 'particles',
        godot3Method: 'material.fixed_fps',
        godot4Method: 'particles.fixed_fps',
        description: 'fixed_fps应该在GPUParticles节点而非Material上设置',
        migrationNotes: '在Godot 4.x中，固定帧率应该设置在GPUParticles2D/3D节点的fixed_fps属性上，而不是ParticleProcessMaterial上',
        exampleCode: {
          godot3: `# Godot 3.x (或Godot 4.x错误用法)
material.fixed_fps = 30  # 错误！会导致类型不匹配`,
          godot4: `# Godot 4.x 正确用法
particles.fixed_fps = 30  # 在GPUParticles2D/3D节点上设置`
        },
        severity: 'breaking'
      }
    ]);
  }

  /**
   * 根据方法名查找API变化
   */
  findAPIChange(methodName: string): APIChange | null {
    for (const [category, changes] of Array.from(this.apiChanges.entries())) {
      const change = changes.find((c: APIChange) =>
        c.godot3Method === methodName ||
        c.godot4Method === methodName
      );
      if (change) {
        return change;
      }
    }
    return null;
  }

  /**
   * 获取指定类别的所有API变化
   */
  getAPIChangesByCategory(category: string): APIChange[] {
    return this.apiChanges.get(category) || [];
  }

  /**
   * 获取所有破坏性变化
   */
  getBreakingChanges(): APIChange[] {
    const breakingChanges: APIChange[] = [];
    for (const [category, changes] of Array.from(this.apiChanges.entries())) {
      breakingChanges.push(...changes.filter((c: APIChange) => c.severity === 'breaking'));
    }
    return breakingChanges;
  }

  /**
   * 获取Godot 3.x到4.x的所有变化
   */
  getAllChanges(): APIChange[] {
    const allChanges: APIChange[] = [];
    for (const [category, changes] of Array.from(this.apiChanges.entries())) {
      allChanges.push(...changes);
    }
    return allChanges;
  }

  /**
   * 生成兼容性检查规则
   */
  generateCompatibilityRules(): CompatibilityRule[] {
    const rules: CompatibilityRule[] = [];

    // has_property相关的检查规则
    rules.push({
      pattern: /\.has_property\s*\(/,
      check: async (matches, context) => {
        return {
          category: 'property',
          godot3Method: 'has_property',
          godot4Method: 'direct_get_or_null_check',
          description: 'has_property()在Godot 4.x中已被移除',
          migrationNotes: '使用直接get()方法并检查返回值，或使用get_property_list()进行属性检查',
          exampleCode: {
            godot4: `# Godot 4.x - 方法1：直接获取并检查
var value = node.get("property_name")
if value != null:
    # 属性存在

# 方法2：使用属性列表
var property_list = node.get_property_list()
for prop in property_list:
    if prop.name == "property_name":
        # 找到属性`
          },
          severity: 'breaking'
        };
      }
    });

    // Tween相关的检查规则
    rules.push({
      pattern: /\.set_looped\s*\(/,
      check: async (matches, context) => {
        return {
          category: 'tween',
          description: 'set_looped()在Godot 4.x中已被移除',
          migrationNotes: '使用callback循环代替',
          exampleCode: {
            godot4: `func animate_loop():
    var tween = create_tween()
    # 动画代码...
    tween.tween_callback(animate_loop)`
          },
          severity: 'breaking'
        };
      }
    });

    // Gradient相关的检查规则
    rules.push({
      pattern: /\.get_color_at_offset\s*\(/,
      check: async (matches, context) => {
        return {
          category: 'gradient',
          description: 'get_color_at_offset()在Godot 4.x中已被移除',
          migrationNotes: '使用基于索引的get_color()方法',
          exampleCode: {
            godot4: `var color = gradient.get_color(index)
gradient.set_color(index, new_color)`
          },
          severity: 'breaking'
        };
      }
    });

    // ColorRect使用检查规则
    rules.push({
      pattern: /ColorRect/,
      check: async (matches, context) => {
        return {
          category: 'general',
          description: '对于渐变效果，建议使用TextureRect',
          migrationNotes: 'TextureRect与GradientTexture2D配合使用效果更好',
          exampleCode: {
            godot4: `var texture_rect = TextureRect.new()
var gradient = GradientTexture2D.new()
texture_rect.texture = gradient`
          },
          severity: 'deprecated'
        };
      }
    });

    rules.push({
      pattern: /get_shader_parameter\([^)]+\)\s*[+\-*/]/,
      check: async (matches, context) => {
        return {
          category: 'shader',
          description: 'get_shader_parameter()可能返回null，需要类型转换后进行算术运算',
          migrationNotes: '使用类型转换确保返回值类型正确',
          exampleCode: {
            godot4: `# 错误的方式
shader_param + 0.1

# 正确的方式
var param_value = shader_param as float
param_value + 0.1`
          },
          severity: 'breaking'
        };
      }
    });

    // 粒子系统的emission_amount属性访问检查规则
    rules.push({
      pattern: /(?:\w+\.)?material\s*\.\s*emission_amount\s*=/,
      check: async (matches, context) => {
        return {
          category: 'particles',
          godot3Method: 'material.emission_amount',
          godot4Method: 'particles.amount',
          description: 'emission_amount应该在GPUParticles节点而非Material上设置',
          migrationNotes: '在Godot 4.x中，粒子数量应该设置在GPUParticles2D/3D节点的amount属性上，而不是ParticleProcessMaterial上',
          exampleCode: {
            godot4: `# 错误用法 - 会导致类型不匹配错误
material.emission_amount = 50

# 正确用法 - 在GPUParticles2D/3D节点上设置
particles.amount = 50`
          },
          severity: 'breaking'
        };
      }
    });

    // 粒子系统的lifetime属性访问检查规则
    rules.push({
      pattern: /(?:\w+\.)?material\s*\.\s*lifetime\s*=/,
      check: async (matches, context) => {
        return {
          category: 'particles',
          godot3Method: 'material.lifetime',
          godot4Method: 'particles.lifetime',
          description: 'lifetime应该在GPUParticles节点而非Material上设置',
          migrationNotes: '在Godot 4.x中，粒子生命周期应该设置在GPUParticles2D/3D节点的lifetime属性上，而不是ParticleProcessMaterial上',
          exampleCode: {
            godot4: `# 错误用法 - 会导致类型不匹配错误
material.lifetime = 2.0

# 正确用法 - 在GPUParticles2D/3D节点上设置
particles.lifetime = 2.0`
          },
          severity: 'breaking'
        };
      }
    });

    // 粒子系统的one_shot属性访问检查规则
    rules.push({
      pattern: /(?:\w+\.)?material\s*\.\s*one_shot\s*=/,
      check: async (matches, context) => {
        return {
          category: 'particles',
          godot3Method: 'material.one_shot',
          godot4Method: 'particles.one_shot',
          description: 'one_shot应该在GPUParticles节点而非Material上设置',
          migrationNotes: '在Godot 4.x中，单次发射模式应该设置在GPUParticles2D/3D节点的one_shot属性上，而不是ParticleProcessMaterial上',
          exampleCode: {
            godot4: `# 错误用法 - 会导致类型不匹配错误
material.one_shot = true

# 正确用法 - 在GPUParticles2D/3D节点上设置
particles.one_shot = true`
          },
          severity: 'breaking'
        };
      }
    });

    // 粒子系统的randomness属性访问检查规则
    rules.push({
      pattern: /(?:\w+\.)?material\s*\.\s*randomness\s*=/,
      check: async (matches, context) => {
        return {
          category: 'particles',
          godot3Method: 'material.randomness',
          godot4Method: 'particles.randomness',
          description: 'randomness应该在GPUParticles节点而非Material上设置',
          migrationNotes: '在Godot 4.x中，随机性应该设置在GPUParticles2D/3D节点的randomness属性上，而不是ParticleProcessMaterial上',
          exampleCode: {
            godot4: `# 错误用法 - 会导致类型不匹配错误
material.randomness = 0.5

# 正确用法 - 在GPUParticles2D/3D节点上设置
particles.randomness = 0.5`
          },
          severity: 'breaking'
        };
      }
    });

    // 粒子系统的fixed_fps属性访问检查规则
    rules.push({
      pattern: /(?:\w+\.)?material\s*\.\s*fixed_fps\s*=/,
      check: async (matches, context) => {
        return {
          category: 'particles',
          godot3Method: 'material.fixed_fps',
          godot4Method: 'particles.fixed_fps',
          description: 'fixed_fps应该在GPUParticles节点而非Material上设置',
          migrationNotes: '在Godot 4.x中，固定帧率应该设置在GPUParticles2D/3D节点的fixed_fps属性上，而不是ParticleProcessMaterial上',
          exampleCode: {
            godot4: `# 错误用法 - 会导致类型不匹配错误
material.fixed_fps = 30

# 正确用法 - 在GPUParticles2D/3D节点上设置
particles.fixed_fps = 30`
          },
          severity: 'breaking'
        };
      }
    });

    return rules;
  }

  /**
   * 获取迁移建议
   */
  getMigrationAdvice(fromVersion: string, toVersion: string): string[] {
    const advice: string[] = [];

    if (fromVersion.startsWith('3.') && toVersion.startsWith('4.')) {
      advice.push('主要变化：Tween系统完全重写');
      advice.push('主要变化：输入系统API调整');
      advice.push('主要变化：Gradient API更新');
      advice.push('建议：使用get_node_or_null()进行安全的节点访问');
      advice.push('建议：使用call_deferred("queue_free")延迟删除节点');
      advice.push('建议：更新信号连接语法，使用新的lambda表达式');
    }

    return advice;
  }

  /**
   * 检查代码中的兼容性问题
   */
  async checkCompatibility(code: string, targetVersion: '3.x' | '4.x'): Promise<APIChange[]> {
    const issues: APIChange[] = [];
    const rules = this.generateCompatibilityRules();

    for (const rule of rules) {
      const matches = code.match(rule.pattern);
      if (matches) {
        const issue = await rule.check(matches, { code, targetVersion });
        if (issue) {
          issues.push(issue);
        }
      }
    }

    return issues;
  }

  /**
   * 生成修复代码
   */
  generateFix(originalCode: string, issue: APIChange): string | null {
    if (!issue.exampleCode?.godot4) {
      return null;
    }

    let fixedCode = originalCode;

    switch (issue.godot3Method) {
      case 'has_property':
        // 替换has_property调用
        fixedCode = fixedCode.replace(/(\w+)\.has_property\s*\(\s*["']([^"']+)["']\s*\)/g,
          (match, objectName, propertyName) => {
            return `var ${propertyName}_value = ${objectName}.get("${propertyName}")\nif ${propertyName}_value != null:  # 修复：has_property()改为get()+null检查`;
          });
        break;

      case 'set_looped':
        // 替换set_looped调用
        fixedCode = fixedCode.replace(/(\w+)\.set_looped\s*\([^)]*\)/g,
          '# $1.set_looped() 已移除，请使用callback循环');
        break;

      case 'get_color_at_offset':
        // 替换get_color_at_offset调用
        fixedCode = fixedCode.replace(/gradient\.get_color_at_offset\s*\([^)]*\)/g,
          'gradient.get_color(index)  # 请替换为正确的索引');
        break;

      case 'ColorRect':
        // 建议使用TextureRect
        fixedCode = fixedCode.replace(/ColorRect/g, 'TextureRect  # 建议使用TextureRect处理渐变');
        break;

      case 'material.emission_amount':
        // 修复material.emission_amount的错误用法
        fixedCode = fixedCode.replace(/(?:\w+\.)?material\s*\.\s*emission_amount\s*=\s*([^;\n]+)/g,
          (match, value) => {
            // 使用默认的particles变量名
            const particlesName = 'particles';
            return `${particlesName}.amount = ${value}  # 修复：从material.emission_amount改为particles.amount`;
          });
        break;

      case 'material.lifetime':
        // 修复material.lifetime的错误用法
        fixedCode = fixedCode.replace(/(?:\w+\.)?material\s*\.\s*lifetime\s*=\s*([^;\n]+)/g,
          (match, value) => {
            const particlesName = 'particles';
            return `${particlesName}.lifetime = ${value}  # 修复：从material.lifetime改为particles.lifetime`;
          });
        break;

      case 'material.one_shot':
        // 修复material.one_shot的错误用法
        fixedCode = fixedCode.replace(/(?:\w+\.)?material\s*\.\s*one_shot\s*=\s*([^;\n]+)/g,
          (match, value) => {
            const particlesName = 'particles';
            return `${particlesName}.one_shot = ${value}  # 修复：从material.one_shot改为particles.one_shot`;
          });
        break;

      case 'material.randomness':
        // 修复material.randomness的错误用法
        fixedCode = fixedCode.replace(/(?:\w+\.)?material\s*\.\s*randomness\s*=\s*([^;\n]+)/g,
          (match, value) => {
            const particlesName = 'particles';
            return `${particlesName}.randomness = ${value}  # 修复：从material.randomness改为particles.randomness`;
          });
        break;

      case 'material.fixed_fps':
        // 修复material.fixed_fps的错误用法
        fixedCode = fixedCode.replace(/(?:\w+\.)?material\s*\.\s*fixed_fps\s*=\s*([^;\n]+)/g,
          (match, value) => {
            const particlesName = 'particles';
            return `${particlesName}.fixed_fps = ${value}  # 修复：从material.fixed_fps改为particles.fixed_fps`;
          });
        break;
    }

    // 添加修复说明注释
    if (fixedCode !== originalCode) {
      fixedCode += `\n\n# 修复说明: ${issue.description}\n# 建议: ${issue.migrationNotes}`;
    }

    return fixedCode;
  }
}

// 导出单例实例
export const godotAPICompatibilityDB = new GodotAPICompatibilityDatabase();