# Build Instructions - Godot Edition

**Sword And Stone** is a **Godot 4.x game project** built entirely with GDScript. This is NOT a C++ project and does NOT require compilation.

## ⚠️ Important Notice

This project uses **Godot Engine 4.x** exclusively. There are no build steps, no compilation, and no CMake required.

**If you see references to C++/CMake**, those are archived in `archived_cpp/` for reference. See [docs/CONVERSION.md](docs/CONVERSION.md) for the full story.

---

## Prerequisites

### Required
- **Godot 4.3 or newer** - Download from [godotengine.org](https://godotengine.org/download)
  - Choose the "Standard" version (not Mono/.NET)
  - Single executable, no installation required

### Optional
- **Git** - For cloning the repository and version control

---

## Quick Start

### Step 1: Install Godot

1. Visit [godotengine.org/download](https://godotengine.org/download)
2. Download **Godot Engine 4.3 or newer** (Standard version)
3. Extract the executable to a convenient location
4. (Optional) Add Godot to your PATH for command-line access

### Step 2: Get the Project

**Option A: Clone with Git**
```bash
git clone https://github.com/shifty81/Sword-And-Stone.git
cd Sword-And-Stone
```

**Option B: Download ZIP**
1. Click "Code" → "Download ZIP" on GitHub
2. Extract to your desired location

### Step 3: Open in Godot

1. Launch Godot
2. Click **"Import"** in the Project Manager
3. Navigate to the project folder
4. Select **`project.godot`**
5. Click **"Import & Edit"**

### Step 4: Run the Game

Press **F5** or click the **Play button ▶️** in the top-right corner.

That's it! No building, no compiling, just run.

---

## Project Structure

```
Sword-And-Stone/
├── project.godot          # Godot project configuration
├── icon.svg              # Project icon
│
├── scripts/              # GDScript source files
│   ├── autoload/        # Singleton scripts (always loaded)
│   │   ├── game_manager.gd     # Core game management
│   │   ├── time_manager.gd     # Performance tracking
│   │   ├── input_helper.gd     # Input utilities
│   │   ├── physics_manager.gd  # Physics configuration
│   │   └── texture_loader.gd   # Texture generation
│   ├── entities/        # Player and entity scripts
│   │   └── player/
│   │       └── player_controller.gd
│   ├── systems/         # Core game systems
│   │   ├── voxel/       # Voxel terrain
│   │   ├── world_generation/  # Procedural world
│   │   ├── crafting/    # Crafting stations
│   │   ├── inventory/   # Items and inventory
│   │   └── physics/     # Physics objects
│   ├── ui/             # UI scripts
│   └── utils/          # Utility scripts
│
├── scenes/              # Godot scene files (.tscn)
│   ├── main/           # Main game scene
│   ├── ui/             # UI scenes
│   ├── test/           # Test scenes
│   └── examples/       # Example scenes
│
├── resources/           # Custom resources
│   ├── items/          # Item definitions
│   ├── recipes/        # Crafting recipes
│   └── materials/      # Material resources
│
├── assets/             # Game assets
│   ├── textures/       # Texture files
│   ├── models/         # 3D models
│   ├── audio/          # Sound effects and music
│   └── ...
│
├── shaders/            # Custom shaders (.gdshader)
│   └── cel_shader.gdshader
│
├── docs/               # Documentation
│   ├── CONVERSION.md   # C++ → Godot conversion guide
│   ├── ARCHITECTURE.md # System architecture
│   └── ...
│
└── archived_cpp/       # Archived C++ code (reference only)
    └── README.md       # Explanation of archived code
```

---

## Development Workflow

### Making Changes

#### Edit Scripts
1. Double-click any `.gd` file in Godot's FileSystem dock
2. Edit in the built-in script editor
3. Changes take effect immediately when you run

#### Edit Scenes
1. Double-click any `.tscn` file
2. Use the visual scene editor
3. Drag-and-drop nodes and components
4. Changes are saved automatically

#### Test Changes
- **F5** - Run the project
- **F6** - Run the current scene
- **Ctrl+F5** - Run without debugger
- **F8** - Step through code

### Debugging

**Built-in Debugger:**
- Set breakpoints by clicking line numbers
- View variables in the debugger panel
- Inspect the scene tree and object properties
- Use the remote scene tree inspector

**Console Debugging:**
```gdscript
print("Debug message:", variable)
print_debug("With stack trace")
push_warning("Warning message")
push_error("Error message")
```

**Performance Profiling:**
- Debug → Profiler
- Monitor function calls and timing
- Identify performance bottlenecks
- View memory usage

### Version Control

**Important Files to Track:**
- All `.gd` scripts
- All `.tscn` scenes
- `project.godot`
- Assets in `assets/`
- Documentation in `docs/`

**Files to Ignore:**
- `.godot/` folder (generated)
- `*.import` files (generated)
- See `.gitignore` for full list

---

## Testing

### Running Tests

Test scenes are located in `scenes/test/`:
- `voxel_terrain_test.tscn` - Test world generation
- `validate_voxel_addon.tscn` - Test voxel addon
- `physics_demo.tscn` - Test physics system

**To run a test:**
1. Open the test scene
2. Press **F6** to run current scene
3. Check console output for results

### Creating Tests

```gdscript
extends Node

func _ready():
    run_tests()
    get_tree().quit()  # Exit after tests

func run_tests():
    test_something()
    test_something_else()
    print("All tests passed!")

func test_something():
    var result = some_function()
    assert(result == expected_value, "Test failed!")
```

---

## Troubleshooting

### Common Issues

#### "Failed to load resource" or "Can't find node"
- **Solution**: Check file paths are correct (use `res://` prefix)
- Verify scene structure matches script expectations
- Ensure nodes are added to groups if referenced by group

#### "Script error" on startup
- **Solution**: Open the script and check the Errors tab
- Common issues:
  - Typos in variable/function names
  - Missing type hints
  - Incorrect indentation
  - Accessing null objects

#### Grey grid instead of terrain textures
- **Solution**: Textures generate on first run
- Wait a few seconds for generation
- Check console for texture generation messages
- See [docs/TEXTURE_FIXES.md](docs/TEXTURE_FIXES.md)

#### Low frame rate / performance issues
- **Solution**: Lower `render_distance` in WorldGenerator
- Reduce chunk generation frequency
- Use Godot's profiler to identify bottlenecks
- See [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md) for optimization tips

#### "Parsing of config failed" error
- **Solution**: Ensure you're using Godot 4.2 or newer
- Check `project.godot` syntax is valid
- Try closing and reopening the project

---

## Exporting the Game

To create a standalone executable:

### Step 1: Install Export Templates
1. **Editor → Manage Export Templates**
2. **Download and Install** (matching your Godot version)
3. Wait for download to complete

### Step 2: Configure Export
1. **Project → Export**
2. **Add...** → Select your platform (Windows, Linux, macOS, etc.)
3. Configure export settings:
   - Application name
   - Icon
   - Version
   - Export features

### Step 3: Export Project
1. Click **Export Project**
2. Choose output location
3. Click **Save**

### Supported Platforms
- ✅ Windows (x86_64, x86_32)
- ✅ Linux (x86_64, x86_32, ARM)
- ✅ macOS (Universal)
- ✅ Android (APK, AAB)
- ✅ Web (HTML5)
- ✅ iOS (via macOS)

---

## Advanced Topics

### Using Godot from Command Line

```bash
# Run the project
godot --path /path/to/Sword-And-Stone

# Run the main scene
godot res://scenes/main/main.tscn

# Run headless (server mode)
godot --headless --path /path/to/project

# Export from command line
godot --export-release "Windows Desktop" output.exe
```

### Custom Addons

The project includes optional addon support:
- **Zylann.Voxel** - Professional voxel engine (optional)
- See [docs/WINDOWS_SETUP.md](docs/WINDOWS_SETUP.md) for setup

### Performance Optimization

1. **Profile First**: Use Godot's profiler to identify bottlenecks
2. **Optimize Hot Paths**: Focus on code called every frame
3. **Use Object Pooling**: Reuse objects instead of creating/destroying
4. **Batch Operations**: Process multiple items together
5. **LOD System**: Reduce detail for distant objects

---

## Documentation

- **[README.md](README.md)** - Project overview and features
- **[docs/QUICKSTART.md](docs/QUICKSTART.md)** - Quick reference guide
- **[docs/DEVELOPMENT.md](docs/DEVELOPMENT.md)** - Development guide
- **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** - System architecture
- **[docs/CONVERSION.md](docs/CONVERSION.md)** - C++ to Godot conversion
- **[archived_cpp/README.md](archived_cpp/README.md)** - About archived C++ code

### External Resources
- [Official Godot Docs](https://docs.godotengine.org/en/stable/)
- [GDScript Style Guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html)
- [Godot Tutorials](https://docs.godotengine.org/en/stable/community/tutorials.html)
- [Godot Q&A](https://ask.godotengine.org/)
- [Godot Discord](https://discord.gg/zH7NUgz)

---

## Why No Building?

**Godot uses interpreted GDScript:**
- Scripts are loaded and executed at runtime
- No compilation step required
- Changes are instant
- Debugging is easier
- Development is faster

**The Engine is Pre-built:**
- Godot itself is compiled C++
- Your game runs inside the engine
- You just write game logic in GDScript
- Export templates handle final packaging

---

## What About the C++ Code?

The project previously had C++ engine code that has been **converted to Godot systems**. See:
- **[docs/CONVERSION.md](docs/CONVERSION.md)** - Full conversion documentation
- **[archived_cpp/README.md](archived_cpp/README.md)** - About the archived code

**TL;DR:** We don't need C++ anymore. Godot does it better.

---

## Summary

✅ **No Build System**: Just open and run  
✅ **No Compilation**: Instant feedback  
✅ **No Dependencies**: Everything included  
✅ **Cross-Platform**: Works everywhere  
✅ **Easy to Learn**: GDScript is simple  
✅ **Professional Tools**: Built-in debugger and profiler  
✅ **Active Community**: Thousands of developers  

**Get started in 3 steps:**
1. Download Godot
2. Import project
3. Press F5

That's it! 🎮

---

**Engine**: Godot 4.2+  
**Language**: GDScript  
**Platform**: Cross-platform (Windows, Linux, macOS, Mobile, Web)  
**Build Time**: 0 seconds ⚡
