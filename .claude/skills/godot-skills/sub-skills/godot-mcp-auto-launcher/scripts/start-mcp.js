#!/usr/bin/env node
/**
 * MCP Node.js 客户端启动脚本
 * 检测Godot WebSocket服务器并启动MCP客户端进行连接
 */

const { exec, execSync, spawn } = require('child_process');
const fs = require('fs');
const path = require('path');
const http = require('http');

// 配置
const GODOT_PORT = 9080;
const SERVER_DIR = '/mnt/d/godot-mcp/server';
const PID_FILE = '/tmp/mcp_nodejs_client.pid';
const LOG_FILE = '/tmp/mcp_launcher.log';

// 日志功能
function log(message) {
  const timestamp = new Date().toISOString();
  const logMessage = `[${timestamp}] ${message}`;
  console.log(logMessage);

  try {
    fs.appendFileSync(LOG_FILE, logMessage + '\n');
  } catch (e) {
    // 忽略日志写入错误
  }
}

// 检查端口是否被占用
function checkPortInUse(port) {
  return new Promise((resolve) => {
    const cmd = process.platform === 'darwin' || process.platform === 'linux'
      ? `lsof -i :${port}`
      : `netstat -ano | findstr :${port}`;

    exec(cmd, (error, stdout) => {
      if (error) {
        resolve(false);
        return;
      }
      resolve(stdout.trim().length > 0);
    });
  });
}

// 测试WebSocket连接（使用原生http模块）
function testWebSocketConnection(port) {
  return new Promise((resolve) => {
    const timeout = setTimeout(() => {
      resolve(false);
    }, 3000);

    // 尝试发起WebSocket握手请求
    const req = http.request({
      hostname: 'localhost',
      port: port,
      method: 'GET',
      headers: {
        'Connection': 'Upgrade',
        'Upgrade': 'websocket',
        'Sec-WebSocket-Key': 'dGhlIHNhbXBsZSBub25jZQ==', // 示例key
        'Sec-WebSocket-Version': '13'
      }
    }, (res) => {
      clearTimeout(timeout);
      // 如果服务器返回101 Switching Protocols，说明WebSocket可用
      resolve(res.statusCode === 101 || res.statusCode === 400);
    });

    req.on('error', () => {
      clearTimeout(timeout);
      resolve(false);
    });

    req.end();
  });
}

// 检查Godot WebSocket服务器是否在运行
async function checkGodotWebSocket() {
  const portInUse = await checkPortInUse(GODOT_PORT);
  if (!portInUse) {
    return false;
  }

  // 测试WebSocket连接
  return await testWebSocketConnection(GODOT_PORT);
}

// 查找MCP Node.js进程
function findMCPProcess() {
  try {
    const cmd = process.platform === 'darwin' || process.platform === 'linux'
      ? 'ps aux'
      : 'tasklist /v';

    const output = execSync(cmd, { encoding: 'utf8' });
    const lines = output.split('\n');

    for (const line of lines) {
      if (line.includes('godot-mcp-server') || line.includes('node dist/index.js')) {
        const match = line.match(/\b(\d+)\b/);
        if (match) {
          return match[1];
        }
      }
    }
  } catch (e) {
    log(`查找进程时出错: ${e.message}`);
  }

  return null;
}

// 检查MCP是否在运行
function isMCPRunning() {
  return findMCPProcess() !== null;
}

// 启动MCP客户端
async function startMCPClient() {
  log(`🚀 正在启动MCP Node.js客户端（连接到Godot WebSocket端口 ${GODOT_PORT}）...`);

  // 检查目录
  if (!fs.existsSync(SERVER_DIR)) {
    log(`❌ 错误：服务器目录不存在: ${SERVER_DIR}`);
    return false;
  }

  // 检查是否需要构建
  const distDir = path.join(SERVER_DIR, 'dist');
  if (!fs.existsSync(distDir)) {
    log('📦 正在构建项目...');
    try {
      execSync('npm run build', { cwd: SERVER_DIR, stdio: 'inherit' });
    } catch (e) {
      log(`❌ 构建失败: ${e.message}`);
      return false;
    }
  }

  // 启动MCP客户端
  log('▶️  正在启动MCP Node.js客户端...');

  try {
    const child = spawn('npm', ['run', 'start'], {
      cwd: SERVER_DIR,
      detached: true,
      stdio: 'inherit'
    });

    // 保存PID
    fs.writeFileSync(PID_FILE, child.pid.toString());
    log(`✅ MCP Node.js客户端已启动 (PID: ${child.pid})`);

    // 断开连接，让进程独立运行
    child.unref();

    return true;
  } catch (e) {
    log(`❌ 启动失败: ${e.message}`);
    return false;
  }
}

