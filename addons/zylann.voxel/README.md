# Zylann.Voxel GDExtension Addon

This is the [Zylann Voxel Tools](https://github.com/Zylann/godot_voxel) GDExtension addon for Godot 4.4.1+.

## About

Zylann Voxel Tools is a professional-grade voxel engine for Godot that provides:
- High-performance blocky and smooth voxel terrain
- Level of Detail (LOD) system for large worlds
- Efficient chunk streaming and management
- Built-in terrain editing tools
- Support for procedural generation

All credits for this system go to the [Zylann.Voxel Creator](https://github.com/Zylann/godot_voxel).

## Status

✅ **Addon Enabled** - The addon is configured in project.godot  
⚠️ **Platform Binaries** - Currently only macOS binaries are included

## Requirements

- **Godot Version**: 4.4.1 or newer
- **Platform Binaries**: See PLATFORM_BINARIES.md for details

## Current Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| macOS (Universal) | ✅ Ready | Editor and release binaries included |
| Linux x86_64 | ⚠️ Needs binaries | Run `./download_linux_binaries.sh` |
| Windows x86_64 | ⚠️ Needs binaries | Download from releases |
| iOS | ⚠️ Needs binaries | Download from releases |
| Android | ⚠️ Needs binaries | Download from releases |

## Quick Setup for Linux

If you're on Linux and want to use this addon:

1. Run the provided script:
   ```bash
   cd addons/zylann.voxel
   ./download_linux_binaries.sh
   ```

2. Restart Godot

Or manually download from: https://github.com/Zylann/godot_voxel/releases

See `PLATFORM_BINARIES.md` for detailed instructions.

## Integration in This Project

This project integrates the Zylann Voxel addon with custom world generation:

- **Generator Script**: `scripts/systems/world_generation/voxel_terrain_generator.gd`
  - Extends `VoxelGeneratorScript`
  - Uses existing biome, terrain, and ore generation algorithms
  - Compatible with the project's custom voxel types

- **Test Scene**: `scenes/test/voxel_terrain_test.tscn`
  - Set up to demonstrate the addon integration
  - Includes instructions for configuration

- **Documentation**:
  - `docs/GODOT_VOXEL_INTEGRATION.md` - Comprehensive integration guide
  - `docs/QUICKSTART_GODOT_VOXEL.md` - Quick start instructions
  - `docs/GODOT_VOXEL_IMPLEMENTATION.md` - Implementation details

## Testing

On **macOS**:
1. Open project in Godot 4.4.1+
2. Open `scenes/test/voxel_terrain_test.tscn`
3. Follow the instructions in the scene

On **Linux/Windows**:
1. Add platform-specific binaries (see above)
2. Open project in Godot 4.4.1+
3. Open `scenes/test/voxel_terrain_test.tscn`
4. Follow the instructions in the scene

## License

Zylann Voxel Tools is licensed under the MIT License. See LICENSE.md for details.

## Resources

- **GitHub**: https://github.com/Zylann/godot_voxel
- **Documentation**: https://voxel-tools.readthedocs.io/
- **Releases**: https://github.com/Zylann/godot_voxel/releases
