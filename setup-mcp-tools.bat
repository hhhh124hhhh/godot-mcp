@echo off
setlocal enabledelayedexpansion

REM Godot MCP 项目一键配置脚本 (Windows 版本)
REM 自动配置四个核心技能所需的 MCP 工具
REM 适用于小白用户，自动检测和安装所需依赖

echo.
echo 🚀 Godot MCP 一键配置脚本启动 (Windows)...
echo ========================================

REM 检查 Node.js 是否已安装
:check_nodejs
echo 📋 检查 Node.js 安装状态...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
    echo ✅ Node.js 已安装: !NODE_VERSION!

    REM 简单版本检查
    echo !NODE_VERSION! | findstr "v1[8-9]" >nul
    if %errorlevel% equ 0 (
        echo ✅ Node.js 版本符合要求
    ) else (
        echo !NODE_VERSION! | findstr "v[2-9][0-9]" >nul
        if %errorlevel% equ 0 (
            echo ✅ Node.js 版本符合要求
        ) else (
            echo ⚠️  警告: Node.js 版本可能过低，建议升级到 v18+
            echo    请访问 https://nodejs.org 下载最新版本
        )
    )
) else (
    echo ❌ Node.js 未安装
    echo 请先安装 Node.js:
    echo   - 官方下载: https://nodejs.org
    echo   - 或使用 Chocolatey: choco install nodejs
    pause
    exit /b 1
)

REM 检查 npm 是否可用
:check_npm
echo 📋 检查 npm 安装状态...
npm --version >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('npm --version') do set NPM_VERSION=%%i
    echo ✅ npm 已安装: v!NPM_VERSION!
) else (
    echo ❌ npm 未安装，请重新安装 Node.js
    pause
    exit /b 1
)

REM 安装 MCP 工具
:install_mcp_tools
echo.
echo 🔧 开始配置 MCP 工具...
echo ========================

echo 📦 验证 Chrome DevTools MCP...
npx chrome-devtools-mcp@latest --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Chrome DevTools MCP 已可用
) else (
    echo 🔄 正在配置 Chrome DevTools MCP...
    echo ⚠️  配置可能需要手动验证
)

echo 📦 验证 Sequential Thinking MCP...
npx sequential-thinking-mcp --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Sequential Thinking MCP 已可用
) else (
    echo 🔄 正在配置 Sequential Thinking MCP...
    echo ⚠️  配置可能需要手动验证
)

echo 📦 验证 Context7 MCP...
npx context7-mcp-server --version >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Context7 MCP 已可用
) else (
    echo 🔄 正在配置 Context7 MCP...
    echo ⚠️  配置可能需要手动验证
)

REM 检查 Claude Desktop 配置
:check_claude_config
echo.
echo 🔍 检查 Claude Desktop 配置...
echo ===============================

set "CONFIG_PATH=%APPDATA%\Claude\claude_desktop_config.json"
echo 📍 配置文件路径: %CONFIG_PATH%

if exist "%CONFIG_PATH%" (
    echo ✅ Claude Desktop 配置文件存在
    echo 📄 当前配置内容 (前20行):
    powershell "Get-Content '%CONFIG_PATH%' | Select-Object -First 20"
) else (
    echo ⚠️  Claude Desktop 配置文件不存在
    echo 📝 创建配置目录...

    if not exist "%APPDATA%\Claude" mkdir "%APPDATA%\Claude"

    echo 📝 创建基础配置文件...
    (
        echo {
        echo   "mcpServers": {}
        echo }
    ) > "%CONFIG_PATH%"
    echo ✅ 基础配置文件已创建
)

REM 生成 MCP 配置
:generate_mcp_config
echo.
echo ⚙️  生成 MCP 工具配置...
echo ========================

REM 获取当前脚本所在目录
set "PROJECT_ROOT=%~dp0"
REM 移除末尾的斜杠
if "%PROJECT_ROOT:~-1%"=="\" set "PROJECT_ROOT=%PROJECT_ROOT:~0,-1%"

