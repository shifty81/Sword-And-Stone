# 2D World Generation for Crimson Isles

## Overview

The Crimson Isles now features procedural 2D world generation with varied terrain types and optional cel-shading effects.

## Features

### Procedural Terrain Generation
- **8 Terrain Types**: Deep water, shallow water, sand, grass, dirt, stone, snow, and forest
- **Noise-Based Generation**: Uses FastNoiseLite with multiple noise layers for:
  - Height variation (terrain elevation)
  - Moisture levels (biome variation)
  - Temperature gradients (snow vs. stone at high elevations)
- **Tilemap-Based**: Efficient rendering using Godot's TileMap system

### Terrain Types

1. **Deep Water** - Dark blue water in low-elevation areas
2. **Shallow Water** - Lighter blue water near coastlines
3. **Sand** - Beaches and desert areas between water and land
4. **Grass** - Common vegetation in mid-elevation temperate zones
5. **Dirt** - Dry areas with low moisture
6. **Stone** - Rocky terrain at high elevations
7. **Snow** - Cold, high-altitude peaks
8. **Forest** - Dense vegetation in high-moisture areas

### Cel-Shading Support

A 2D cel-shader is available (`shaders/cel_shader_2d.gdshader`) that provides:
- Cartoon-style quantized lighting
- Edge detection for outlines
- Configurable shadow intensity
- Pseudo-lighting based on 2D light direction

## Files Created

### Core Systems
- `scripts/systems/world_generation/world_generator_2d.gd` - Main world generator
- `scripts/utils/tile_texture_generator_2d.gd` - Procedural texture generation
- `scripts/autoload/tileset_generator.gd` - Autoload for texture generation on startup
- `scripts/scenes/crimson_isles_main.gd` - Scene initialization script

### Shaders
- `shaders/cel_shader_2d.gdshader` - 2D cel-shading shader for canvas items

### Utilities
- `generate_tileset.py` - Python script to generate tileset texture
- `generate_tileset_standalone.gd` - Godot standalone script alternative
- `scripts/utils/generate_tileset_tool.gd` - Editor script for generation

### Assets
- `assets/textures/terrain/tileset_2d.png` - Generated tileset atlas (256x32 pixels)

## Configuration

### World Generator Settings

In the scene (`crimson_isles_main.tscn`), the WorldGenerator2D node has these export variables:

```gdscript
@export var world_seed: int = 42              # Random seed for generation
@export var world_size_chunks: int = 8        # 8x8 chunks
@export var chunk_size_tiles: int = 32        # 32x32 tiles per chunk

@export var terrain_scale: float = 0.05       # Terrain noise frequency
@export var moisture_scale: float = 0.03      # Moisture noise frequency
@export var temperature_scale: float = 0.04   # Temperature noise frequency
```

### Cel-Shader Parameters

When applied to a CanvasItem, the cel-shader accepts:

```gdshader
uniform vec4 tint_color                       // Color tint overlay
uniform int cel_levels = 3                    // Number of shading levels (2-8)
uniform float outline_thickness = 1.0         // Edge outline width (0-5)
uniform vec4 outline_color = black            // Outline color
uniform float shadow_intensity = 0.3          // Shadow strength (0-1)
uniform vec2 light_direction = vec2(0.5, -0.5) // Light direction in 2D
```

## Usage

### Running the Game

1. Open the project in Godot 4.2+
2. The main scene is set to `scenes/main/crimson_isles_main.tscn`
3. Press F5 to run
4. World generates automatically on startup

### Regenerating Textures

**Option 1: Python Script** (Recommended)
```bash
python3 generate_tileset.py
```

**Option 2: Godot Editor Script**
- Open `scripts/utils/generate_tileset_tool.gd`
- File menu > Run (or Ctrl+Shift+X)

**Option 3: Autoload on Startup**
The `TilesetGenerator` autoload regenerates textures automatically when the game starts.

### Applying Cel-Shading

To apply cel-shading to the TileMap or any 2D element:

1. Select the node in the scene tree
2. In Inspector > CanvasItem > Material > New ShaderMaterial
3. Click the ShaderMaterial > Shader > Load > Select `cel_shader_2d.gdshader`
4. Adjust shader parameters as desired

## Customization

### Changing World Size

Edit `world_size_chunks` and `chunk_size_tiles` in the WorldGenerator2D node:
- Total tiles = `world_size_chunks * chunk_size_tiles`
- Default: 8 chunks × 32 tiles = 256 tiles per side

### Modifying Terrain Distribution

Edit the `get_terrain_type()` function in `world_generator_2d.gd`:

