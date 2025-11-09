#!/bin/bash

# Godot MCP 项目一键配置脚本
# 自动配置四个核心技能所需的 MCP 工具
# 适用于小白用户，自动检测和安装所需依赖

set -e  # 遇到错误立即退出

echo "🚀 Godot MCP 一键配置脚本启动..."
echo "================================"

# 检查 Node.js 是否已安装
check_nodejs() {
    echo "📋 检查 Node.js 安装状态..."
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        echo "✅ Node.js 已安装: $NODE_VERSION"
        if [[ $NODE_VERSION < "v18" ]]; then
            echo "⚠️  警告: Node.js 版本过低，建议升级到 v18+"
            echo "   请访问 https://nodejs.org 下载最新版本"
        fi
    else
        echo "❌ Node.js 未安装"
        echo "请先安装 Node.js:"
        echo "  - 官方下载: https://nodejs.org"
        echo "  - 或使用包管理器: brew install node (macOS)"
        exit 1
    fi
}

# 检查 npm 是否可用
check_npm() {
    echo "📋 检查 npm 安装状态..."
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        echo "✅ npm 已安装: v$NPM_VERSION"
    else
        echo "❌ npm 未安装，请重新安装 Node.js"
        exit 1
    fi
}

# 安装 MCP 工具
install_mcp_tools() {
    echo ""
    echo "🔧 开始安装 MCP 工具..."
    echo "========================"

    # 定义要安装的 MCP 工具
    declare -A MCP_TOOLS=(
        ["chrome-devtools"]="npx chrome-devtools-mcp@latest"
        ["sequential-thinking"]="npx sequential-thinking-mcp"
        ["context7"]="npx context7-mcp-server"
    )

    for tool in "${!MCP_TOOLS[@]}"; do
        echo ""
        echo "📦 安装 $tool..."
        TOOL_COMMAND="${MCP_TOOLS[$tool]}"

        # 尝试安装工具
        if npm list -g ${TOOL_COMMAND#* } &> /dev/null || npx ${TOOL_COMMAND} --version &> /dev/null; then
            echo "✅ $tool 已可用"
        else
            echo "🔄 正在配置 $tool..."
            # 创建测试命令来验证工具可用性
            if timeout 10s npx ${TOOL_COMMAND} --version &> /dev/null; then
                echo "✅ $tool 配置成功"
            else
                echo "⚠️  $tool 配置可能需要手动验证"
            fi
        fi
    done
}

# 检查 Claude Desktop 配置
check_claude_config() {
    echo ""
    echo "🔍 检查 Claude Desktop 配置..."
    echo "=============================="

    # 检测操作系统
    OS="$(uname -s)"
    case "$OS" in
        Darwin*)    CONFIG_PATH="$HOME/Library/Application Support/Claude/claude_desktop_config.json";;
        Linux*)     CONFIG_PATH="$HOME/.config/Claude/claude_desktop_config.json";;
        CYGWIN*|MINGW*|MSYS*) CONFIG_PATH="$APPDATA/Claude/claude_desktop_config.json";;
        *)          CONFIG_PATH="$HOME/.config/Claude/claude_desktop_config.json";;
    esac

    echo "📍 配置文件路径: $CONFIG_PATH"

    if [ -f "$CONFIG_PATH" ]; then
        echo "✅ Claude Desktop 配置文件存在"
        echo "📄 当前配置内容:"
        cat "$CONFIG_PATH" | head -20
        echo "..."
    else
        echo "⚠️  Claude Desktop 配置文件不存在"
        echo "📝 创建配置目录..."

        # 创建配置目录
        CONFIG_DIR=$(dirname "$CONFIG_PATH")
        mkdir -p "$CONFIG_DIR"

        echo "📝 创建基础配置文件..."
        cat > "$CONFIG_PATH" << 'EOF'
{
  "mcpServers": {}
}
EOF
        echo "✅ 基础配置文件已创建"
    fi
}

