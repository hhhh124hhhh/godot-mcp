import { z } from 'zod';
import { MCPTool } from '../utils/types.js';
import { godotVersionDetector } from '../utils/godot_version_detector.js';
import { godotAPICompatibilityDB } from '../data/godot_api_compatibility.js';

/**
 * Godot版本检测工具
 */
const detectGodotVersionTool: MCPTool = {
  name: 'detect_godot_version',
  description: '检测项目中使用的Godot版本和配置信息',
  parameters: z.object({
    projectPath: z.string().optional().describe('项目路径，默认为当前工作目录')
  }),
  execute: async (args) => {
    try {
      if (args.projectPath) {
        godotVersionDetector.setProjectPath(args.projectPath);
      }

      const versionInfo = await godotVersionDetector.detectGodotVersion();
      const projectConfig = await godotVersionDetector.getProjectConfig();

      if (!versionInfo) {
        return JSON.stringify({
          success: false,
          error: '未找到Godot项目配置文件或无法解析版本信息',
          suggestions: [
            '确保在Godot项目根目录中运行此工具',
            '检查project.godot文件是否存在且格式正确'
          ]
        });
      }

      const compatibilityHints = godotVersionDetector.getCompatibilityHints(versionInfo);

      return JSON.stringify({
        success: true,
        data: {
          version: versionInfo,
          project: projectConfig,
          compatibilityHints,
          recommendations: {
            isGodot4: versionInfo.major === 4,
            isGodot3: versionInfo.major === 3,
            needsMigration: versionInfo.major === 3
          }
        }
      });
    } catch (error) {
      return JSON.stringify({
        success: false,
        error: `版本检测失败: ${error instanceof Error ? error.message : String(error)}`
      });
    }
  }
};

/**
 * API兼容性检查工具
 */
const checkGodotAPICompatibilityTool: MCPTool = {
  name: 'check_godot_api_compatibility',
  description: '检查GDScript代码中的API兼容性问题',
  parameters: z.object({
    code: z.string().describe('要检查的GDScript代码'),
    targetVersion: z.enum(['3.x', '4.x', 'auto']).optional().default('auto').describe('目标版本，默认为auto（自动检测）'),
    projectPath: z.string().optional().describe('项目路径，用于自动检测版本')
  }),
  execute: async (args) => {
    try {
      let targetVersion: '3.x' | '4.x' = '4.x';

      if (args.targetVersion === 'auto' || args.projectPath) {
        if (args.projectPath) {
          godotVersionDetector.setProjectPath(args.projectPath);
        }

        const versionInfo = await godotVersionDetector.detectGodotVersion();
        if (versionInfo) {
          targetVersion = versionInfo.major === 4 ? '4.x' : '3.x';
        }
      } else if (args.targetVersion) {
        targetVersion = args.targetVersion;
      }

      const issues = await godotAPICompatibilityDB.checkCompatibility(args.code, targetVersion);

      const breakingIssues = issues.filter(issue => issue.severity === 'breaking');
      const deprecatedIssues = issues.filter(issue => issue.severity === 'deprecated');
      const changedIssues = issues.filter(issue => issue.severity === 'changed');

      return JSON.stringify({
        success: true,
        data: {
          targetVersion,
          issues: {
            total: issues.length,
            breaking: breakingIssues.length,
            deprecated: deprecatedIssues.length,
            changed: changedIssues.length,
            details: issues
          },
          summary: {
            needsFixes: breakingIssues.length > 0,
            hasWarnings: deprecatedIssues.length > 0,
            compatibility: issues.length === 0 ? 'fully_compatible' : 'needs_attention'
          }
        }
      });
    } catch (error) {
      return JSON.stringify({
        success: false,
        error: `兼容性检查失败: ${error instanceof Error ? error.message : String(error)}`
      });
    }
  }
};

/**
 * 自动修复工具
 */