// 停止MCP客户端
function stopMCPClient() {
  const pid = findMCPProcess();

  if (pid) {
    try {
      process.kill(parseInt(pid), 'SIGTERM');
      log(`⏹️  已停止MCP Node.js客户端 (PID: ${pid})`);

      // 清理PID文件
      if (fs.existsSync(PID_FILE)) {
        fs.unlinkSync(PID_FILE);
      }

      return true;
    } catch (e) {
      log(`❌ 停止失败: ${e.message}`);
      return false;
    }
  } else {
    log('ℹ️  MCP Node.js客户端未运行');

    // 清理残留PID文件
    if (fs.existsSync(PID_FILE)) {
      fs.unlinkSync(PID_FILE);
    }

    return true;
  }
}

// 重启MCP客户端
async function restartMCPClient() {
  log('🔄 正在重启MCP Node.js客户端...');
  stopMCPClient();
  await new Promise(resolve => setTimeout(resolve, 2000));
  return await startMCPClient();
}

// 显示状态
async function status() {
  // 检查Godot WebSocket服务器
  const godotRunning = await checkGodotWebSocket();
  if (godotRunning) {
    log(`✅ Godot WebSocket服务器正在端口 ${GODOT_PORT} 运行`);
  } else {
    log(`❌ Godot WebSocket服务器未在端口 ${GODOT_PORT} 运行`);
    log('   请确保：');
    log('   1. Godot编辑器已打开');
    log('   2. Godot MCP插件已启用');
    log('   3. Godot MCP插件配置正确');
  }

  // 检查MCP Node.js客户端
  const mcpRunning = isMCPRunning();
  if (mcpRunning) {
    const pid = findMCPProcess();
    log(`✅ MCP Node.js客户端正在运行 (PID: ${pid})`);
  } else {
    log('❌ MCP Node.js客户端未运行');
  }

  return godotRunning && mcpRunning;
}

// 等待Godot就绪
async function waitForGodot(timeout = 30) {
  log(`⏳ 等待Godot WebSocket服务器在端口 ${GODOT_PORT} 就绪（最多${timeout}秒）...`);

  const startTime = Date.now();
  while (Date.now() - startTime < timeout * 1000) {
    if (await checkGodotWebSocket()) {
      log('✅ Godot WebSocket服务器已就绪');
      return true;
    }
    await new Promise(resolve => setTimeout(resolve, 1000));
  }

  log(`❌ 等待超时（${timeout}秒），Godot WebSocket服务器未就绪`);
  return false;
}

// 主函数
async function main() {
  const args = process.argv.slice(2);

  // 解析参数
  if (args.length === 0 || args[0] === 'start') {
    // 检查MCP是否已在运行
    if (isMCPRunning()) {
      const pid = findMCPProcess();
      log(`ℹ️  MCP Node.js客户端已在运行 (PID: ${pid})`);
      process.exit(0);
      return;
    }

    // 启动MCP客户端（不检测Godot，直接启动）
    // MCP客户端会自动尝试连接Godot
    log('🚀 正在启动MCP Node.js客户端...');
    log(`   将尝试连接到Godot WebSocket端口 ${GODOT_PORT}`);
    log('   请确保Godot编辑器已打开且MCP插件已启用');
    log('');

    const success = await startMCPClient();
    process.exit(success ? 0 : 1);

  } else if (args[0] === 'stop') {
    const success = stopMCPClient();
    process.exit(success ? 0 : 1);

  } else if (args[0] === 'restart') {
    const success = await restartMCPClient();
    process.exit(success ? 0 : 1);

  } else if (args[0] === 'status') {
    const success = await status();
    process.exit(success ? 0 : 1);

  } else if (args[0] === '--help' || args[0] === '-h') {
    console.log(`
MCP Node.js客户端启动工具

用法:
  node start-mcp.js [start|stop|restart|status] [选项]

命令:
  start    启动MCP Node.js客户端（默认）
  stop     停止MCP Node.js客户端
  restart  重启MCP Node.js客户端
  status   显示MCP和Godot状态

选项:
  --help         显示帮助信息

示例:
  # 启动MCP客户端
  node start-mcp.js start

  # 检查状态
  node start-mcp.js status

  # 停止MCP客户端
  node start-mcp.js stop

注意：启动前请确保Godot编辑器已打开且MCP插件已启用

日志文件: ${LOG_FILE}
    `);
    process.exit(0);

  } else {
    console.error(`未知命令: ${args[0]}`);
    console.error('使用 --help 查看帮助信息');
    process.exit(1);
  }
}

// 运行主函数
main().catch(err => {
  log(`❌ 错误: ${err.message}`);
  console.error(err);
  process.exit(1);
});
