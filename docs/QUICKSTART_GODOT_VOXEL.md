# Quick Start: Godot Voxel Integration

**Goal:** Get godot_voxel running with your existing biome/terrain generation.

## Step 1: Upgrade Godot (Required)

Current: Godot 4.2  
Required: Godot 4.4.1+ or 4.5

Download from: https://godotengine.org/download

## Step 2: Install godot_voxel GDExtension

```bash
cd /path/to/Sword-And-Stone
curl -L https://github.com/Zylann/godot_voxel/releases/download/v1.5x/GodotVoxelExtension.zip -o godot_voxel.zip
unzip godot_voxel.zip
rm godot_voxel.zip
```

Verify: Check that `addons/voxel/` folder exists in your project.

## Step 3: Enable Plugin

1. Open project in Godot 4.4.1+
2. Go to: Project → Project Settings → Plugins
3. Enable "Voxel Tools"
4. Restart Godot if prompted

## Step 4: Create VoxelBlockyLibrary

1. Create new resource: File → New Resource
2. Choose `VoxelBlockyLibrary`
3. Save as: `resources/voxel_blocky_library.tres`
4. Add 24 voxel types with these IDs:

| ID | Type | Color | Notes |
|----|------|-------|-------|
| 0 | Air | Transparent | Invisible |
| 1 | Grass | Green (0.4, 0.8, 0.3) | Top surface |
| 2 | Dirt | Brown (0.6, 0.4, 0.15) | Underground |
| 3 | Stone | Gray (0.6, 0.6, 0.6) | Deep underground |
| 4 | Bedrock | Dark gray (0.25, 0.25, 0.25) | Unbreakable |
| 5 | Water | Blue (0.3, 0.5, 0.9, 0.7) | Transparent |
| 6 | Sand | Yellow (0.9, 0.8, 0.5) | Desert/beach |
| 7 | Wood | Brown (0.5, 0.35, 0.15) | Trees |
| 8 | Leaves | Green (0.3, 0.7, 0.2, 0.8) | Transparent |
| 9 | Iron Ore | Gray w/ orange | Valuable |
| 10 | Copper Ore | Green-brown | Crafting |
| 11 | Tin Ore | Light gray | Crafting |
| 12 | Coal | Black (0.15, 0.15, 0.15) | Fuel |
| 13 | Clay | Tan (0.7, 0.6, 0.5) | Swamps |
| 14 | Cobblestone | Gray (0.5, 0.5, 0.55) | Building |
| 15 | Wood Planks | Brown (0.6, 0.4, 0.2) | Building |
| 16 | Thatch | Tan (0.8, 0.7, 0.4) | Roofing |
| 17 | Bricks | Red (0.7, 0.4, 0.3) | Building |
| 18 | Stone Bricks | Gray (0.65, 0.65, 0.65) | Building |
| 19 | Gold Ore | Yellow (0.9, 0.8, 0.3) | Rare, deep |
| 20 | Silver Ore | Silver (0.85, 0.85, 0.9) | Rare, deep |
| 21 | Snow | White (0.98, 0.98, 1.0) | Tundra |
| 22 | Ice | Blue (0.75, 0.9, 1.0, 0.8) | Transparent |
| 23 | Gravel | Gray (0.55, 0.55, 0.6) | Shores |

**Quick Setup:**
- For each type: Right-click library → Add Voxel
- Set color, collision, transparency as needed
- Air (0), Water (5), Leaves (8), Ice (22) should be transparent

## Step 5: Setup Test Scene

1. Open: `scenes/test/voxel_terrain_test.tscn`
2. Add node: `VoxelTerrain`
3. Configure VoxelTerrain:
   - **Generator**: Load `res://scripts/systems/world_generation/voxel_terrain_generator.gd`
   - **Mesher**: Create new `VoxelMesherBlocky`
   - **Mesher → Library**: Assign your `voxel_blocky_library.tres`
   - **View Distance**: 128 (or higher for more visible terrain)
4. Add `VoxelViewer` as child of Camera3D node

## Step 6: Test!

1. Run scene (F6 or play button for current scene)
2. Look around with mouse
3. You should see:
   - Terrain generating around camera
   - Different biomes (green grasslands, yellow deserts, white snow)
   - Varied heights (mountains, valleys, flatlands)

## Troubleshooting

### "VoxelTerrain node not found"
→ godot_voxel not installed or plugin not enabled

### "No terrain visible"
→ Check VoxelViewer is under Camera3D and camera is near origin (0, 0, 0)

### "Errors in generator script"
→ Make sure biome_generator.gd and voxel_type.gd are accessible

### "Black/gray terrain everywhere"
→ Library colors not set correctly, review Step 4

### "Performance is bad"
→ Reduce view distance to 64 or 96 for testing

## Next: Compare Performance

After terrain generates successfully:

1. **Benchmark FPS**: Note frame rate in godot_voxel scene
2. **Compare**: Run original main.tscn and note FPS difference
3. **Evaluate**: Is performance better, same, or worse?
4. **Decide**: Based on performance and visual quality:
   - Keep current system (if godot_voxel isn't better)
   - Switch to godot_voxel (if significantly better)
   - Hybrid approach (use godot_voxel but keep current features)

## Full Documentation

- **Complete Guide**: `docs/GODOT_VOXEL_INTEGRATION.md`
- **Implementation Details**: `docs/GODOT_VOXEL_IMPLEMENTATION.md`
- **Final Summary**: `docs/FINAL_INTEGRATION_SUMMARY.md`
- **Godot Voxel Docs**: https://voxel-tools.readthedocs.io/en/latest/

## Success Criteria ✓

If you can see terrain generating with different biomes and colors, **Phase 2 is complete!**

Next: Phase 3 - Add rivers, structures, and trees to VoxelTerrainGenerator.
