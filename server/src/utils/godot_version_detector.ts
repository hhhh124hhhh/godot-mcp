/**
 * Godot版本检测器
 * 用于检测项目中使用的Godot版本和配置信息
 */

import * as fs from 'fs';
import * as path from 'path';

export interface GodotVersionInfo {
  major: number;
  minor: number;
  patch?: number;
  versionString: string;
  features: string[];
  configPath: string;
}

export interface ProjectConfig {
  name: string;
  description?: string;
  version: string;
  godotVersion: GodotVersionInfo;
  autoloads: Record<string, string>;
}

export class GodotVersionDetector {
  private projectPath: string;
  private versionCache: Map<string, GodotVersionInfo> = new Map();

  constructor(projectPath: string = '') {
    this.projectPath = projectPath || process.cwd();
  }

  /**
   * 检测项目的Godot版本信息
   */
  async detectGodotVersion(): Promise<GodotVersionInfo | null> {
    const projectConfigPath = path.join(this.projectPath, 'project.godot');

    try {
      if (!fs.existsSync(projectConfigPath)) {
        console.log(`未找到project.godot文件: ${projectConfigPath}`);
        return null;
      }

      // 检查缓存
      const cacheKey = this.projectPath;
      if (this.versionCache.has(cacheKey)) {
        return this.versionCache.get(cacheKey)!;
      }

      const configContent = fs.readFileSync(projectConfigPath, 'utf-8');
      const versionInfo = this.parseProjectConfig(configContent, projectConfigPath);

      // 缓存结果
      this.versionCache.set(cacheKey, versionInfo);

      return versionInfo;
    } catch (error) {
      console.error('检测Godot版本时出错:', error);
      return null;
    }
  }

  /**
   * 解析project.godot配置文件
   */
  private parseProjectConfig(content: string, configPath: string): GodotVersionInfo {
    const lines = content.split('\n');
    let versionString = '4.0'; // 默认版本
    const features: string[] = [];

    // 解析config_version作为版本指标
    for (const line of lines) {
      const trimmed = line.trim();

      if (trimmed.startsWith('config_version=')) {
        versionString = trimmed.split('=')[1]?.replace(/"/g, '') || '4.0';
      }

      if (trimmed.startsWith('config/features=PackedStringArray')) {
        // 提取features数组
        const featuresMatch = trimmed.match(/\((.*?)\)/);
        if (featuresMatch) {
          const featuresStr = featuresMatch[1];
          const featureList = featuresStr.split(',').map(f =>
            f.trim().replace(/"/g, '')
          ).filter(f => f && f !== '4.5'); // 过滤掉版本号
          features.push(...featureList);
        }
      }
    }

    // 从config_version推断实际版本
    const godotVersion = this.inferGodotVersion(parseInt(versionString), features);

    return {
      ...godotVersion,
      versionString: `${godotVersion.major}.${godotVersion.minor}.${godotVersion.patch || 0}`,
      features,
      configPath
    };
  }

  /**
   * 从config_version推断Godot版本
   */
  private inferGodotVersion(configVersion: number, features: string[]): Omit<GodotVersionInfo, 'features' | 'configPath' | 'versionString'> {
    // Godot 4.x 的 config_version 映射
    if (configVersion === 5) {
      return {
        major: 4,
        minor: features.includes('4.5') ? 5 : 2, // 根据features判断具体版本
        patch: 0
      };
    } else if (configVersion === 4) {
      return {
        major: 4,
        minor: 0,
        patch: 0
      };
    } else if (configVersion === 3) {
      return {
        major: 3,
        minor: features.includes('3.5') ? 5 : features.includes('3.4') ? 4 : 0,
        patch: 0
      };
    }

    // 默认假设为Godot 4.x
    return {
      major: 4,
      minor: 2,
      patch: 0
    };
  }

  /**
   * 获取项目完整配置信息
   */
  async getProjectConfig(): Promise<ProjectConfig | null> {
    const versionInfo = await this.detectGodotVersion();
    if (!versionInfo) {
      return null;
    }

    try {
      const projectConfigPath = path.join(this.projectPath, 'project.godot');
      const content = fs.readFileSync(projectConfigPath, 'utf-8');

      return this.parseFullProjectConfig(content, versionInfo);
    } catch (error) {
      console.error('解析项目配置时出错:', error);
      return null;
    }
  }

  /**
   * 解析完整的项目配置
   */
  private parseFullProjectConfig(content: string, godotVersion: GodotVersionInfo): ProjectConfig {
    const lines = content.split('\n');
    let name = '';
    let description = '';
    let version = '1.0';
    const autoloads: Record<string, string> = {};

    for (const line of lines) {
      const trimmed = line.trim();

      if (trimmed.startsWith('config/name=')) {
        name = trimmed.split('=')[1]?.replace(/"/g, '') || '';
      } else if (trimmed.startsWith('config/description=')) {
        description = trimmed.split('=')[1]?.replace(/"/g, '') || '';
      } else if (trimmed.startsWith('config/display_version=')) {
        version = trimmed.split('=')[1]?.replace(/"/g, '') || '1.0';
      } else if (trimmed.startsWith('autoloads=')) {
        // 简化解析autoloads，实际实现可能需要更复杂的解析
        try {
          const autoloadsStr = trimmed.split('=')[1] || '{}';
          Object.assign(autoloads, JSON.parse(autoloadsStr.replace(/(\w+)/g, '"$1"')));
        } catch (e) {
          // 忽略解析错误，使用空对象
        }
      }
    }

    return {
      name,
      description,
      version,
      godotVersion,
      autoloads
    };
  }

  /**
   * 检查是否为Godot 4.x项目
   */
  async isGodot4(): Promise<boolean> {
    const versionInfo = await this.detectGodotVersion();
    return versionInfo?.major === 4 || false;
  }

  /**
   * 检查是否为Godot 3.x项目
   */
  async isGodot3(): Promise<boolean> {
    const versionInfo = await this.detectGodotVersion();
    return versionInfo?.major === 3 || false;
  }

  /**
   * 获取版本兼容性提示
   */
  getCompatibilityHints(versionInfo: GodotVersionInfo): string[] {
    const hints: string[] = [];

    if (versionInfo.major === 4) {
      hints.push('项目使用Godot 4.x API');
      hints.push('Tween系统已重写，使用tween_property()替代interpolate_property()');
      hints.push('输入系统有变化，使用InputEvent*新API');
      hints.push('Gradient API已更新，使用get_color()/set_color()替代get_color_at_offset()');
    } else if (versionInfo.major === 3) {
      hints.push('项目使用Godot 3.x API');
      hints.push('注意：部分API在Godot 4.x中已发生变化');
    }

    return hints;
  }

  /**
   * 清除版本缓存
   */
  clearCache(): void {
    this.versionCache.clear();
  }

  /**
   * 设置项目路径
   */
  setProjectPath(projectPath: string): void {
    this.projectPath = projectPath;
    this.clearCache(); // 清除旧缓存
  }
}

// 导出单例实例
export const godotVersionDetector = new GodotVersionDetector();