```gdscript
# Example: Make more water
if height < 0.50:  # Changed from 0.35
    return TerrainType.DEEP_WATER
```

### Adding New Terrain Types

1. Add to the `TerrainType` enum in `world_generator_2d.gd`
2. Create a new texture generator function in `tile_texture_generator_2d.gd`
3. Add to the tiles array in `generate_tileset_atlas()`
4. Update `place_tile()` to map the new type to atlas coordinates
5. Regenerate the tileset

### Creating Custom Tile Textures

Modify functions in `tile_texture_generator_2d.gd` or `generate_tileset.py`:

```python
def generate_custom_tile():
    img = Image.new('RGB', (TILE_SIZE, TILE_SIZE))
    pixels = img.load()
    
    for y in range(TILE_SIZE):
        for x in range(TILE_SIZE):
            # Your custom generation logic
            pixels[x, y] = (r, g, b)
    
    return img
```

## Performance Considerations

- **World Size**: Larger worlds (more chunks) take longer to generate
  - 8×8 chunks (256×256 tiles) = ~65k tiles ≈ instant
  - 16×16 chunks (512×512 tiles) = ~262k tiles ≈ 1-2 seconds
  
- **Tile Size**: The default 32×32 pixel tiles balance detail and performance
  - Smaller tiles (16×16) = faster rendering, less detail
  - Larger tiles (64×64) = more detail, slower rendering

- **Noise Quality**: More octaves = better detail but slower generation
  - Current: 4 octaves (good balance)
  - Increase for more detail: 6-8 octaves
  - Decrease for speed: 2-3 octaves

## Technical Details

### Noise-Based Terrain Generation

The system uses three FastNoiseLite instances:

1. **Terrain Noise**: Determines elevation
   - Type: Perlin
   - Frequency: 0.05
   - Octaves: 4
   - Controls water vs. land distribution

2. **Moisture Noise**: Affects biomes
   - Type: Perlin
   - Frequency: 0.03
   - Differentiates grass/dirt/forest

3. **Temperature Noise**: Affects climate
   - Type: Perlin
   - Frequency: 0.04
   - Determines snow vs. stone at high elevation

### TileMap Structure

- **Format**: TileSet with single atlas source
- **Atlas Layout**: Horizontal strip of 8 tiles (256×32 pixels)
- **Tile Coordinates**: Vector2i(tile_index, 0)
- **Layer**: Single terrain layer (layer 0)

### Cel-Shader Implementation

The 2D cel-shader uses:
- **Quantization**: Divides lighting into discrete levels
- **Edge Detection**: Samples neighboring pixels for alpha differences
- **Pseudo-Lighting**: Uses UV position and light direction for shading
- **Outline**: Darkens edges where alpha transitions occur

## Troubleshooting

### Tileset Not Loading

1. Check if `tileset_2d.png` exists in `assets/textures/terrain/`
2. Run `python3 generate_tileset.py` to regenerate
3. Verify the `.import` file exists alongside the PNG
4. Reimport assets in Godot (Project > Reimport Assets)

### World Not Generating

1. Check console for errors
2. Verify `WorldGenerator` and `TileMap` nodes exist in scene
3. Ensure script is attached to scene root
4. Check that `set_tile_map()` is being called

### Performance Issues

1. Reduce `world_size_chunks` (try 4 or 6 instead of 8)
2. Reduce `chunk_size_tiles` (try 16 instead of 32)
3. Disable cel-shader if applied
4. Close unnecessary background applications

### Cel-Shader Not Working

1. Verify shader is applied to CanvasItem material
2. Check that outline_thickness > 0 for visible outlines
3. Try increasing cel_levels for more pronounced effect
4. Ensure the texture has alpha channel for edge detection

## Future Enhancements

Potential improvements for the 2D world generation:

- [ ] Dynamic chunk loading/unloading (infinite world)
- [ ] Biome transitions and blending
- [ ] Decorative objects (trees, rocks, flowers)
- [ ] Rivers and lakes as separate features
- [ ] Pathfinding-friendly terrain generation
- [ ] Save/load world state
- [ ] Minimap with fog of war
- [ ] Day/night lighting integration
- [ ] Weather effects (rain, snow overlay)
- [ ] Animated water tiles

## See Also

- Original 3D world generation: `scripts/systems/world_generation/world_generator.gd`
- 3D cel-shader: `shaders/cel_shader.gdshader`
- Texture generation for 3D: `scripts/utils/texture_generator.gd`
- Crimson Isles setup guide: `CRIMSON_ISLES_SETUP.md`
