# Godot MCP Addon

This addon enables the Godot Editor to communicate with the Model Context Protocol (MCP), allowing AI assistants like Claude to interact with and manipulate Godot projects.

## Features

- **WebSocket Server**: Built-in WebSocket server for bidirectional communication
- **Command Execution**: Execute commands to manipulate nodes, scripts, and resources
- **Editor Integration**: Seamless integration with the Godot editor
- **Configurable**: Customizable port, logging, and security settings

## Installation

1. Copy the `godot_mcp` folder to your Godot project's `addons` directory
2. Enable the plugin in Godot via Project → Project Settings → Plugins
3. The MCP panel will appear in the editor dock

## Usage

### Starting the Server

1. Open the MCP panel in the Godot editor
2. Configure the server port (default: 9080)
3. Click "Start Server" to begin accepting connections
4. The status indicator will turn green when the server is running

### Stopping the Server

1. Click "Stop Server" in the MCP panel
2. The status indicator will turn red when the server is stopped

### Viewing Logs

The MCP panel includes a log view that shows:
- Connection events
- Command execution
- Errors and warnings

### Configuration

The following settings can be configured in the MCP panel:

| Setting | Description | Default |
|---------|-------------|---------|
| Port | WebSocket server port | 9080 |
| Allow Remote | Accept non-localhost connections | Disabled |
| Log Level | Detail level for logging | Info |
| Auto Start | Start server when Godot opens | Disabled |

## Command Reference

The addon supports the following commands:

### Node Commands

- **create_node**: Create a new node in the scene tree
  ```json
  {
    "type": "create_node",
    "params": {
      "parent_path": "/root",
      "node_type": "Sprite2D",
      "node_name": "NewSprite"
    }
  }
  ```

- **delete_node**: Remove a node from the scene tree
  ```json
  {
    "type": "delete_node",
    "params": {
      "node_path": "/root/NewSprite"
    }
  }
  ```

- **update_node**: Modify node properties
  ```json
  {
    "type": "update_node",
    "params": {
      "node_path": "/root/NewSprite",
      "properties": {
        "position": [100, 100],
        "scale": [2, 2]
      }
    }
  }
  ```

- **list_nodes**: Get a list of nodes in the scene tree
  ```json
  {
    "type": "list_nodes",
    "params": {
      "parent_path": "/root",
      "recursive": true
    }
  }
  ```

### Script Commands

- **create_script**: Create a new GDScript file
  ```json
  {
    "type": "create_script",
    "params": {
      "script_path": "res://scripts/new_script.gd",
      "content": "extends Node\n\nfunc _ready():\n\tpass",
      "node_path": "/root/NewNode"  // Optional, attach to node
    }
  }
  ```

- **edit_script**: Modify an existing script
  ```json
  {
    "type": "edit_script",
    "params": {
      "script_path": "res://scripts/new_script.gd",
      "content": "extends Node\n\nfunc _ready():\n\tprint('Hello, World!')"
    }
  }
  ```

- **get_script**: Retrieve a script's content
  ```json
  {
    "type": "get_script",
    "params": {
      "script_path": "res://scripts/new_script.gd"
    }
  }
  ```

### Resource Commands

- **create_resource**: Create a new resource
  ```json
  {
    "type": "create_resource",
    "params": {
      "resource_type": "ShaderMaterial",
      "resource_path": "res://materials/new_material.tres",
      "properties": {
        "shader_parameter/color": [1, 0, 0, 1]
      }
    }
  }
  ```

- **list_resources**: List available resources
  ```json
  {
    "type": "list_resources",
    "params": {
      "directory": "res://materials",
      "type_filter": "Material"  // Optional
    }
  }
  ```

### Scene Commands

- **save_scene**: Save the current scene
  ```json
  {
    "type": "save_scene",
    "params": {
      "path": "res://scenes/new_scene.tscn"  // Optional, uses current path if not provided
    }
  }
  ```

- **open_scene**: Open a scene
  ```json
  {
    "type": "open_scene",
    "params": {
      "path": "res://scenes/main.tscn"
    }
  }
  ```

## Response Format

All commands return responses in the following format:

### Success Response
```json
{
  "status": "success",
  "result": {
    // Command-specific result data
  },
  "commandId": "cmd_123"  // Same ID as in the command
}
```

### Error Response
```json
{
  "status": "error",
  "message": "Detailed error message",
  "commandId": "cmd_123"  // Same ID as in the command
}
```

## Implementation Details

### File Structure

```
godot_mcp/
├── plugin.cfg                 # Plugin configuration
├── godot_mcp.gd               # Main plugin file
├── websocket_server.gd        # WebSocket server implementation
├── command_handler.gd         # Command routing and execution
├── ui/                        # UI components
│   ├── mcp_panel.gd           # MCP control panel script
│   └── mcp_panel.tscn         # MCP control panel scene
└── utils/                     # Utility functions
    ├── node_utils.gd          # Node manipulation utilities
    ├── resource_utils.gd      # Resource manipulation utilities
    └── script_utils.gd        # Script manipulation utilities
```

### Key Classes

- **GodotMCP**: Main plugin class that integrates with Godot editor
- **MCPWebSocketServer**: WebSocket server implementation
- **MCPCommandHandler**: Command routing and execution
- **MCPPanel**: UI interface for controlling the server

## Development

### Prerequisites

- Godot Engine 4.x
- Basic knowledge of GDScript
- Understanding of Godot's scene system

### Adding New Commands

To add a new command:

1. Add a new method to the `MCPCommandHandler` class
2. Implement the command logic using Godot's API
3. Update the command routing in the `_handle_command` method
4. Document the new command in this README

### Debugging

The addon provides several debugging features:

- Detailed logs in the MCP panel
- Option to save logs to file
- Editor console output for critical errors

## Troubleshooting

### Server Won't Start

- Check if the port is already in use
- Verify that the plugin is properly enabled
- Ensure the Godot editor has network permissions (especially on macOS)

### Connection Issues

- Verify the client is using the correct WebSocket URL
- Check if any firewalls are blocking the connection
- Ensure the "Allow Remote" setting is enabled if connecting from another machine

### Command Execution Errors

- Check the command format and parameters
- Verify that paths exist and are correctly formatted
- Look for detailed error messages in the MCP panel logs

## License

This plugin is provided under the MIT License. See the LICENSE file for details.

## Acknowledgements

This plugin is inspired by the Blender MCP implementation and builds upon the Model Context Protocol developed by Anthropic.