# Godot Voxel Module Integration Guide

This document outlines how to integrate Zylann's godot_voxel module into Sword And Stone.

## Current Status

The project currently uses Godot 4.2 with a custom voxel implementation. To use the professional-grade godot_voxel module by Zylann, you have two options:

### Option 1: GDExtension Version (Recommended for Testing)

**Best for:** Quick testing without changing Godot version  
**Requirements:** Godot 4.4.1+ or 4.5+  
**Installation:**

1. **Upgrade Godot** (if needed):
   - Download Godot 4.4.1+ or 4.5 from https://godotengine.org/download
   - The project is compatible with newer Godot 4.x versions

2. **Download GDExtension**:
   ```bash
   cd /path/to/Sword-And-Stone
   curl -L https://github.com/Zylann/godot_voxel/releases/download/v1.5x/GodotVoxelExtension.zip -o GodotVoxelExtension.zip
   unzip GodotVoxelExtension.zip
   rm GodotVoxelExtension.zip
   ```

3. **Verify Installation**:
   - Open project in Godot
   - Check that `addons/voxel/` folder exists
   - Go to Project → Project Settings → Plugins
   - Enable "Voxel Tools" if not already enabled

### Option 2: Custom Godot Build with Module (Advanced)

**Best for:** Maximum performance  
**Requirements:** Building Godot from source  
**Installation:**

1. Download custom Godot build with voxel module from:
   https://github.com/Zylann/godot_voxel/releases/tag/v1.2.0
   
2. Use the custom editor build instead of vanilla Godot

3. This provides better performance but requires using a custom Godot build

## Testing the Integration

### Step 1: Create a Test Scene

Create `scenes/test/voxel_test.tscn` to test godot_voxel in isolation:

1. Create new 3D scene
2. Add nodes:
   - `VoxelTerrain` (for blocky voxel terrain like Minecraft)
   - OR `VoxelLodTerrain` (for smooth terrain with LOD)
   - `Camera3D` with `VoxelViewer` child node
   - `DirectionalLight3D`
   - `WorldEnvironment`

### Step 2: Configure VoxelTerrain

For VoxelTerrain node:
1. Create a `VoxelMesherBlocky` in the Mesher property
2. Create a `VoxelBlockyLibrary`:
   - Add voxel types matching the constants in `voxel_terrain_generator.gd`:
     - ID 0: Air (transparent)
     - ID 1: Grass (green)
     - ID 2: Dirt (brown)
     - ID 3: Stone (gray)
     - ID 4: Bedrock (dark gray)
     - ID 5: Water (blue, transparent)
     - ID 6: Sand (yellow)
     - ID 7: Wood (brown)
     - ID 8: Leaves (green, transparent)
     - ID 9: Iron Ore (gray with orange spots)
     - ID 10: Copper Ore (green-brown)
     - ID 11: Tin Ore (light gray)
     - ID 12: Coal (black)
     - ID 13-23: Additional types (see VoxelType enum)
   - Define colors and properties for each type
   - Set collision and transparency flags appropriately
3. Create a `VoxelGeneratorScript`:
   - Assign the `voxel_terrain_generator.gd` script
   - This will use custom biome/terrain/ore generation

### Step 3: Add VoxelViewer

The VoxelViewer determines which chunks load around the camera:
1. Add VoxelViewer as child of Camera3D
2. Set view distance (default 128 is good for testing)

### Step 4: Create Custom Generator (Optional)

To use existing biome/river/ore generation logic:

**File:** `scripts/systems/world_generation/voxel_terrain_generator.gd`

