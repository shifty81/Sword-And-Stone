# Scripts Directory

This directory contains all GDScript files organized by system and purpose.

## Directory Structure

- **autoload/** - Singleton/autoload scripts
  - `game_manager.gd` - Main game manager (autoload)

- **components/** - Reusable component scripts
  - Health components, state machines, etc.

- **entities/** - Entity-specific scripts
  - `player/` - Player controller and behavior

- **systems/** - Core game systems
  - `crafting/` - Crafting stations and recipes
  - `inventory/` - Inventory management and items
  - `voxel/` - Voxel system (chunks, types, meshing)
  - `world_generation/` - World generation and terrain

- **ui/** - User interface scripts
  - `hud.gd` - HUD controller

- **utils/** - Utility and helper scripts
  - Math helpers, data structures, etc.

## Coding Standards

- All scripts should use `class_name` for global class registration
- Use type hints for all parameters and return values
- Document classes and complex methods with doc comments (##)
- Follow Godot's GDScript style guide
- Use @export for editor-configurable properties

## Script Organization

Scripts should mirror their associated scenes when applicable:
- `scenes/entities/player/` → `scripts/entities/player/`
- `scenes/ui/menus/` → `scripts/ui/`