const fixGodotAPICompatibilityTool: MCPTool = {
  name: 'fix_godot_api_compatibility',
  description: '自动修复GDScript代码中的API兼容性问题',
  parameters: z.object({
    code: z.string().describe('要修复的GDScript代码'),
    issueIds: z.array(z.string()).optional().describe('要修复的问题ID列表，为空则修复所有问题'),
    targetVersion: z.enum(['3.x', '4.x', 'auto']).optional().default('auto').describe('目标版本，默认为auto（自动检测）'),
    projectPath: z.string().optional().describe('项目路径，用于自动检测版本')
  }),
  execute: async (args) => {
    try {
      let targetVersion: '3.x' | '4.x' = '4.x';

      if (args.targetVersion === 'auto' || args.projectPath) {
        if (args.projectPath) {
          godotVersionDetector.setProjectPath(args.projectPath);
        }

        const versionInfo = await godotVersionDetector.detectGodotVersion();
        if (versionInfo) {
          targetVersion = versionInfo.major === 4 ? '4.x' : '3.x';
        }
      } else if (args.targetVersion) {
        targetVersion = args.targetVersion;
      }

      const allIssues = await godotAPICompatibilityDB.checkCompatibility(args.code, targetVersion);

      const issuesToFix = args.issueIds && args.issueIds.length > 0
        ? allIssues.filter(issue => args.issueIds!.includes(issue.category))
        : allIssues;

      if (issuesToFix.length === 0) {
        return JSON.stringify({
          success: true,
          data: {
            originalCode: args.code,
            fixedCode: args.code,
            fixes: [],
            summary: '无需修复，代码已兼容'
          }
        });
      }

      let fixedCode = args.code;
      const appliedFixes: Array<{
        category: string;
        description: string;
        success: boolean;
      }> = [];

      for (const issue of issuesToFix) {
        const fix = godotAPICompatibilityDB.generateFix(fixedCode, issue);
        if (fix && fix !== fixedCode) {
          fixedCode = fix;
          appliedFixes.push({
            category: issue.category,
            description: issue.description,
            success: true
          });
        } else {
          appliedFixes.push({
            category: issue.category,
            description: issue.description,
            success: false
          });
        }
      }

      return JSON.stringify({
        success: true,
        data: {
          originalCode: args.code,
          fixedCode,
          fixes: appliedFixes,
          summary: `应用了 ${appliedFixes.filter(f => f.success).length}/${appliedFixes.length} 个修复`,
          targetVersion,
          remainingIssues: allIssues.length - issuesToFix.length
        }
      });
    } catch (error) {
      return JSON.stringify({
        success: false,
        error: `修复失败: ${error instanceof Error ? error.message : String(error)}`
      });
    }
  }
};

/**
 * 迁移建议工具
 */
const getGodotMigrationAdviceTool: MCPTool = {
  name: 'get_godot_migration_advice',
  description: '获取Godot版本迁移建议和最佳实践',
  parameters: z.object({
    fromVersion: z.string().optional().describe('源版本（例如: 3.x）'),
    toVersion: z.string().optional().describe('目标版本（例如: 4.x）'),
    projectPath: z.string().optional().describe('项目路径，用于检测当前版本')
  }),
  execute: async (args) => {
    try {
      let fromVersion = args.fromVersion;
      let toVersion = args.toVersion;

      if (args.projectPath) {
        godotVersionDetector.setProjectPath(args.projectPath);
        const versionInfo = await godotVersionDetector.detectGodotVersion();
        if (versionInfo) {
          if (!fromVersion) {
            fromVersion = `${versionInfo.major}.x`;
          }
          if (!toVersion) {
            toVersion = versionInfo.major === 3 ? '4.x' : '3.x';
          }
        }
      }

      if (!fromVersion) fromVersion = '3.x';
      if (!toVersion) toVersion = '4.x';

      const migrationAdvice = godotAPICompatibilityDB.getMigrationAdvice(fromVersion, toVersion);
      const breakingChanges = godotAPICompatibilityDB.getBreakingChanges();
      const allChanges = godotAPICompatibilityDB.getAllChanges();

      return JSON.stringify({
        success: true,
        data: {
          migration: {
            from: fromVersion,
            to: toVersion,
            advice: migrationAdvice
          },
          breakingChanges: breakingChanges.map(change => ({
            category: change.category,
            oldMethod: change.godot3Method,
            newMethod: change.godot4Method,
            description: change.description,
            example: change.exampleCode
          })),
          statistics: {
            totalChanges: allChanges.length,
            breakingChanges: breakingChanges.length,
            categories: ['tween', 'gradient', 'input', 'node', 'signal', 'general']
          },
          recommendations: [
            '建议先备份项目再进行迁移',
            '逐个文件进行测试和修复',
            '使用Godot编辑器的项目升级工具作为辅助',
            '迁移后进行全面测试'
          ]
        }
      });
    } catch (error) {
      return JSON.stringify({
        success: false,
        error: `获取迁移建议失败: ${error instanceof Error ? error.message : String(error)}`
      });
    }
  }
};

// 导出所有兼容性工具
export const compatibilityTools: MCPTool[] = [
  detectGodotVersionTool,
  checkGodotAPICompatibilityTool,
  fixGodotAPICompatibilityTool,
  getGodotMigrationAdviceTool
];