# Godot MCP Server

This TypeScript server implements the Model Context Protocol (MCP) to connect Claude AI with Godot Engine. It allows Claude to interact with Godot projects through natural language commands.

## Features

- **MCP Implementation**: Full implementation of the Model Context Protocol
- **Godot Connection**: WebSocket-based connection to the Godot editor
- **Tool Definitions**: Pre-defined tools for common Godot operations
- **Error Handling**: Comprehensive error handling and logging
- **Session Management**: Support for multiple client sessions

## Installation

### Prerequisites

- Node.js 16.x or higher
- npm or yarn
- Godot Engine 4.x with the Godot MCP addon installed

### Setup

1. Clone the repository
2. Install dependencies:

```bash
npm install
```

3. Build the server:

```bash
npm run build
```

## Usage

### Starting the Server

Start the server using one of the following methods:

#### CLI

```bash
# Start with stdio transport (for Claude Desktop)
npm start

# Start with SSE transport (for web-based Claude)
npm run start:sse
```

#### Programmatic Usage

```typescript
import { server } from './src/index';

// Start with stdio transport
server.start({
  transportType: 'stdio'
});

// Start with SSE transport
server.start({
  transportType: 'sse',
  sse: {
    endpoint: '/sse',
    port: 8080
  }
});
```

### Connecting to Godot

1. Ensure the Godot MCP addon is installed and enabled in your Godot project
2. Start the WebSocket server in Godot using the MCP panel
3. The MCP server will automatically connect to Godot when needed

### Configuration

Configure the server by creating a `.env` file:

```
# Godot WebSocket connection
GODOT_WS_URL=ws://localhost:9080

# Server settings
LOG_LEVEL=info
COMMAND_TIMEOUT=10000

# SSE transport settings (if using SSE)
SSE_PORT=8080
SSE_ENDPOINT=/sse
```

## Tool Reference

The server provides the following tools to Claude:

### Node Management

- **create_node**: Create a new node in the scene tree
- **delete_node**: Remove a node from the scene tree
- **update_node**: Update node properties
- **list_nodes**: Get a list of nodes in the scene

### Script Management

- **create_script**: Create a new GDScript file
- **edit_script**: Modify an existing script
- **get_script**: Get a script's content

### Resource Management

- **create_resource**: Create a new resource
- **list_resources**: List resources in a directory

### Scene Management

- **save_scene**: Save the current scene
- **open_scene**: Open a scene file

## Implementation Details

### Architecture

The server follows a modular architecture:

```
src/
├── index.ts              # Entry point
├── godot_connection.ts   # Godot WebSocket connection manager
├── tools/                # Tool definitions
│   ├── node_tools.ts     # Node manipulation tools
│   ├── script_tools.ts   # Script manipulation tools
│   └── resource_tools.ts # Resource manipulation tools
└── utils/                # Utility functions
    ├── websocket.ts      # WebSocket utilities
    └── error_handler.ts  # Error handling utilities
```

### Key Classes

- **GodotConnection**: Manages the WebSocket connection to Godot
- **FastMCP**: Implements the Model Context Protocol
- **Tool Definitions**: Define operations available to Claude

### WebSocket Communication

The server communicates with Godot using a JSON-based protocol:

#### Command Format
```json
{
  "type": "command_type",
  "params": {
    "param1": "value1",
    "param2": "value2"
  },
  "commandId": "unique_command_id"
}
```

#### Response Format
```json
{
  "status": "success|error",
  "result": { ... },
  "message": "Error message if status is error",
  "commandId": "matching_command_id"
}
```

## Development

### Project Structure

```
godot-mcp-server/
├── src/                  # Source code
├── dist/                 # Compiled output
├── tests/                # Test files
├── docs/                 # Documentation
├── package.json          # Project configuration
└── tsconfig.json         # TypeScript configuration
```

### Adding New Tools

To add a new tool:

1. Create a new function in the appropriate tool file
2. Register the tool with FastMCP
3. Add parameter validation using Zod
4. Implement the tool logic using the Godot connection

Example:

```typescript
server.addTool({
  name: 'my_new_tool',
  description: 'Description of what the tool does',
  parameters: z.object({
    param1: z.string().describe('Description of param1'),
    param2: z.number().describe('Description of param2')
  }),
  execute: async (args) => {
    const godot = getGodotConnection();
    try {
      const result = await godot.sendCommand('my_command', args);
      return `Operation completed: ${result.someValue}`;
    } catch (error) {
      throw new Error(`Failed: ${error.message}`);
    }
  }
});
```

### Building

```bash
# Build the project
npm run build

# Build in watch mode
npm run build:watch
```

### Testing

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch
```

## Troubleshooting

### Connection Issues

- Verify the Godot WebSocket server is running
- Check that the WebSocket URL is correct
- Ensure no firewalls are blocking the connection

### Tool Execution Errors

- Check the tool parameters
- Look for detailed error messages in the logs
- Verify the Godot project is properly set up

### MCP Protocol Issues

- Check the Claude Desktop configuration
- Verify the MCP server is properly registered
- Look for errors in the Claude Desktop logs

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgements

This project is built with:
- [FastMCP](https://github.com/punkpeye/fastmcp) - TypeScript MCP implementation
- [ws](https://github.com/websockets/ws) - WebSocket implementation
- [zod](https://github.com/colinhacks/zod) - Schema validation