```gdscript
extends VoxelGeneratorScript
class_name VoxelTerrainGenerator

# Reference to existing WorldGenerator for biome logic
var world_generator: WorldGenerator

func _init():
    # Initialize with same seed
    world_generator = WorldGenerator.new()
    world_generator.world_seed = 12345
    world_generator.initialize_noise()

func _generate_block(out_buffer: VoxelBuffer, origin: Vector3i, lod: int) -> void:
    var block_size = out_buffer.get_size()
    
    for x in range(block_size.x):
        for z in range(block_size.z):
            for y in range(block_size.y):
                var world_x = origin.x + x
                var world_y = origin.y + y
                var world_z = origin.z + z
                
                # Use existing voxel type logic
                var voxel_type = world_generator.get_voxel_type(world_x, world_y, world_z)
                
                # Map to godot_voxel IDs
                var voxel_id = map_voxel_type_to_id(voxel_type)
                out_buffer.set_voxel(voxel_id, x, y, z, 0)  # Channel 0 is TYPE

func map_voxel_type_to_id(type: VoxelType.Type) -> int:
    # Map our voxel types to godot_voxel block IDs
    match type:
        VoxelType.Type.AIR:
            return 0
        VoxelType.Type.GRASS:
            return 1
        VoxelType.Type.DIRT:
            return 2
        VoxelType.Type.STONE:
            return 3
        # Add more mappings...
        _:
            return 0
```

## Comparing Systems

### Current Custom System
**Pros:**
- ✅ Already implemented and working
- ✅ Full control over implementation
- ✅ Custom features (continents, rivers, biomes, ores)
- ✅ Cel-shaded visual style

**Cons:**
- ❌ Limited performance optimizations
- ❌ No LOD system
- ❌ No smooth voxel option
- ❌ Manual chunk management

### Godot Voxel Module
**Pros:**
- ✅ Professional-grade performance
- ✅ LOD (Level of Detail) system
- ✅ Efficient chunk streaming
- ✅ Smooth voxel terrain option
- ✅ Built-in editing tools
- ✅ Active development and community

**Cons:**
- ⚠️ Requires Godot 4.4+ for GDExtension
- ⚠️ Need to migrate custom features
- ⚠️ May need shader adjustments for cel-shading
- ⚠️ Learning curve for new API

## Hybrid Approach (Recommended)

Instead of replacing everything, enhance the current system:

### Phase 1: Test Basic Terrain Generation
1. Install godot_voxel GDExtension
2. Create test scene with VoxelTerrain
3. Use simple noise generator
4. Verify it creates a spawnable world ✓
5. Test performance compared to current system

### Phase 2: Migrate Generation Logic (If Phase 1 is Successful)
1. Create VoxelGeneratorScript
2. Integrate biome generation
3. Add river generation
4. Add ore generation
5. Add tree placement

### Phase 3: Keep Best of Both
1. Use VoxelTerrain for chunk management
2. Use existing biome/river/ore algorithms
3. Maintain cel-shaded aesthetic with custom shaders
4. Keep game-specific features (crafting, etc.)

## Performance Benchmarks

Test and compare:
```gdscript
# In a test script
var start_time = Time.get_ticks_msec()
# Generate chunks or terrain
var end_time = Time.get_ticks_msec()
print("Generation took: %d ms" % (end_time - start_time))
```

## Next Steps

1. **Upgrade to Godot 4.4.1+** (if using GDExtension)
2. **Install godot_voxel GDExtension**
3. **Create test scene** with VoxelTerrain
4. **Test basic world generation**
5. **Compare performance** with current system
6. **Decide:** Keep current, switch entirely, or hybrid approach

## References

- [Godot Voxel Documentation](https://voxel-tools.readthedocs.io/en/latest/)
- [Quick Start Guide](https://voxel-tools.readthedocs.io/en/latest/quick_start/)
- [GitHub Repository](https://github.com/Zylann/godot_voxel)
- [Releases](https://github.com/Zylann/godot_voxel/releases)

## Conclusion

The godot_voxel module is a powerful alternative to the custom system. The recommended path is:

1. **Test first** with a simple scene to verify it works
2. **Measure performance** compared to current system
3. **Gradually migrate** features if it proves superior
4. **Keep current system** as fallback during transition

The current custom system is solid and works well. Godot voxel is a tool to potentially enhance it, not a required replacement.
