/**
 * Godot代码验证器
 * 提供实时的GDScript代码兼容性检查和验证
 */

import { godotAPICompatibilityDB, APIChange } from '../data/godot_api_compatibility';
import { godotVersionDetector, GodotVersionInfo } from './godot_version_detector';

export interface ValidationResult {
  isValid: boolean;
  errors: ValidationError[];
  warnings: ValidationWarning[];
  suggestions: ValidationSuggestion[];
  summary: ValidationSummary;
}

export interface ValidationError {
  type: 'api_compatibility' | 'syntax' | 'logical' | 'performance';
  severity: 'error' | 'warning' | 'info';
  message: string;
  line?: number;
  column?: number;
  code?: string;
  suggestion?: string;
  autoFixAvailable: boolean;
}

export interface ValidationWarning {
  type: string;
  message: string;
  line?: number;
  recommendation: string;
}

export interface ValidationSuggestion {
  type: 'best_practice' | 'performance' | 'modernization';
  message: string;
  benefit: string;
  implementation?: string;
}

export interface ValidationSummary {
  totalIssues: number;
  errors: number;
  warnings: number;
  suggestions: number;
  compatibility: 'fully_compatible' | 'needs_attention' | 'breaking_changes';
  estimatedEffort: 'low' | 'medium' | 'high';
}

export class GodotCodeValidator {
  private versionInfo: GodotVersionInfo | null = null;
  private projectPath: string = '';

  constructor(projectPath: string = '') {
    this.projectPath = projectPath;
    this.initializeVersionDetection();
  }

  private async initializeVersionDetection(): Promise<void> {
    if (this.projectPath) {
      godotVersionDetector.setProjectPath(this.projectPath);
      this.versionInfo = await godotVersionDetector.detectGodotVersion();
    }
  }

  /**
   * 验证GDScript代码
   */
  async validateCode(code: string, filePath?: string): Promise<ValidationResult> {
    const errors: ValidationError[] = [];
    const warnings: ValidationWarning[] = [];
    const suggestions: ValidationSuggestion[] = [];

    // 1. API兼容性检查
    const compatibilityErrors = await this.checkAPICompatibility(code);
    errors.push(...compatibilityErrors);

    // 2. 语法和最佳实践检查
    const syntaxErrors = this.checkSyntaxAndBestPractices(code);
    errors.push(...syntaxErrors.errors);
    warnings.push(...syntaxErrors.warnings);
    suggestions.push(...syntaxErrors.suggestions);

    // 3. 性能检查
    const performanceIssues = this.checkPerformance(code);
    warnings.push(...performanceIssues);

    // 4. 现代化建议
    const modernizationSuggestions = this.suggestModernization(code);
    suggestions.push(...modernizationSuggestions);

    // 5. 安全性检查
    const securityWarnings = this.checkSecurity(code);
    warnings.push(...securityWarnings);

    const summary = this.generateSummary(errors, warnings, suggestions);

    return {
      isValid: errors.length === 0,
      errors,
      warnings,
      suggestions,
      summary
    };
  }

  /**
   * 检查API兼容性
   */
  private async checkAPICompatibility(code: string): Promise<ValidationError[]> {
    const errors: ValidationError[] = [];

    try {
      const targetVersion = this.versionInfo?.major === 4 ? '4.x' : '3.x';
      const issues = await godotAPICompatibilityDB.checkCompatibility(code, targetVersion);

      for (const issue of issues) {
        // 找到问题在代码中的位置
        const lines = code.split('\n');
        let line = -1;
        let column = -1;

        for (let i = 0; i < lines.length; i++) {
          const lineContent = lines[i];
          if (issue.godot3Method && lineContent.includes(issue.godot3Method)) {
            line = i + 1;
            column = lineContent.indexOf(issue.godot3Method) + 1;
            break;
          } else if (issue.godot4Method && targetVersion === '3.x' && lineContent.includes(issue.godot4Method)) {
            line = i + 1;
            column = lineContent.indexOf(issue.godot4Method) + 1;
            break;
          }
        }

        errors.push({
          type: 'api_compatibility',
          severity: issue.severity === 'breaking' ? 'error' : 'warning',
          message: `API兼容性问题: ${issue.description}`,
          line,
          column,
          code: issue.godot3Method || issue.godot4Method,
          suggestion: issue.migrationNotes,
          autoFixAvailable: true
        });
      }
    } catch (error) {
      console.error('API兼容性检查失败:', error);
    }

    return errors;
  }

