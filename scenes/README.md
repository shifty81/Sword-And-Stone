# Scenes Directory

This directory contains all Godot scene files (.tscn) organized by purpose.

## Directory Structure

- **main/** - Main game scenes
  - `main.tscn` - Primary game scene with world and player

- **ui/** - User interface scenes
  - `hud/` - Heads-up display
  - `menus/` - Main menu, pause menu, settings, etc.

- **entities/** - Game entities (player, NPCs, enemies)
  - `player/` - Player character scenes
  - `enemies/` - Enemy creature scenes (future)
  - `npcs/` - Non-player characters (future)

- **world/** - World-related scenes
  - `chunks/` - Chunk prefabs and variants
  - `structures/` - Generated structures (villages, dungeons, etc.)

## Best Practices

- Each scene should have a clear, single purpose
- Keep scene hierarchy shallow when possible
- Use instancing for reusable components
- Companion scripts should mirror the scene structure (scripts/entities/player/ for scenes/entities/player/)
