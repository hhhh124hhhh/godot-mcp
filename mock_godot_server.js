#!/usr/bin/env node

const WebSocket = require('./server/node_modules/ws');

console.log('Starting mock Godot WebSocket server...');

const wss = new WebSocket.Server({ port: 9080 });

console.log('Mock Godot WebSocket server listening on ws://localhost:9080');

wss.on('connection', function connection(ws) {
  console.log('Client connected to mock Godot server');

  // 发送初始连接确认消息
  ws.send(JSON.stringify({
    type: 'connection_status',
    status: 'connected',
    message: 'Mock Godot server ready'
  }));

  ws.on('message', function incoming(message) {
    console.log('Received command:', message.toString());

    try {
      const command = JSON.parse(message);

      // 模拟Godot命令响应
      let response = {
        status: 'success',
        result: {},
        commandId: command.commandId || 'unknown'
      };

      // 根据命令类型返回不同的模拟响应
      switch (command.type) {
        case 'get_project_info':
          response.result = {
            name: 'Mock Godot Project',
            version: '4.2',
            path: '/mnt/d/godot-mcp',
            scenes: ['res://BubbleGame.tscn'],
            scripts: ['res://Bubble.gd']
          };
          break;

        case 'check_godot_version':
          response.result = {
            version: '4.2.1',
            version_string: '4.2.1.stable',
            features: ['Vulkan', 'GDScript', 'C#']
          };
          break;

        case 'ping':
          response.result = { pong: true };
          break;

        default:
          response.result = { message: `Mock response for ${command.type}` };
      }

      ws.send(JSON.stringify(response));
    } catch (error) {
      console.error('Error processing command:', error);
      ws.send(JSON.stringify({
        status: 'error',
        error: error.message,
        commandId: command.commandId || 'unknown'
      }));
    }
  });

  ws.on('close', function close() {
    console.log('Client disconnected from mock Godot server');
  });

  ws.on('error', function error(err) {
    console.error('WebSocket error:', err);
  });
});

console.log('Mock Godot server is running. Press Ctrl+C to stop.');

process.on('SIGINT', () => {
  console.log('\nShutting down mock Godot server...');
  wss.close(() => {
    console.log('Server closed');
    process.exit(0);
  });
});