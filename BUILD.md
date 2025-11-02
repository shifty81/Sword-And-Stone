# Build Instructions

## Important: This is a Godot Project, Not a C++ Project

**Sword And Stone** is a Godot game project written in GDScript. It does **NOT** use CMake, Make, or any traditional C++ build system.

## ❌ Common Mistake

If you're seeing errors like:
```
CMake Error: No CMAKE_CXX_COMPILER could be found
```

This means you're trying to build the project with CMake, which is incorrect for Godot projects.

## ✅ How to Run This Project

### Requirements
- **Godot 4.2 or newer** (Download from https://godotengine.org/download)
- No compilers, no build tools, no CMake needed!

### Steps

1. **Download/Install Godot Engine 4.2+**
   - Visit https://godotengine.org/download
   - Download the Standard version (not .NET/Mono)
   - Extract and run the Godot executable

2. **Open the Project**
   - Launch Godot
   - Click "Import"
   - Navigate to this project directory
   - Select the `project.godot` file
   - Click "Import & Edit"

3. **Run the Game**
   - Press **F5** or click the **Play** button in the top-right
   - The game will start immediately (no build step required!)

### Controls
- **W/A/S/D**: Move
- **Space**: Jump
- **Shift**: Sprint
- **Mouse**: Look around
- **Left Click**: Break voxel
- **Right Click**: Place voxel
- **E**: Toggle inventory
- **ESC**: Toggle mouse cursor

## Optional: Zylann.Voxel Addon (Advanced)

If you want to use the optional high-performance voxel addon:

**Windows Users:**
```powershell
cd addons/zylann.voxel
./download_windows_binaries.ps1
```

**Note:** Forward slashes work in PowerShell too!

See [docs/WINDOWS_SETUP.md](docs/WINDOWS_SETUP.md) for detailed instructions.

## Development

### Editing Code
- All game logic is in GDScript (`.gd` files)
- Edit files in the `scripts/` directory
- No compilation needed - changes apply immediately

### Adding Features
- Create new `.gd` script files
- Attach scripts to scenes in the Godot editor
- Refer to [ARCHITECTURE.md](docs/ARCHITECTURE.md) for project structure

## Troubleshooting

### "No executable found"
- Make sure you have Godot 4.2 or newer installed
- This project requires Godot 4.x, not Godot 3.x

### "Parsing of config failed"
- This error is fixed in the current version
- Make sure you have the latest code from the repository

### Performance Issues
- Reduce render distance in world generation settings
- Consider using the Zylann.Voxel addon for better performance

## For C++ Developers

If you're familiar with C++ and CMake but new to Godot:
- **Godot uses GDScript**, a Python-like language
- **No compilation** - scripts are interpreted at runtime
- **Hot reloading** - changes apply immediately
- **Built-in editor** - use Godot's editor, not external IDEs

To learn more about Godot development:
- Official docs: https://docs.godotengine.org/
- GDScript basics: https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html

## Summary

- ❌ Don't use: `cmake`, `make`, `gcc`, `cl.exe`, Visual Studio
- ✅ Do use: Godot Engine Editor
- ❌ Don't build: This project doesn't need building
- ✅ Do open: Open `project.godot` in Godot Engine