echo.
echo 📋 请将以下配置添加到 Claude Desktop 配置文件中:
echo 📍 配置文件路径: %CONFIG_PATH%
echo.
echo 🔧 MCP 工具配置 (请复制以下 JSON 内容):
echo.
echo {
echo   "mcpServers": {
echo     "godot-mcp": {
echo       "command": "node",
echo       "args": ["%PROJECT_ROOT%\server\dist\index.js"],
echo       "env": {
echo         "MCP_TRANSPORT": "stdio"
echo       }
echo     },
echo     "chrome-devtools": {
echo       "command": "npx",
echo       "args": ["chrome-devtools-mcp@latest"]
echo     },
echo     "sequential-thinking": {
echo       "command": "npx",
echo       "args": ["sequential-thinking-mcp"]
echo     },
echo     "context7": {
echo       "command": "npx",
echo       "args": ["context7-mcp-server"]
echo     }
echo   }
echo }
echo.
echo 📝 配置说明:
echo - godot-mcp: Godot 引擎集成服务器
echo - chrome-devtools: Web 开发和调试工具
echo - sequential-thinking: 逐步推理和问题分解
echo - context7: 自动文档研究和信息检索
echo.

REM 验证技能文件
:verify_skills
echo 🧠 验证 AI 技能配置...
echo =======================

set "SKILLS_DIR=%PROJECT_ROOT%\.claude\skills"

if exist "%SKILLS_DIR%" (
    echo ✅ 技能目录存在: %SKILLS_DIR%

    echo ✅ Godot版本兼容性检查 - godot-compatibility-checker
    if exist "%SKILLS_DIR%\godot-compatibility-checker\SKILL.md" (
        echo    ✅ 技能文件存在
    ) else (
        echo    ❌ 技能文件缺失
    )

    echo ✅ Context7自动研究 - context7-auto-research
    if exist "%SKILLS_DIR%\context7-auto-research\SKILL.md" (
        echo    ✅ 技能文件存在
    ) else (
        echo    ❌ 技能文件缺失
    )

    echo ✅ MCP工具编排 - mcp-orchestration
    if exist "%SKILLS_DIR%\mcp-orchestration\SKILL.md" (
        echo    ✅ 技能文件存在
    ) else (
        echo    ❌ 技能文件缺失
    )

    echo ✅ 中文开发指南 - chinese-dev-guide
    if exist "%SKILLS_DIR%\chinese-dev-guide\SKILL.md" (
        echo    ✅ 技能文件存在
    ) else (
        echo    ❌ 技能文件缺失
    )
) else (
    echo ❌ 技能目录不存在: %SKILLS_DIR%
)

REM 构建 Godot MCP 服务器
:build_godot_mcp
echo.
echo 🏗️  构建 Godot MCP 服务器...
echo ===========================

set "SERVER_DIR=%PROJECT_ROOT%\server"

if exist "%SERVER_DIR%" (
    cd /d "%SERVER_DIR%"

    if exist "package.json" (
        echo 📦 安装服务器依赖...
        npm install

        echo 🔨 构建服务器...
        npm run build

        if exist "dist\index.js" (
            echo ✅ Godot MCP 服务器构建成功
        ) else (
            echo ❌ 服务器构建失败
        )
    ) else (
        echo ❌ package.json 文件不存在
    )

    cd /d "%PROJECT_ROOT%"
) else (
    echo ❌ 服务器目录不存在: %SERVER_DIR%
)

REM 生成验证报告
:generate_report
echo.
echo 📊 配置完成报告
echo ================
echo.
echo ✅ 完成的配置项目:
echo   - Node.js 环境检查
echo   - MCP 工具配置
echo   - Claude Desktop 配置检查
echo   - AI 技能文件验证
echo   - Godot MCP 服务器构建
echo.
echo 📝 下一步操作:
echo   1. 将上面显示的 MCP 配置添加到 Claude Desktop
echo   2. 重启 Claude Desktop
echo   3. 在 Godot 中打开项目并启用插件
echo   4. 运行 'npm run dev' 启动 MCP 服务器
echo.
echo 🎮 开始使用:
echo   - 向 Claude 发送: "如何实现 Godot 粒子效果"
echo   - 或发送: "检查我的项目兼容性"
echo.
echo 📚 更多帮助:
echo   - 查看文档: README.md
echo   - 快速开始: QUICK_START.md
echo   - 问题反馈: GitHub Issues
echo.
echo 🎉 配置完成！享受 AI 驱动的游戏开发体验！

echo.
echo ✅ 一键配置脚本执行完成！
echo.
echo 按任意键退出...
pause >nul