  /**
   * 检查语法和最佳实践
   */
  private checkSyntaxAndBestPractices(code: string): {
    errors: ValidationError[];
    warnings: ValidationWarning[];
    suggestions: ValidationSuggestion[];
  } {
    const errors: ValidationError[] = [];
    const warnings: ValidationWarning[] = [];
    const suggestions: ValidationSuggestion[] = [];

    const lines = code.split('\n');

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const lineNumber = i + 1;

      // 检查缩进一致性
      if (line.match(/^\s*[^\s]/)) {
        const hasTabs = line.startsWith('\t');
        const hasSpaces = line.match(/^ +/);

        if (hasTabs && hasSpaces) {
          errors.push({
            type: 'syntax',
            severity: 'error',
            message: '缩进不一致：混用了制表符和空格',
            line: lineNumber,
            suggestion: '统一使用制表符（Tab）进行缩进',
            autoFixAvailable: true
          });
        }
      }

      // 检查节点访问安全
      if (line.includes('get_node(') && !line.includes('get_node_or_null(')) {
        if (!line.includes('if') && !line.includes('has_node')) {
          warnings.push({
            type: 'safety',
            message: '未检查节点是否存在就直接访问',
            line: lineNumber,
            recommendation: '使用get_node_or_null()或先用has_node()检查'
          });
        }
      }

      // 检查信号连接方式
      if (line.includes('.connect(') && this.versionInfo?.major === 4) {
        if (line.includes('"') && line.includes(',')) {
          suggestions.push({
            type: 'modernization',
            message: '可以简化信号连接语法',
            benefit: '代码更简洁，类型安全',
            implementation: '使用新的信号连接语法：button.pressed.connect(_on_button_pressed)'
          });
        }
      }
    }

