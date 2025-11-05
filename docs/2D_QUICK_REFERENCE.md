# 2D World Generation - Quick Reference

## Quick Start

```bash
# 1. Open project in Godot 4.2+
# 2. Press F5 to run
# 3. Explore the procedurally generated world!
```

## Terrain Types

| Type | Color | Elevation | Notes |
|------|-------|-----------|-------|
| Deep Water | Dark Blue | < 0.35 | Oceans and deep lakes |
| Shallow Water | Light Blue | 0.35-0.42 | Coastal areas |
| Sand | Yellow-Brown | 0.42-0.48 | Beaches, deserts |
| Grass | Green | 0.48-0.75 | Common terrain |
| Dirt | Brown | 0.48-0.75 | Low moisture areas |
| Stone | Gray | > 0.75 | Mountains, highlands |
| Snow | White | > 0.75 | Cold high-altitude |
| Forest | Dark Green | 0.48-0.75 | High moisture areas |

## Key Files

```
World Generator:     scripts/systems/world_generation/world_generator_2d.gd
Texture Generator:   scripts/utils/tile_texture_generator_2d.gd
Cel Shader:          shaders/cel_shader_2d.gdshader
Main Scene:          scenes/main/crimson_isles_main.tscn
Tileset Atlas:       assets/textures/terrain/tileset_2d.png
```

## Regenerate Textures

```bash
# Python method (recommended)
python3 generate_tileset.py

# Or run autoload (automatic on game start)
# TilesetGenerator autoload handles it
```

## Configuration

```gdscript
# In crimson_isles_main.tscn > WorldGenerator node

# Change world seed
world_seed = 42

# Change world size (chunks × tiles per chunk)
world_size_chunks = 8      # 8×8 = 64 chunks
chunk_size_tiles = 32      # 32×32 = 1024 tiles per chunk
# Total: 256×256 tiles

# Adjust terrain generation
terrain_scale = 0.05       # Higher = more variation
moisture_scale = 0.03      # Controls grass/dirt/forest
temperature_scale = 0.04   # Controls snow/stone
```

## Cel-Shader Setup

```gdscript
# 1. Select TileMap or other CanvasItem
# 2. Inspector > Material > New ShaderMaterial
# 3. Shader > Load > shaders/cel_shader_2d.gdshader
# 4. Adjust parameters:

cel_levels = 3             # 2-8, cartoon shading levels
outline_thickness = 1.0    # 0-5, edge outline width
shadow_intensity = 0.3     # 0-1, shadow darkness
```

## Common Modifications

### Make More Water
```gdscript
# In world_generator_2d.gd, get_terrain_type()
if height < 0.50:  # Changed from 0.35
    return TerrainType.DEEP_WATER
```

### Larger World
```gdscript
# In WorldGenerator node
world_size_chunks = 16  # 512×512 tiles total
```

### Different Colors
```python
# In generate_tileset.py or tile_texture_generator_2d.gd
def generate_grass_tile():
    r = int(100 + noise * 25)  # Adjust RGB values
    g = int(180 + noise * 25)
    b = int(100 + noise * 25)
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Tileset not found | Run `python3 generate_tileset.py` |
| World not generating | Check WorldGenerator and TileMap nodes exist |
| Black tiles | Verify atlas coordinates (0-7) |
| Poor performance | Reduce world_size_chunks or chunk_size_tiles |
| Shader not working | Increase outline_thickness parameter |

## Performance Tips

- **Small worlds**: 4-6 chunks (fast generation)
- **Medium worlds**: 8 chunks (default, balanced)
- **Large worlds**: 16+ chunks (slower generation)
- **Tile count**: chunks² × tiles_per_chunk² = total tiles

## Documentation Links

- **Full Guide**: `docs/2D_WORLD_GENERATION.md`
- **Implementation Summary**: `docs/2D_IMPLEMENTATION_SUMMARY.md`
- **Changelog**: `docs/2D_CHANGELOG.md`
- **Crimson Isles Setup**: `CRIMSON_ISLES_SETUP.md`

## Adding New Terrain Type

```gdscript
# 1. Add to enum (world_generator_2d.gd)
enum TerrainType {
    # ... existing types ...
    MY_NEW_TERRAIN
}

# 2. Add to get_terrain_type()
if some_condition:
    return TerrainType.MY_NEW_TERRAIN

# 3. Create texture generator
static func generate_my_terrain_tile() -> Image:
    # ... generation code ...

# 4. Add to atlas (tile_texture_generator_2d.gd)
var tiles = [
    # ... existing tiles ...
    generate_my_terrain_tile()
]

# 5. Update place_tile() mapping
TerrainType.MY_NEW_TERRAIN:
    atlas_coords = Vector2i(8, 0)  # Next index

# 6. Regenerate textures
python3 generate_tileset.py
```

## Controls

**Movement:**
- W/A/S/D - Move
- Shift - Sprint
- ESC - Exit

## Validation

```bash
# Check implementation completeness
python3 validate_2d_implementation.py
```

## Noise Parameters Explained

```gdscript
# terrain_scale: Controls height variation frequency
# - Higher (0.1): More frequent hills/valleys
# - Lower (0.01): Larger, smoother features

# moisture_scale: Controls wetness variation
# - Affects grass/dirt/forest distribution

# temperature_scale: Controls climate variation
# - Affects snow/stone at high elevations

# All use Perlin noise with 4 octaves
```

## World Size Examples

| Chunks | Tiles | Total Tiles | Gen Time | Memory |
|--------|-------|-------------|----------|--------|
| 4×4 | 32×32 | 16,384 | < 0.1s | ~2 MB |
| 8×8 | 32×32 | 65,536 | < 0.5s | ~8 MB |
| 16×16 | 32×32 | 262,144 | 1-2s | ~32 MB |

## Preview Images

- Vertical: `docs/tileset_preview.png`
- Grid: `docs/tileset_grid_preview.png`

---

**Need more details?** See `docs/2D_WORLD_GENERATION.md` for the complete guide.
