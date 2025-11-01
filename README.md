# Sword And Stone

A 3D voxel survival game inspired by Vintage Story, built with Godot 4.x. Explore procedurally generated worlds with continents and rivers, gather resources, and craft medieval weapons and armor through an innovative voxel-based smithing system.

## Features

### World Generation ⭐ **ENHANCED**
- **Procedural Continents**: Large-scale landmasses generated using Perlin noise
- **6 Diverse Biomes**: Plains, forests, mountains, deserts, tundra, and swamps with temperature/moisture-based generation
- **Dynamic Rivers**: Rivers flow from highlands to the ocean, carving through terrain
- **Ore Veins**: 6 ore types (coal, iron, copper, tin, gold, silver) spawn at specific depths
- **Procedural Trees**: Natural tree placement in forests (30% density) and plains (5% density)
- **Medieval Structures**: Spawn points for villages, watchtowers, forges, castles, and more
- **Voxel-Based World**: Fully destructible and buildable terrain with 24 block types

### Player Mechanics
- **First-Person Exploration**: WASD movement with mouse look
- **Voxel Interaction**: Break and place blocks in the world
- **Inventory System**: Collect and manage resources

### Crafting System
- **Quality-Based Items**: Items have quality levels from Poor to Legendary
- **Medieval Equipment**: Craft swords, axes, armor, and tools
- **Voxel Smithing**: Shape hot metal by moving voxels on an anvil to create weapons
- **Material Variety**: Copper, bronze, iron, and steel equipment

### Graphics
- **Borderlands-Style Cel Shading**: Custom shader with thick outlines
- **Stylized Visuals**: Non-photorealistic rendering for a unique look
- **Procedural Textures**: ⭐ **NEW** 28 procedurally generated 16×16 medieval textures (19 terrain + 9 items)

## Getting Started

### Requirements
- Godot 4.2 or newer

### Installation
1. Clone this repository
2. Open the project in Godot 4.x
3. Press F5 or click the Play button to run

### Controls
- **W/A/S/D**: Move
- **Space**: Jump
- **Shift**: Sprint
- **Mouse**: Look around
- **Left Click**: Break voxel
- **Right Click**: Place voxel
- **E**: Toggle inventory (future feature)
- **ESC**: Toggle mouse cursor

## Project Structure

```
├── assets/                  # Game assets (models, textures, audio, etc.)
│   ├── audio/              # Music, SFX, and ambient sounds
│   ├── fonts/              # Custom fonts
│   ├── models/             # 3D models
│   ├── sprites/            # 2D sprites and icons
│   ├── textures/           # Texture files
│   └── vfx/                # Visual effects
├── docs/                   # Documentation
├── resources/              # Custom Godot resources
│   ├── items/             # Item resource files
│   ├── recipes/           # Crafting recipes
│   ├── materials/         # Material resources (cel-shader)
│   └── themes/            # UI themes
├── scenes/                 # Godot scene files
│   ├── main/              # Main game scene
│   ├── ui/                # User interface scenes
│   ├── entities/          # Player, NPCs, enemies
│   └── world/             # World-related scenes
├── scripts/                # GDScript files
│   ├── autoload/          # Singleton scripts (GameManager)
│   ├── components/        # Reusable components
│   ├── entities/          # Entity scripts
│   │   └── player/       # Player controller
│   ├── systems/           # Core game systems
│   │   ├── crafting/     # Crafting stations
│   │   ├── inventory/    # Items and inventory
│   │   ├── voxel/        # Voxel and chunks
│   │   └── world_generation/  # World generator
│   ├── ui/               # UI scripts
│   └── utils/            # Helper scripts
└── shaders/              # Custom shaders (cel-shading)
```

See individual README.md files in each directory for more details.

## Development Roadmap

- [x] Procedural world generation with continents
- [x] River generation system
- [x] Player character controller
- [x] Voxel terrain system
- [x] Basic crafting infrastructure
- [x] Quality-based item system
- [x] Smithing system framework
- [x] Cel-shaded graphics
- [ ] Combat system
- [ ] More weapon and armor types
- [ ] Advanced AI and creatures
- [ ] Multiplayer support

## Technical Details

### World Generation
The world uses a multi-layered noise approach:
- Continental noise determines landmasses vs. ocean
- Terrain noise adds height variation
- Rivers flow downhill using a simple pathfinding algorithm

### Voxel System
Chunks are 16x16x16 voxel segments that generate on-demand around the player. Each voxel type has properties like hardness, color, and transparency.

### Smithing System
The anvil station allows voxel-based smithing where players literally shape hot metal by hammering voxels into place. The quality of the final item depends on how accurately the shape matches the intended design.

## License

This project is a homage to Vintage Story. All code is provided as-is for educational and entertainment purposes.

## Credits

Inspired by Vintage Story - an excellent survival crafting game. 