    return { errors, warnings, suggestions };
  }

  /**
   * 性能检查
   */
  private checkPerformance(code: string): ValidationWarning[] {
    const warnings: ValidationWarning[] = [];
    const lines = code.split('\n');

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const lineNumber = i + 1;

      // 检查在_process中的重操作
      if (line.includes('func _process(')) {
        // 检查_process函数体中的重操作
        let processStart = i;
        let braceCount = 0;
        let inFunction = true;

        for (let j = i + 1; j < lines.length && inFunction; j++) {
          const processLine = lines[j];
          if (processLine.includes('func ')) break;

          if (processLine.match(/\.find\s*\(|\.get_children\s*\(|create_.*\(\)/)) {
            warnings.push({
              type: 'performance',
              message: '在_process中执行重操作可能影响性能',
              line: j + 1,
              recommendation: '将重操作移到_ready或缓存结果'
            });
          }
        }
      }

      // 检查不必要的重复计算
      if (line.match(/get_node\([^)]+\)\.\w+\(/) && line.includes('for ')) {
        warnings.push({
          type: 'performance',
          message: '循环中重复获取节点引用',
          line: lineNumber,
          recommendation: '在循环外缓存节点引用'
        });
      }
    }

    return warnings;
  }

  /**
   * 现代化建议
   */
  private suggestModernization(code: string): ValidationSuggestion[] {
    const suggestions: ValidationSuggestion[] = [];

    if (this.versionInfo?.major === 4) {
      // Godot 4.x特定建议
      if (code.includes('yield(')) {
        suggestions.push({
          type: 'modernization',
          message: '建议使用新的await语法替代yield',
          benefit: '代码更直观，与现代异步编程一致',
          implementation: '将yield(get_tree().create_timer(1.0), "timeout")改为await get_tree().create_timer(1.0).timeout'
        });
      }

      if (code.includes('preload(')) {
        suggestions.push({
          type: 'modernization',
          message: '考虑使用@export var进行资源导出',
          benefit: '更好的编辑器支持，运行时性能更佳',
          implementation: '使用@export var resource: Resource = preload("path")'
        });
      }
    }

    return suggestions;
  }

  /**
   * 安全性检查
   */
  private checkSecurity(code: string): ValidationWarning[] {
    const warnings: ValidationWarning[] = [];
    const lines = code.split('\n');

    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      const lineNumber = i + 1;

      // 检查直接在信号处理中删除节点
      if (line.includes('queue_free()') || line.includes('.queue_free()')) {
        // 检查是否在信号处理函数中
        const context = this.getFunctionContext(code, i);
        if (context?.isSignalHandler) {
          warnings.push({
            type: 'safety',
            message: '在信号处理中直接删除节点可能导致崩溃',
            line: lineNumber,
            recommendation: '使用call_deferred("queue_free")延迟删除'
          });
        }
      }

      // 检查可能的内存泄漏
      if (line.includes('connect(') && !line.includes('CONNECT_ONE_SHOT')) {
        warnings.push({
          type: 'best_practice',
          message: '考虑为一次性信号使用CONNECT_ONE_SHOT标志',
          line: lineNumber,
          recommendation: '在connect()调用中添加CONNECT_ONE_SHOT标志，自动断开连接避免内存泄漏'
        });
      }
    }

    return warnings;
  }

  /**
   * 获取函数上下文
   */
  private getFunctionContext(code: string, lineIndex: number): { isSignalHandler?: boolean } | null {
    const lines = code.split('\n');
    let currentLine = lineIndex;

    // 向上查找函数定义
    while (currentLine >= 0) {
      const line = lines[currentLine];
      if (line.includes('func ')) {
        const isSignalHandler = line.match(/^func _on_\w+/) !== null;
        return { isSignalHandler };
      }
      currentLine--;
    }

    return null;
  }

  /**
   * 生成验证摘要
   */
  private generateSummary(
    errors: ValidationError[],
    warnings: ValidationWarning[],
    suggestions: ValidationSuggestion[]
  ): ValidationSummary {
    const totalIssues = errors.length + warnings.length + suggestions.length;
    const errorCount = errors.filter(e => e.severity === 'error').length;
    const warningCount = warnings.length + errors.filter(e => e.severity === 'warning').length;

    let compatibility: ValidationSummary['compatibility'] = 'fully_compatible';
    if (errorCount > 0) {
      compatibility = 'breaking_changes';
    } else if (warningCount > 0) {
      compatibility = 'needs_attention';
    }

    let estimatedEffort: ValidationSummary['estimatedEffort'] = 'low';
    if (errorCount > 5) {
      estimatedEffort = 'high';
    } else if (errorCount > 0 || warningCount > 3) {
      estimatedEffort = 'medium';
    }

    return {
      totalIssues,
      errors: errorCount,
      warnings: warningCount,
      suggestions: suggestions.length,
      compatibility,
      estimatedEffort
    };
  }

  /**
   * 自动修复代码
   */
  async autoFixCode(code: string, issues: ValidationError[]): Promise<string> {
    let fixedCode = code;

    // 按行号排序，从后往前修复避免偏移问题
    const sortedIssues = issues
      .filter(issue => issue.autoFixAvailable && issue.line)
      .sort((a, b) => (b.line || 0) - (a.line || 0));

    for (const issue of sortedIssues) {
      try {
        if (issue.type === 'api_compatibility') {
          const apiChange = await this.findAPIChangeForError(issue);
          if (apiChange) {
            const fix = godotAPICompatibilityDB.generateFix(fixedCode, apiChange);
            if (fix) {
              fixedCode = fix;
            }
          }
        }
      } catch (error) {
        console.error(`修复问题失败: ${issue.message}`, error);
      }
    }

    return fixedCode;
  }

  private async findAPIChangeForError(error: ValidationError): Promise<APIChange | null> {
    if (!error.code) return null;

    // 查找匹配的API变化
    const change = godotAPICompatibilityDB.findAPIChange(error.code);
    return change;
  }

  /**
   * 设置项目路径
   */
  setProjectPath(projectPath: string): void {
    this.projectPath = projectPath;
    godotVersionDetector.setProjectPath(projectPath);
    this.initializeVersionDetection();
  }

  /**
   * 更新版本信息
   */
  async updateVersionInfo(): Promise<void> {
    await this.initializeVersionDetection();
  }
}

// 导出单例实例
export const godotCodeValidator = new GodotCodeValidator();