# Zylann.Voxel Platform Binaries Status

## Current Status

This addon folder has been populated with the Zylann.Voxel GDExtension addon structure.

### Available Binaries

Currently included binaries:
- ✅ **macOS** (editor and release)
  - `bin/libvoxel.macos.editor.universal.framework/`
  - `bin/libvoxel.macos.template_release.universal.framework/`

### Missing Binaries

To use this addon on other platforms, the following binaries need to be downloaded from the [Zylann/godot_voxel releases](https://github.com/Zylann/godot_voxel/releases):

- ❌ **Linux** x86_64
  - `bin/libvoxel.linux.editor.x86_64.so`
  - `bin/libvoxel.linux.template_release.x86_64.so`

- ❌ **Windows** x86_64
  - `bin/libvoxel.windows.editor.x86_64.dll`
  - `bin/libvoxel.windows.template_release.x86_64.dll`

- ❌ **iOS**
  - `bin/libvoxel.ios.editor.arm64.dylib`
  - `bin/libvoxel.ios.template_release.arm64.dylib`

- ❌ **Android**
  - `bin/libvoxel.android.editor.x86_64.so`
  - `bin/libvoxel.android.template_release.x86_64.so`
  - `bin/libvoxel.android.editor.arm64.so`
  - `bin/libvoxel.android.template_release.arm64.so`

## Requirements

- **Godot Version**: 4.4.1 or newer (as specified in voxel.gdextension)
- **GDExtension Version**: Compatible with Godot 4.4.1+

## How to Add Missing Binaries

### Windows (Automated)

1. Open PowerShell as Administrator (recommended) or regular user
2. Navigate to the addon directory:
   ```powershell
   cd path\to\Sword-And-Stone\addons\zylann.voxel
   ```
3. Run the download script:
   ```powershell
   .\download_windows_binaries.ps1
   ```
4. Restart Godot if it was open

### Linux (Automated)

1. Open terminal
2. Navigate to the addon directory:
   ```bash
   cd path/to/Sword-And-Stone/addons/zylann.voxel
   ```
3. Run the download script:
   ```bash
   ./download_linux_binaries.sh
   ```
4. Restart Godot if it was open

### Manual Download (All Platforms)

1. Go to https://github.com/Zylann/godot_voxel/releases
2. Download the appropriate GDExtension release for Godot 4.4.1+
3. Extract the downloaded archive
4. Copy the required `.so`, `.dll`, or `.dylib` files to the `bin/` directory
5. Make sure the file names match those specified in `voxel.gdextension`

## Addon Configuration

The addon is a **GDExtension** and loads automatically through its `voxel.gdextension` file.

⚠️ **Important**: This addon should NOT be enabled in the `[editor_plugins]` section of `project.godot`. GDExtensions are loaded automatically and don't require plugin configuration.

## Testing

On **macOS**, the addon should work immediately when opening the project in Godot 4.4.1+.

For **Linux/Windows/other platforms**, you'll need to add the platform-specific binaries first.

## Integration Status

The project includes:
- ✅ VoxelTerrainGenerator script that extends VoxelGeneratorScript
- ✅ Test scene at `scenes/test/voxel_terrain_test.tscn`
- ✅ Documentation in `docs/GODOT_VOXEL_INTEGRATION.md`
- ✅ Quick start guide in `docs/QUICKSTART_GODOT_VOXEL.md`

See the documentation files for detailed setup instructions.
