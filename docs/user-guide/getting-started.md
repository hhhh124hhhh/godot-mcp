# Getting Started with Godot MCP

This guide will walk you through your first steps with the Godot MCP integration, demonstrating how to use Claude to interact with Godot projects through natural language.

## Prerequisites

Before you begin, ensure you have:

1. Completed the [Installation Guide](./installation-guide.md)
2. A running Godot project with the MCP addon enabled
3. The MCP server configured and running
4. Claude Desktop set up with the MCP server

## Basic Workflow

The typical workflow when using Godot MCP with Claude follows these steps:

1. Open your Godot project
2. Start the MCP WebSocket server from the Godot MCP panel
3. Launch Claude Desktop
4. Ask Claude to perform operations on your Godot project

## Example Scenarios

Let's walk through some basic scenarios to help you get familiar with using Godot MCP.

### Creating a Simple Scene

In this scenario, we'll ask Claude to help us create a simple scene with a player character.

1. **Start a new conversation with Claude**

2. **Ask Claude to create a new scene with some basic elements:**

   ```
   I'm working on a 2D platformer in Godot. Can you help me create a simple scene with a player character sprite, a platform, and a collectible?
   ```

3. **Claude will use MCP to create the scene:**

   Claude will create a new scene structure with the requested elements. You'll see Claude accessing the Godot MCP tools, and you may be prompted to approve certain operations.

4. **Examine the results in Godot:**

   After Claude completes the operations, switch to Godot and you should see the newly created scene with the player character, platform, and collectible.

### Adding Game Logic with GDScript

Now, let's add some basic game logic to our scene.

1. **Ask Claude to add movement logic to the player character:**

   ```
   Can you add a simple movement script to the player character? I want it to move left and right with the arrow keys and jump when pressing the Space bar.
   ```

2. **Claude will create and attach a script:**

   Claude will create a GDScript file with the requested functionality and attach it to the player character node.

3. **Test the script in Godot:**

   Press F5 in Godot to run the scene and test the player character movement.

### Debugging and Fixing Issues

If there are issues with the implementation, you can ask Claude to help debug and fix them.

1. **Describe the issue to Claude:**

   ```
   The player character moves left and right, but the jump functionality isn't working correctly. Can you fix it?
   ```

2. **Claude will analyze and fix the code:**

   Claude will examine the script, identify the issue, and make the necessary corrections.

## Common Tasks

Here are some common tasks you might want to perform with Godot MCP:

### Working with Nodes

#### Creating Nodes

```
Create a CanvasLayer node named UI and add a Label node as its child with the text "Score: 0".
```

#### Modifying Nodes

```
Change the position of the player character to (100, 200) and set its scale to (2, 2).
```

#### Organizing Nodes

```
Create a new Node2D called "Enemies" and move all enemy nodes under it.
```

### Working with Scripts

#### Creating Scripts

```
Create a script for the collectible that makes it spin and disappear when the player touches it.
```

#### Modifying Scripts

```
Modify the player script to add a double jump feature when pressing the Space bar twice.
```

#### Debugging Scripts

```
The collectible's collision detection isn't working. Can you check the script and fix any issues?
```

### Working with Resources

#### Creating Resources

```
Create a new ShaderMaterial for the player that adds a glowing effect.
```

#### Modifying Resources

```
Update the player's material to change the glow color to blue.
```

## Advanced Examples

### Creating a Complete Game Feature

Let's create a more complex feature - a scoring system with UI:

```
I'd like to add a scoring system to my game. When the player collects items, the score should increase. Please create:
1. A UI with a score label
2. A script to track the score
3. Logic to update the score when collecting items
```

Claude will go through these steps:
1. Create a UI CanvasLayer with a Label
2. Create a global script to track the score
3. Update the collectible script to increase the score
4. Connect everything so the UI updates when the score changes

### Building a Menu System

```
I need a main menu for my game with "Play", "Options", and "Quit" buttons. Can you implement this?
```

Claude will:
1. Create a new menu scene with appropriate nodes
2. Add UI elements for the buttons
3. Write scripts to handle button clicks
4. Implement scene transitions for the "Play" button

## Tips for Working with Claude and Godot MCP

1. **Be specific**: Clearly describe what you want Claude to create or modify
2. **Start simple**: Begin with basic tasks before moving to complex ones
3. **Iterate**: Have Claude make small changes and test frequently
4. **Provide context**: Tell Claude about your project structure when relevant
5. **Accept or modify suggestions**: Claude might suggest alternatives; feel free to go with them or ask for changes

## Troubleshooting

### Claude can't connect to Godot

If Claude reports it can't connect to Godot:
1. Check that the WebSocket server is running in Godot
2. Verify the port number matches in both the Godot addon and MCP server configuration
3. Restart Claude Desktop and try again

### Command execution fails

If commands fail to execute:
1. Check the Godot MCP panel logs for errors
2. Make sure you're referencing valid paths in your requests
3. Verify that the node types and property names are correct

### Changes not appearing in Godot

If changes made by Claude don't appear in Godot:
1. Make sure the scene is saved after changes
2. Try refreshing the Godot editor
3. Check if there were any error messages during command execution

## Next Steps

Now that you're familiar with the basics, explore these advanced topics:
- [Command Reference](./command-reference.md) for a complete list of available commands
- [Architecture](./architecture.md) to understand how the system works
- Extend the functionality by adding custom commands to the Godot addon

Happy game development with Claude and Godot MCP!