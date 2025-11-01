# Testing the Zylann.Voxel Addon Integration

## Quick Verification (No Godot Required)

You can verify the basic setup without opening Godot:

### 1. Check if addon is enabled
```bash
grep -A2 "editor_plugins" project.godot
```
**Expected output:** Should show `enabled=PackedStringArray("res://addons/zylann.voxel/")`

### 2. Check if addon files exist
```bash
ls -R addons/zylann.voxel/
```
**Expected output:** Should show bin/, editor/, LICENSE.md, README.md, etc.

### 3. Check platform binaries
```bash
ls addons/zylann.voxel/bin/
```
**Expected output:** Shows macOS binaries (ready), may need Linux/Windows binaries

### 4. Verify integration scripts
```bash
ls scripts/systems/world_generation/voxel_terrain_generator.gd
ls scripts/utils/validate_voxel_addon.gd
```
**Expected output:** Both files should exist

## Full Testing (Requires Godot 4.4.1+)

### On macOS (Binaries Included)

1. **Open the project** in Godot 4.4.1 or newer
   ```bash
   godot --editor .
   ```

2. **Run the validation scene**
   - In Godot Editor: Open `scenes/test/validate_voxel_addon.tscn`
   - Press F6 or click "Run Current Scene"
   - Check console output for validation results

3. **Expected validation results:**
   ```
   ✅ Plugin enabled in project.godot
   ✅ GDExtension definition file found
   ✅ Platform binaries found for: macos
   ✅ VoxelTerrainGenerator script found
   ✅ Test scene found
   ✅ Voxel classes are available (binaries loaded)
   
   🎉 SUCCESS! The addon is fully configured and ready to use!
   ```

### On Linux (Binaries Need to be Added)

1. **Download Linux binaries first**
   ```bash
   cd addons/zylann.voxel
   ./download_linux_binaries.sh
   cd ../..
   ```

2. **Then follow macOS steps above**

3. **Expected validation results:**
   ```
   ✅ Plugin enabled in project.godot
   ✅ GDExtension definition file found
   ✅ Platform binaries found for: linux
   ✅ VoxelTerrainGenerator script found
   ✅ Test scene found
   ✅ Voxel classes are available (binaries loaded)
   
   🎉 SUCCESS! The addon is fully configured and ready to use!
   ```

### On Windows (Binaries Need to be Added)

1. **Download Windows binaries manually**
   - Go to https://github.com/Zylann/godot_voxel/releases
   - Download the GDExtension package for Godot 4.4.1+
   - Extract `.dll` files to `addons/zylann.voxel/bin/`

2. **Then follow macOS steps above**

## Advanced Testing (Generate Actual Terrain)

Once validation passes, you can test actual terrain generation:

### Setup VoxelTerrain Scene

1. **Open test scene**
   - `scenes/test/voxel_terrain_test.tscn`

2. **Add VoxelTerrain node**
   - Right-click on root node → Add Child Node
   - Search for "VoxelTerrain"
   - Add it to the scene

3. **Create VoxelBlockyLibrary**
   - In FileSystem: Right-click → New Resource
   - Choose "VoxelBlockyLibrary"
   - Save as `resources/voxel_blocky_library.tres`
   - Add voxel types with IDs 0-23 (see docs/QUICKSTART_GODOT_VOXEL.md)

4. **Configure VoxelTerrain node**
   - **Generator**: Drag `scripts/systems/world_generation/voxel_terrain_generator.gd`
   - **Mesher**: Create new VoxelMesherBlocky
   - **Mesher → Library**: Assign `voxel_blocky_library.tres`
   - **View Distance**: 128

5. **Add VoxelViewer**
   - Select Camera3D node
   - Add child node "VoxelViewer"

6. **Run the scene** (F6)
   - Should see procedurally generated terrain
   - Different biomes (green grass, yellow sand, white snow)
   - Varied heights (mountains, valleys)

## Troubleshooting

### "VoxelBuffer class not found"
→ Addon binaries not loaded
- Check if binaries exist for your platform
- Verify Godot version is 4.4.1+
- Try restarting Godot

### "Plugin not found in enabled list"
→ project.godot not updated correctly
- Run: `grep editor_plugins project.godot`
- Should show the addon path

### "Binary file not found"
→ Platform binaries missing
- Check `addons/zylann.voxel/bin/` for your platform's binary
- See `PLATFORM_BINARIES.md` for download instructions

### "Scene errors on load"
→ GDExtension not compatible or wrong Godot version
- Verify Godot version is 4.4.1 or newer
- Check if you have the right GDExtension version

## Manual Verification Checklist

Use this checklist to verify the integration:

- [ ] Addon folder exists at `addons/zylann.voxel/`
- [ ] File exists: `voxel.gdextension`
- [ ] File exists: `PLATFORM_BINARIES.md`
- [ ] File exists: `README.md`
- [ ] File exists: `download_linux_binaries.sh`
- [ ] Plugin enabled in `project.godot` under `[editor_plugins]`
- [ ] Script exists: `scripts/systems/world_generation/voxel_terrain_generator.gd`
- [ ] Script exists: `scripts/utils/validate_voxel_addon.gd`
- [ ] Scene exists: `scenes/test/validate_voxel_addon.tscn`
- [ ] Scene exists: `scenes/test/voxel_terrain_test.tscn`
- [ ] Platform binaries exist (macOS ✅, Linux/Windows ⚠️)

## What Success Looks Like

### Minimal Success (Configuration Complete)
- All files in place ✅
- Addon enabled ✅
- Documentation available ✅
- **Status:** Ready to use (needs platform binaries for non-macOS)

### Full Success (Addon Working)
- All above +
- Platform binaries installed ✅
- Godot 4.4.1+ available ✅
- Validation scene runs and passes ✅
- VoxelBuffer class available ✅
- **Status:** Fully functional

### Complete Success (Terrain Generating)
- All above +
- VoxelBlockyLibrary created ✅
- VoxelTerrain node configured ✅
- Test scene generates terrain ✅
- **Status:** Integration complete and tested

## Current Achievement

Based on the work done:

✅ **Minimal Success** - Achieved  
⚠️ **Full Success** - Platform/environment dependent  
⚠️ **Complete Success** - Requires manual setup by user

The addon is **enabled and ready to use**. Full testing requires:
1. Appropriate platform binaries
2. Godot 4.4.1+
3. Manual scene configuration

All necessary tools and documentation are provided for users to complete the integration on their local machines.