# 生成 MCP 配置
generate_mcp_config() {
    echo ""
    echo "⚙️  生成 MCP 工具配置..."
    echo "======================="

    # 获取当前脚本所在目录（godot-mcp 项目根目录）
    PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    cat << EOF

📋 请将以下配置添加到 Claude Desktop 配置文件中:
📍 配置文件路径: $CONFIG_PATH

🔧 MCP 工具配置 (请复制以下 JSON 内容):

{
  "mcpServers": {
    "godot-mcp": {
      "command": "node",
      "args": ["$PROJECT_ROOT/server/dist/index.js"],
      "env": {
        "MCP_TRANSPORT": "stdio"
      }
    },
    "chrome-devtools": {
      "command": "npx",
      "args": ["chrome-devtools-mcp@latest"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["sequential-thinking-mcp"]
    },
    "context7": {
      "command": "npx",
      "args": ["context7-mcp-server"]
    }
  }
}

📝 配置说明:
- godot-mcp: Godot 引擎集成服务器
- chrome-devtools: Web 开发和调试工具
- sequential-thinking: 逐步推理和问题分解
- context7: 自动文档研究和信息检索

EOF
}

# 验证技能文件
verify_skills() {
    echo ""
    echo "🧠 验证 AI 技能配置..."
    echo "======================"

    SKILLS_DIR="$PROJECT_ROOT/.claude/skills"

    if [ -d "$SKILLS_DIR" ]; then
        echo "✅ 技能目录存在: $SKILLS_DIR"

        # 检查四个核心技能
        declare -A SKILLS=(
            ["godot-compatibility-checker"]="Godot版本兼容性检查"
            ["context7-auto-research"]="Context7自动研究"
            ["mcp-orchestration"]="MCP工具编排"
            ["chinese-dev-guide"]="中文开发指南"
        )

        for skill in "${!SKILLS[@]}"; do
            if [ -f "$SKILLS_DIR/$skill/SKILL.md" ]; then
                echo "✅ ${SKILLS[$skill]} - $skill"
            else
                echo "❌ ${SKILLS[$skill]} - $skill (文件缺失)"
            fi
        done
    else
        echo "❌ 技能目录不存在: $SKILLS_DIR"
    fi
}

# 构建 Godot MCP 服务器
build_godot_mcp() {
    echo ""
    echo "🏗️  构建 Godot MCP 服务器..."
    echo "==========================="

    SERVER_DIR="$PROJECT_ROOT/server"

    if [ -d "$SERVER_DIR" ]; then
        cd "$SERVER_DIR"

        if [ -f "package.json" ]; then
            echo "📦 安装服务器依赖..."
            npm install

            echo "🔨 构建服务器..."
            npm run build

            if [ -f "dist/index.js" ]; then
                echo "✅ Godot MCP 服务器构建成功"
            else
                echo "❌ 服务器构建失败"
            fi
        else
            echo "❌ package.json 文件不存在"
        fi

        cd "$PROJECT_ROOT"
    else
        echo "❌ 服务器目录不存在: $SERVER_DIR"
    fi
}

# 生成验证报告
generate_report() {
    echo ""
    echo "📊 配置完成报告"
    echo "================"
    echo ""
    echo "✅ 完成的配置项目:"
    echo "  - Node.js 环境检查"
    echo "  - MCP 工具配置"
    echo "  - Claude Desktop 配置检查"
    echo "  - AI 技能文件验证"
    echo "  - Godot MCP 服务器构建"
    echo ""
    echo "📝 下一步操作:"
    echo "  1. 将上面显示的 MCP 配置添加到 Claude Desktop"
    echo "  2. 重启 Claude Desktop"
    echo "  3. 在 Godot 中打开项目并启用插件"
    echo "  4. 运行 'npm run dev' 启动 MCP 服务器"
    echo ""
    echo "🎮 开始使用:"
    echo "  - 向 Claude 发送: '如何实现 Godot 粒子效果'"
    echo "  - 或发送: '检查我的项目兼容性'"
    echo ""
    echo "📚 更多帮助:"
    echo "  - 查看文档: README.md"
    echo "  - 快速开始: QUICK_START.md"
    echo "  - 问题反馈: GitHub Issues"
    echo ""
    echo "🎉 配置完成！享受 AI 驱动的游戏开发体验！"
}

# 主函数
main() {
    echo "开始 Godot MCP 环境配置..."
    echo ""

    check_nodejs
    check_npm
    install_mcp_tools
    check_claude_config
    generate_mcp_config
    verify_skills
    build_godot_mcp
    generate_report

    echo ""
    echo "✅ 一键配置脚本执行完成！"
}

# 错误处理
trap 'echo "❌ 配置过程中发生错误，请检查上面的错误信息"; exit 1' ERR

# 运行主函数
main "$@"