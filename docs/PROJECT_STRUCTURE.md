# Project Structure Reference

This document provides a complete reference of the Sword And Stone project structure, following Godot 4.x best practices.

## Directory Tree

```
Sword-And-Stone/
├── .git/                           # Git version control
├── .gitignore                      # Git ignore rules
│
├── assets/                         # All game assets
│   ├── README.md                   # Assets directory documentation
│   ├── audio/                      # Sound and music assets
│   │   ├── ambient/               # Ambient sounds
│   │   ├── music/                 # Background music
│   │   └── sfx/                   # Sound effects
│   ├── fonts/                     # Custom fonts
│   ├── models/                    # 3D models (.gltf, .obj, etc.)
│   │   ├── characters/           # Character models
│   │   ├── environment/          # Environment models
│   │   ├── items/                # Item models
│   │   └── props/                # Prop models
│   ├── sprites/                   # 2D sprites and textures
│   │   ├── effects/              # Effect sprites
│   │   ├── icons/                # UI icons
│   │   └── ui/                   # UI graphics
│   ├── textures/                  # 3D textures
│   │   ├── items/                # Item textures
│   │   ├── materials/            # Material textures
│   │   └── terrain/              # Terrain textures
│   └── vfx/                       # Visual effects
│
├── docs/                          # Documentation
│   ├── README.md                  # Documentation index
│   ├── ARCHITECTURE.md           # System architecture and diagrams
│   ├── BUGFIX_SUMMARY.md         # Bug fixes and improvements
│   ├── DEVELOPMENT.md            # Development guide
│   ├── IMPLEMENTATION.md         # Implementation details
│   ├── METADATA_IMPLEMENTATION.md # Metadata documentation
│   ├── PROJECT_SUMMARY.md        # Project completion summary
│   ├── QUICKSTART.md             # Quick start guide
│   └── WORLD_GENERATION_FIX.md   # World generation documentation
│
├── resources/                     # Custom Godot resources
│   ├── items/                    # Item resource files
│   │   ├── battle_axe.gd        # Battle axe script
│   │   ├── battle_axe.tres      # Battle axe resource
│   │   ├── iron_chestplate.gd   # Iron chestplate script
│   │   ├── iron_chestplate.tres # Iron chestplate resource
│   │   ├── iron_sword.gd        # Iron sword script
│   │   ├── iron_sword.tres      # Iron sword resource
│   │   ├── steel_longsword.gd   # Steel longsword script
│   │   └── steel_longsword.tres # Steel longsword resource
│   ├── materials/                # Material resources
│   │   └── cel_material.tres    # Cel-shader material
│   ├── recipes/                  # Crafting recipes
│   │   ├── battle_axe_recipe.tres
│   │   ├── iron_chestplate_recipe.tres
│   │   ├── iron_sword_recipe.tres
│   │   └── steel_longsword_recipe.tres
│   ├── themes/                   # UI themes
│   └── README.md                 # Resources documentation (existing)
│
├── scenes/                        # Godot scene files (.tscn)
│   ├── README.md                 # Scenes directory documentation
│   ├── entities/                 # Entity scenes
│   │   └── player/              # Player scenes (future)
│   ├── main/                     # Main game scenes
│   │   └── main.tscn            # Main game scene
│   ├── ui/                       # UI scenes
│   │   ├── hud/                 # HUD scenes
│   │   │   └── hud.tscn         # HUD scene
│   │   └── menus/               # Menu scenes (future)
│   └── world/                    # World scenes
│       ├── chunks/              # Chunk scenes (future)
│       └── structures/          # Structure scenes (future)
│
├── scripts/                       # GDScript files (.gd)
│   ├── README.md                 # Scripts directory documentation
│   ├── autoload/                 # Singleton/autoload scripts
│   │   └── game_manager.gd      # Main game manager singleton
│   ├── components/               # Reusable component scripts
│   ├── entities/                 # Entity-specific scripts
│   │   └── player/              # Player scripts
│   │       └── player_controller.gd  # Player controller
│   ├── systems/                  # Core game systems
│   │   ├── crafting/            # Crafting system
│   │   │   ├── anvil_station.gd # Anvil crafting station
│   │   │   └── crafting_station.gd  # Base crafting station
│   │   ├── inventory/           # Inventory and items
│   │   │   ├── armor.gd         # Armor item class
│   │   │   ├── inventory.gd     # Inventory management
│   │   │   ├── item.gd          # Base item class
│   │   │   └── weapon.gd        # Weapon item class
│   │   ├── voxel/               # Voxel system
│   │   │   ├── chunk.gd         # Chunk management
│   │   │   └── voxel_type.gd    # Voxel type definitions
│   │   └── world_generation/    # World generation
│   │       └── world_generator.gd   # World generator
│   ├── ui/                       # UI scripts
│   │   └── hud.gd               # HUD controller
│   └── utils/                    # Utility scripts
│
├── shaders/                       # Shader files (.gdshader)
│   ├── cel_shader.gdshader       # Main cel-shader
│   └── cel_shader_simple.gdshader # Simplified cel-shader
│
├── icon.svg                       # Project icon
├── project.godot                  # Godot project configuration
└── README.md                      # Main project README

```

