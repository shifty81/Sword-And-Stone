# Development Guide

## Architecture Overview

### World Generation System
The world generation uses a hierarchical approach:
1. **Continental Noise**: Defines large landmasses
2. **Terrain Noise**: Adds height variation with multiple octaves
3. **River Generation**: Creates flowing water from high to low elevation
4. **Chunk System**: Generates terrain in 16x16x16 chunks on-demand

### Voxel System
- Each chunk contains a 3D array of voxel types
- Mesh generation creates visible faces only for exposed voxels
- Collision shapes are generated from the mesh
- Voxels can be modified at runtime (break/place)

### Crafting System
The crafting system supports multiple station types:
- **Workbench**: Basic tools and items
- **Anvil**: Weapon and armor smithing with voxel shaping
- **Forge**: Smelting ores into ingots
- **Furnace**: Cooking food and materials

#### Quality System
Items have 6 quality levels:
- Poor (0.7x stats)
- Common (1.0x stats)
- Good (1.3x stats)
- Excellent (1.6x stats)
- Masterwork (2.0x stats)
- Legendary (2.5x stats)

Quality is determined by:
- Player skill level
- Crafting accuracy (for smithing)
- Random chance

### Smithing Mechanics
The anvil station allows voxel-based smithing:
1. Place heated metal on anvil (starts as ingot shape)
2. Use hammer to move voxels
3. Shape metal to match recipe template
4. Quality depends on shape accuracy
5. Complete smithing to create item

## Adding New Features

### Adding a New Voxel Type
1. Add enum to `voxel_type.gd`
2. Add color in `get_voxel_color()`
3. Add hardness in `get_hardness()`
4. Update world generation if needed

### Adding a New Item
1. Create resource script extending `Item`, `Weapon`, or `Armor`
2. Set properties (damage, defense, quality, etc.)
3. Create icon texture
4. Add to crafting recipes

### Adding a New Crafting Recipe
1. Create `CraftingRecipe` resource
2. Define required materials
3. Set result item
4. Add to appropriate crafting station

### Creating Custom Shaders
The cel-shader can be customized:
- Adjust `cel_levels` for more/fewer shading steps
- Modify `outline_thickness` for thicker outlines
- Change colors for different art styles

## Performance Optimization

### Chunk Management
- Only generate chunks within render distance
- Unload chunks far from player (future feature)
- Use greedy meshing to reduce vertex count (future feature)

### Mesh Generation
- Combine multiple voxels into single faces
- Only generate meshes when chunks change
- Use collision shapes efficiently

### World Generation
- Cache noise values
- Generate rivers only once at startup
- Use seed-based generation for reproducibility

## Testing

### Manual Testing Checklist
- [ ] Player can move and look around
- [ ] Voxels can be broken and placed
- [ ] World generates continents correctly
- [ ] Rivers flow to ocean
- [ ] No visual glitches in chunk borders
- [ ] FPS remains stable (>30fps target)

### Common Issues
- **Chunks not generating**: Check player position and render distance
- **Missing faces**: Verify neighbor voxel checking in chunk
- **Performance issues**: Reduce render distance or chunk size
- **River artifacts**: Adjust river width and generation parameters

## Future Development

### Planned Features
- **Combat System**: Melee and ranged combat
- **Creature AI**: Hostile and passive mobs
- **Advanced Crafting**: More recipes and stations
- **Multiplayer**: Server-client architecture
- **World Saving**: Persistent world state
- **Biomes**: Temperature and humidity-based biomes
- **Structures**: Procedural dungeons and villages

### Technical Debt
- Implement greedy meshing for better performance
- Add chunk unloading system
- Optimize collision detection
- Add LOD system for distant chunks
- Implement proper save/load system
