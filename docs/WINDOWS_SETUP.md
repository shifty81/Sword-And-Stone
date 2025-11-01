# Windows Setup Guide for Zylann.Voxel Integration

This guide will help you set up the Zylann.Voxel addon on Windows and integrate it with the existing world generation, meshes, textures, and cel shading.

## Prerequisites

- **Godot 4.4.1 or newer** - Download from https://godotengine.org/download
- **Windows 10/11** with PowerShell
- **Internet connection** for downloading binaries

## Step 1: Fix Project Configuration (Already Done!)

The addon configuration has been fixed. The `project.godot` no longer incorrectly lists the addon as an editor plugin. GDExtensions load automatically.

## Step 2: Download Windows Binaries

### Option A: Automated (Recommended)

1. Open PowerShell (no need for Administrator rights)
2. Navigate to the addon directory:
   ```powershell
   cd C:\path\to\Sword-And-Stone\addons\zylann.voxel
   ```
3. Run the download script:
   ```powershell
   .\download_windows_binaries.ps1
   ```
4. Wait for the download and installation to complete

### Option B: Manual Download

1. Visit https://github.com/Zylann/godot_voxel/releases
2. Download the Windows x86_64 GDExtension package for Godot 4.4.1+
3. Extract the ZIP file
4. Copy these files to `addons/zylann.voxel/bin/`:
   - `libvoxel.windows.editor.x86_64.dll`
   - `libvoxel.windows.template_release.x86_64.dll`

## Step 3: Open Project in Godot

1. Open Godot 4.4.1 (or newer)
2. Import or open the Sword And Stone project
3. Wait for the project to load

### Expected Behavior

✅ **Success**: No errors, addon loads silently in the background
❌ **Error**: "Unable to load addon" or "parsing of config failed"

If you see an error:
- Verify you're using Godot 4.4.1 or newer
- Check that the `.dll` files are in `addons/zylann.voxel/bin/`
- Ensure the file names match exactly what's in `voxel.gdextension`

## Step 4: Verify Integration

The project includes a validation script:

1. In Godot, open `scenes/test/validate_voxel_addon.tscn`
2. Click the "Run Current Scene" button (F6)
3. Check the console output

Expected output:
```
✅ Addon structure is valid
✅ GDExtension file found
✅ Windows binaries present
✅ VoxelBuffer class available
✅ VoxelTerrain class available
```

## Step 5: Test World Generation

Now test the integration with existing world generation:

1. Open `scenes/test/voxel_terrain_test.tscn`
2. The scene should have instructions for setup
3. Follow the on-screen instructions to:
   - Add a VoxelTerrain node
   - Configure it with VoxelBlockyLibrary
   - Assign the VoxelTerrainGenerator script
4. Run the scene (F6)

### What You Should See

A procedurally generated world with:
- ✅ Terrain with biomes (plains, forests, mountains, deserts, tundra, swamps)
- ✅ Rivers flowing to the ocean
- ✅ Trees in forests and plains
- ✅ Ore veins underground (coal, iron, copper, tin, gold, silver)
- ✅ Cel-shaded graphics with thick outlines
- ✅ 24 different voxel types

## Integration with Existing Assets

### Meshes and Textures

The Zylann.Voxel addon uses `VoxelBlockyLibrary` to define voxel appearances. To integrate with your existing assets:

#### Using Existing Colors (Simplest)

The project already has colors defined in `scripts/systems/voxel/voxel_type.gd`:

```gdscript
# The VoxelTerrainGenerator automatically uses these colors
# No additional setup needed!
```

#### Using Custom Textures (Advanced)

To use actual texture files from `assets/textures/`:

1. Create a `VoxelBlockyLibrary` resource
2. For each voxel type (0-23), add a `VoxelBlockyModel`:
   - Set the ID to match VoxelType enum values
   - In the model's geometry settings, add cube collision
   - For textures:
     - Option 1: Use `color` property with existing color from VoxelType
     - Option 2: Assign texture atlas with UV coordinates
     - Option 3: Use individual textures per face

3. Assign the library to VoxelTerrain's `voxel_library` property

### Cel Shading Integration

The project's cel shader (`shaders/cel_shader.gdshader`) works with voxel meshes!

#### Applying Cel Shader to Voxels

1. Create a `StandardMaterial3D` resource
2. In the material's Shader parameter, assign `res://shaders/cel_shader.gdshader`
3. Configure shader parameters:
   - `albedo`: Base color (use white to preserve voxel colors)
   - `cel_levels`: 4 (default, adjust for more/less shading steps)
   - `outline_thickness`: 0.01 (adjust for thicker/thinner outlines)
   - `outline_color`: Black
4. In VoxelTerrain, set the `material_override` to this material

**Result**: Voxel terrain with Borderlands-style cel shading and thick outlines!

### Custom Meshes (Future Enhancement)

For custom 3D models from `assets/models/`:

Use `VoxelInstanceLibrary` and `VoxelInstancer` to place custom meshes in the world:
- Trees, rocks, grass, flowers
- Buildings and structures
- Props and decorations

## Troubleshooting

### "Class VoxelBuffer not found"

- ✅ Ensure `.dll` files are in `addons/zylann.voxel/bin/`
- ✅ Restart Godot
- ✅ Check Godot version (must be 4.4.1+)

### "Parsing of config failed"

This error should now be fixed! If you still see it:
- Verify `project.godot` has no `[editor_plugins]` section with zylann.voxel
- The addon loads via GDExtension, not as a plugin

### Slow Performance

- Reduce VoxelTerrain's view distance
- Enable LOD if using VoxelLodTerrain
- Check that chunk generation is asynchronous

### Black/Pink Voxels

- Ensure VoxelBlockyLibrary is configured with all 24 voxel types
- Check that IDs match the constants in VoxelTerrainGenerator
- Verify colors are set in the library

## Next Steps

1. ✅ Binaries installed and working
2. ✅ Addon loads without errors
3. ✅ Test scene generates terrain
4. 🎨 Customize voxel appearances with textures
5. 🎨 Apply cel shader to terrain material
6. 🌳 Add custom meshes with VoxelInstancer
7. 🎮 Integrate with player controller
8. 🔨 Add voxel breaking/placing mechanics

## Performance Tips

- **View Distance**: Start with 64-128 blocks, adjust based on FPS
- **LOD**: Use VoxelLodTerrain for larger worlds
- **Chunk Size**: Default 16x16x16 is optimal for blocky terrain
- **Async Generation**: Ensure generator runs on separate thread
- **Mesh Optimization**: Enable greedy meshing in VoxelMesherBlocky

## Resources

- **Zylann Voxel Docs**: https://voxel-tools.readthedocs.io/
- **Project Integration Guide**: `docs/GODOT_VOXEL_INTEGRATION.md`
- **Quick Start**: `docs/QUICKSTART_GODOT_VOXEL.md`
- **GitHub Issues**: https://github.com/Zylann/godot_voxel/issues

## Summary

You now have:
- ✅ Fixed addon configuration (no more parsing errors)
- ✅ Windows binaries ready to download
- ✅ Integration with existing world generation
- ✅ Support for custom textures and meshes
- ✅ Cel shader compatibility
- ✅ Professional voxel engine performance

Enjoy your procedurally generated medieval voxel world! 🏰⚔️
