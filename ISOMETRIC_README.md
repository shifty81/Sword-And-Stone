# Sword and Stone - Isometric 2.5D Edition

## Overview

This project has been transformed into a 2.5D isometric survival game featuring Minecraft-style blocks, procedural world generation, and a modular building system.

## Features

### Isometric World
- **2.5D Isometric View**: Minecraft-inspired block rendering with 3D depth perception
- **Procedural Generation**: 128x128 tile worlds with varied terrain
- **Multiple Biomes**: 
  - Oceans (deep water)
  - Beaches (sand)
  - Plains (grass, dirt)
  - Mountains (stone, snow peaks)
  - Forests (trees on grassland)
  - Hills (gravel, stone)

### Terrain Types
15 different terrain blocks:
- Water, Sand, Grass, Dirt, Stone, Snow
- Wood, Leaves (for trees)
- Cobblestone, Gravel, Ice
- Ores: Coal, Iron, Gold, Copper

### Player Controls
- **WASD**: Move in isometric directions (diagonal movement)
- **Shift**: Sprint (250 → 400 speed)
- **B**: Toggle building mode
- **Mouse**: Look/aim direction

### Building System
- **Modular Building Pieces**: Walls, floors, roofs, doors, windows
- **Material Types**: Wood and Stone variants
- **Resource Management**: Collect resources to build structures
- **Building Mode**: Press 'B' to enter/exit building mode
  - Left Click: Place building piece
  - Right Click: Remove building piece
  - ESC: Cancel building mode

### World Generation
- **Noise-Based Terrain**: Multi-octave Perlin noise for natural landscapes
- **Height Variation**: Mountains rise naturally from plains
- **Moisture System**: Affects vegetation and terrain types
- **Tree Generation**: 15% spawn rate on grass tiles
- **Ocean Level**: Configurable water level at 35% elevation

## Quick Start

### Running the Game

1. **Open in Godot 4.3+**
   ```bash
   # Open the project in Godot
   godot --path /path/to/Sword-And-Stone
   ```

2. **Press F5 to Play**
   - The isometric world will generate automatically
   - You spawn at the center (0, 0)

3. **Explore and Build**
   - Move around with WASD
   - Press B to enter building mode
   - Place structures to create your shelter

### Regenerating the Tileset

If you need to regenerate the isometric tileset:

```bash
cd /path/to/Sword-And-Stone
python3 generate_isometric_tileset.py
```

This creates `assets/textures/terrain/isometric_tileset.png` with all 15 terrain types.

## Technical Details

### Isometric Tile Rendering
- **Tile Size**: 64x48 pixels per tile
  - Top face (diamond): 64x32
  - Vertical faces: 64x16
- **Three-Face Rendering**: Each block shows top, left, and right faces
- **Color Shading**: Different lighting on each face for depth
- **Outline**: Black outlines for clarity

### Coordinate System
- **Isometric Projection**: 
  ```
  iso_x = cart_x - cart_y
  iso_y = (cart_x + cart_y) * 0.5
  ```
- **Tile Coordinates**: Integer grid positions
- **World Coordinates**: Pixel positions in scene

### World Generator
- **Chunk-less Design**: Generates entire world at startup (128x128 default)
- **Multi-Layer Noise**: 
  - Terrain noise (elevation)
  - Height detail (mountains)
  - Moisture (biomes)
- **Seeded Generation**: Use `world_seed` for reproducible worlds

### Building System
- **Layer-Based**: Buildings on layer 3, separate from terrain
- **Grid Snapping**: Automatic alignment to tile grid
- **Collision Detection**: Prevents building on water or existing structures
- **Resource Cost**: Each piece requires materials

## File Structure

```
Sword-And-Stone/
├── assets/
│   └── textures/
│       └── terrain/
│           └── isometric_tileset.png (Generated)
├── scripts/
│   ├── entities/player/
│   │   └── isometric_player.gd
│   ├── systems/
│   │   ├── building/
│   │   │   └── isometric_building_system.gd
│   │   └── world_generation/
│   │       └── isometric_world_generator.gd
│   └── utils/
│       └── isometric_tile_generator.gd
├── scenes/
│   └── main/
│       └── isometric_main.tscn
└── generate_isometric_tileset.py
```

## Customization

### Changing World Size
Edit `isometric_main.tscn` or in the WorldGenerator node:
```gdscript
world_size_x = 256  # Larger world
world_size_y = 256
```

### Adjusting Tree Density
```gdscript
tree_density = 0.3  # More trees (30% chance)
```

### Modifying Ocean Level
```gdscript
ocean_level = 0.4  # Higher water level (more ocean)
```

### Adding New Terrain Types
1. Add color to `TERRAIN_COLORS` in `generate_isometric_tileset.py`
2. Run the script to regenerate tileset
3. Add enum value to `IsometricWorldGenerator.TerrainType`
4. Update `terrain_atlas_coords` mapping
5. Add generation logic to `get_terrain_type()`

## Performance

- **World Size**: 128x128 = 16,384 tiles
- **Generation Time**: < 1 second
- **Memory**: ~50MB for full world
- **FPS**: 60+ fps on modern hardware

For larger worlds (256x256+), consider:
- Chunk-based loading
- View distance culling
- LOD for distant tiles

## Next Steps

Potential enhancements:
- [ ] Animated player sprite with 8 directions
- [ ] Mining/harvesting system for resources
- [ ] Crafting menu UI
- [ ] Save/load world state
- [ ] Multiplayer support
- [ ] NPCs and creatures
- [ ] Day/night cycle
- [ ] Weather effects
- [ ] Dungeon generation
- [ ] Boss encounters

## Credits

Inspired by:
- Minecraft's isometric block style
- Vintage Story's survival mechanics
- Godot Engine's powerful 2D capabilities

## License

See main project LICENSE file.
