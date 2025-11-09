shader_type canvas_item;

// 泡泡Shader - 3D球体效果和高光
uniform vec4 bubble_color: source_color = vec4(0.4, 0.7, 1.0, 1.0);  // 主色调
uniform vec4 highlight_color: source_color = vec4(1.0, 1.0, 1.0, 0.8);  // 高光颜色
uniform float bubble_size: float = 0.8;  // 泡泡大小
uniform float highlight_size: float = 0.3;  // 高光大小
uniform float edge_softness: float = 0.1;  // 边缘柔和度
uniform float breathing_intensity: float = 0.1;  // 呼吸强度
uniform float time: float = 0.0;  // 时间值，用于动画，添加默认值

void vertex() {
    // 呼吸动画效果
    float breathing = sin(time * 2.0) * breathing_intensity + 1.0;
    VERTEX *= breathing;
}

void fragment() {
    // 使用正确的UV中心计算
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(UV, center);
    
    // 确保只渲染圆形区域，使用更小的阈值确保完全圆形
    if (dist > bubble_size * 0.95) {
        discard; // 完全透明处理，不渲染圆形外的区域
    }
    
    // 创建球形效果 - 使用更直接的计算
    float sphere_effect = 1.0 - (dist * dist / (bubble_size * bubble_size));
    sphere_effect = max(0.0, sphere_effect); // 确保不为负值
    
    // 增强边缘柔和效果
    float soft_edge = 1.0 - smoothstep(bubble_size * 0.8, bubble_size, dist);
    sphere_effect *= soft_edge;
    
    // 创建高光效果
    vec2 highlight_pos = vec2(0.3, 0.3);  // 高光位置（左上角）
    float highlight_dist = distance(UV, highlight_pos);
    float highlight = 1.0 - smoothstep(0.0, highlight_size, highlight_dist);
    highlight = pow(highlight, 4.0);  // 增强高光效果
    
    // 添加呼吸动画到高光
    float breathing_highlight = sin(time * 3.0) * 0.2 + 0.8;
    highlight *= breathing_highlight;
    
    // 组合颜色，增强主色调的影响，减少混合的影响
    vec3 base_color = bubble_color.rgb; // 直接使用主色调，不降低亮度
    vec3 highlight_effect = mix(base_color, highlight_color.rgb, highlight * 0.4); // 减少高光的影响
    vec3 final_color = mix(base_color, highlight_effect, sphere_effect * 0.5); // 使用混合模式确保主色调占主导
    float final_alpha = max(sphere_effect, highlight * 0.2) * bubble_color.a;
    
    // 添加边缘发光效果
    float glow_dist = distance(UV, center);
    float glow = smoothstep(bubble_size * 0.85, bubble_size, glow_dist);
    glow *= (1.0 - glow) * 2.0;  // 边缘发光
    
    // 使用泡泡的主色调作为发光颜色
    vec3 glow_color = bubble_color.rgb;
    final_color += glow_color * glow * 0.2;
    
    // 确保颜色不会过曝
    final_color = min(final_color, vec3(1.0, 1.0, 1.0));
    
    // 输出最终颜色，确保alpha通道正确
    COLOR = vec4(final_color, final_alpha);
}