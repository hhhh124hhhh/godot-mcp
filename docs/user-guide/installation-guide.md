# Godot MCP Installation Guide

This guide walks you through installing and setting up the Godot MCP integration to use Claude with your Godot projects.

## Prerequisites

- Godot 4.x installed
- Node.js 18+ and npm installed
- Claude desktop application with MCP enabled

## Installation Steps

### 1. Install the Godot Addon

1. Copy the `godot_mcp` folder from the `addons` directory to your Godot project's `addons` folder
2. In your Godot project, go to "Project > Project Settings > Plugins"
3. Find the "Godot MCP" plugin and enable it
4. You should now see a "Godot MCP Server" panel in your editor's right dock

### 2. Set up the MCP Server

1. Navigate to the `server` directory in your terminal
2. Install dependencies:
   ```bash
   npm install
   ```
3. Build the TypeScript code:
   ```bash
   npm run build
   ```

## Usage

### 1. Start the Godot WebSocket Server

1. Open your Godot project
2. In the "Godot MCP Server" panel, set the port (default: 9080)
3. Click "Start Server"
4. You should see a message confirming the server is running

### 2. Start the MCP Server

1. In the `server` directory, run:
   ```bash
   npm start
   ```
2. The server will automatically connect to the Godot WebSocket server

### 3. Connect Claude

1. In Claude desktop app, go to Settings > Developer
2. Enable Model Context Protocol
3. Add a new MCP tool with the following configuration:
   - Name: Godot MCP
   - Command: `node /path/to/godot-mcp/server/dist/index.js`
   - Working directory: `/path/to/your/project`
4. Save the configuration
5. When chatting with Claude, you can now access Godot tools

## Troubleshooting

### Connection Issues

If the MCP Server can't connect to Godot:
1. Make sure the Godot WebSocket server is running (check the panel)
2. Verify that the port numbers match in both the Godot panel and `godot_connection.ts`
3. Check for any firewall issues blocking localhost connections

### Command Errors

If commands are failing:
1. Check the logs in both the Godot panel and terminal running the MCP server
2. Make sure your Godot project is properly set up and has an active scene
3. Verify that paths used in commands follow the correct format (usually starting with "res://")