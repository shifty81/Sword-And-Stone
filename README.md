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

### Physics Engine ⭐ **NEW**
- **Comprehensive Physics System**: Built on Godot's physics engine with custom enhancements
- **Physics Materials**: 6 material types (stone, grass, ice, metal, wood, rubber) with unique properties
- **Dynamic Objects**: Physics-based items, projectiles, and falling blocks
- **Collision Layers**: 7 layers for precise collision filtering
- **Environmental Triggers**: Wind zones, damage areas, bounce pads, and more
- **Physics Debugging**: Visual debugging tools for development

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
- **Procedural Textures**: ⭐ **UPDATED** All 19 terrain textures now generated automatically on startup
- **Vibrant Colors**: ⭐ **IMPROVED** Enhanced brightness for better visibility

## Getting Started

> **⚠️ Important**: This is a **Godot project**, not a C++/CMake project! It does NOT require compilation.  
> If you see references to C++ or CMake, those are **archived for reference** in `archived_cpp/`.  
> See [BUILD.md](BUILD.md) for detailed instructions or [docs/CONVERSION.md](docs/CONVERSION.md) for the C++ → Godot conversion story.

### Requirements
- **Godot 4.2 or newer** - Download from [godotengine.org](https://godotengine.org/download)
- **No compilers needed** - Godot uses interpreted GDScript
- **No build system** - Just open and run!

### Quick Start
1. **Install Godot 4.2+** from [godotengine.org](https://godotengine.org/download)
2. **Import Project**: Open Godot → Import → Select `project.godot` from this directory
3. **Run**: Press **F5** or click the Play button ▶️
4. Textures will generate automatically on first run

📖 **Full build instructions**: See [BUILD.md](BUILD.md)

### Zylann.Voxel Addon (Optional Professional Upgrade)

This project includes the Zylann.Voxel professional voxel engine addon!

**Windows Users - Quick Setup:**
1. Open PowerShell in project directory
2. Run: `cd addons\zylann.voxel && .\download_windows_binaries.ps1`
3. Restart Godot (requires 4.4.1+)

**Benefits:**
- 6-10x faster chunk generation
- Level of Detail (LOD) for massive worlds
- Efficient chunk streaming and management
- Already integrated with your biomes, rivers, and ore generation!

See [docs/WINDOWS_SETUP.md](docs/WINDOWS_SETUP.md) for complete guide or [docs/INTEGRATION_QUICKSTART.md](docs/INTEGRATION_QUICKSTART.md) for quick integration reference.

### Troubleshooting
- **"Parsing of config failed" error?** This is now fixed! The addon loads as a GDExtension, not a plugin.
- **Grey grid on ground?** See [docs/TEXTURE_FIXES.md](docs/TEXTURE_FIXES.md) for solutions
- **Want to explore other world gen systems?** See [docs/ASSETLIB_GUIDE.md](docs/ASSETLIB_GUIDE.md)
- **Need detailed addon integration info?** See [docs/GODOT_VOXEL_INTEGRATION.md](docs/GODOT_VOXEL_INTEGRATION.md)

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
│   ├── autoload/          # Singleton scripts (GameManager, PhysicsManager)
│   ├── components/        # Reusable components
│   ├── entities/          # Entity scripts
│   │   └── player/       # Player controller
│   ├── systems/           # Core game systems
│   │   ├── crafting/     # Crafting stations
│   │   ├── inventory/    # Items and inventory
│   │   ├── physics/      # Physics system (items, projectiles, triggers)
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
- [x] Physics engine implementation
- [ ] Optional godot_voxel integration (professional voxel engine)
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

**Optional Enhancement**: The project can integrate [Zylann's godot_voxel](https://github.com/Zylann/godot_voxel) for professional-grade performance with LOD, efficient streaming, and smooth terrain options. See [GODOT_VOXEL_INTEGRATION.md](docs/GODOT_VOXEL_INTEGRATION.md) for details.

### Physics System
The game uses Godot's built-in physics engine with custom enhancements:
- **PhysicsManager** singleton manages all physics objects and materials
- **7 collision layers** for precise object interaction filtering
- **6 physics materials** with unique friction and bounce properties
- **Dynamic objects** include items, projectiles, and falling blocks
- **Environmental triggers** for gameplay mechanics (wind, damage zones, etc.)
- See [docs/PHYSICS_SYSTEM.md](docs/PHYSICS_SYSTEM.md) for detailed documentation

### Smithing System
The anvil station allows voxel-based smithing where players literally shape hot metal by hammering voxels into place. The quality of the final item depends on how accurately the shape matches the intended design.

## License

This project is a homage to Vintage Story. All code is provided as-is for educational and entertainment purposes.

## Credits

Inspired by Vintage Story - an excellent survival crafting game. 