## Key Organizational Principles

### 1. Separation of Concerns
- **assets/** - All binary assets (models, audio, textures)
- **resources/** - Godot resource files (.tres, .res)
- **scenes/** - Scene files (.tscn)
- **scripts/** - Code files (.gd)
- **shaders/** - Shader files (.gdshader)

### 2. Logical Grouping
- Scripts organized by system (crafting, inventory, voxel, etc.)
- Scenes organized by purpose (main, ui, entities, world)
- Assets organized by type (audio, models, sprites, textures)

### 3. Scalability
- Each major directory has subdirectories for growth
- Clear naming conventions for easy navigation
- Companion scripts (.gd) stay with their resources (.tres) in resources/items/

### 4. Documentation
- README.md files in major directories explain structure
- All documentation centralized in docs/
- Clear separation between user docs and technical docs

## File Naming Conventions

### Scripts (.gd)
- Use snake_case: `player_controller.gd`, `crafting_station.gd`
- Include descriptive names: `world_generator.gd` not `generator.gd`

### Scenes (.tscn)
- Use snake_case: `main.tscn`, `hud.tscn`
- Name scenes after their primary purpose

### Resources (.tres)
- Use snake_case: `iron_sword.tres`, `cel_material.tres`
- Match companion script names: `iron_sword.gd` + `iron_sword.tres`

### Assets
- Use descriptive names with type suffix
- Examples: `sword_iron_diffuse.png`, `battle_music_01.ogg`
- Avoid generic names like `texture1.png` or `sound.wav`

## Path References

When referencing files in code or scenes, use:

```gdscript
# Resources
load("res://resources/materials/cel_material.tres")
load("res://resources/items/iron_sword.tres")

# Scripts (use class_name when possible)
var manager: GameManager = get_node("/root/GameManager")

# Scenes
var hud = preload("res://scenes/ui/hud/hud.tscn")
```

## Adding New Content

### New Script System
1. Create directory in `scripts/systems/your_system/`
2. Add system scripts with class_name
3. Document in system README if complex

### New Asset Type
1. Add to appropriate `assets/` subdirectory
2. Follow naming conventions
3. Keep source files separate (not in git)

### New Scene
1. Add to appropriate `scenes/` subdirectory
2. Create companion script in mirrored `scripts/` location
3. Use clear, descriptive names

### New Documentation
1. Add to `docs/` directory
2. Update `docs/README.md` index
3. Link to related documentation

## Migration Notes

This structure was reorganized from a flat structure to follow Godot 4.x best practices:

### Major Changes
- Documentation moved to `docs/`
- Materials moved to `resources/materials/`
- Scripts reorganized into `systems/`, `entities/`, `autoload/`, etc.
- Scenes organized by purpose
- Created `assets/` directory structure for future content

### Path Updates
All internal references updated:
- `res://materials/` → `res://resources/materials/`
- `res://scripts/crafting/` → `res://scripts/systems/crafting/`
- `res://scripts/player/` → `res://scripts/entities/player/`
- `res://scripts/world_generation/` → `res://scripts/systems/world_generation/`
- `res://scenes/main.tscn` → `res://scenes/main/main.tscn`

## Related Documentation

- [Main README](../README.md) - Project overview
- [Assets README](../assets/README.md) - Assets organization
- [Scenes README](../scenes/README.md) - Scene organization
- [Scripts README](../scripts/README.md) - Script organization
- [Architecture](ARCHITECTURE.md) - System architecture
- [Development Guide](DEVELOPMENT.md) - Development practices
