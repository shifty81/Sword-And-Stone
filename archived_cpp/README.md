# Archived C++ Code

This directory contains the original C++ implementation of core engine systems. These files have been **converted to GDScript** and integrated into Godot's architecture.

## ⚠️ Important Notice

**This code is archived for reference only and is NOT used in the current project.**

The Sword And Stone project now uses **Godot Engine 4.x** exclusively with GDScript. The functionality from these C++ files has been successfully converted to Godot's native systems.

## Why Archive Instead of Delete?

1. **Historical Reference**: Documents the design process and architectural decisions
2. **Learning Resource**: Shows how native engine features translate to Godot
3. **Design Patterns**: Original class structure informs Godot implementation
4. **Attribution**: Preserves the work that went into the foundation

## Conversion Status

All C++ systems have been converted to Godot equivalents:

| C++ System | Status | Godot Equivalent | Location |
|------------|--------|------------------|----------|
| **Engine.cpp** | ✅ Converted | GameManager | `scripts/autoload/game_manager.gd` |
| **TimeManager.cpp** | ✅ Converted | TimeManager | `scripts/autoload/time_manager.gd` |
| **InputManager.cpp** | ✅ Converted | InputHelper | `scripts/autoload/input_helper.gd` |
| **Window.cpp** | ✅ Not Needed | DisplayServer (built-in) | Native Godot |
| **Renderer System** | ✅ Not Needed | RenderingServer (built-in) | Native Godot |
| **VoxelSystem.cpp** | ✅ Converted | Chunk + VoxelType | `scripts/systems/voxel/` |
| **Player.cpp** | ✅ Converted | PlayerController | `scripts/entities/player/player_controller.gd` |
| **GameWorld.cpp** | ✅ Converted | WorldGenerator | `scripts/systems/world_generation/world_generator.gd` |

## Directory Structure

```
archived_cpp/
├── CMakeLists.txt          # Root CMake configuration
├── src/                    # C++ source implementations
│   ├── engine/            # Core engine systems
│   │   ├── Engine.cpp
│   │   ├── InputManager.cpp
│   │   ├── TimeManager.cpp
│   │   └── Window.cpp
│   ├── game/              # Game-specific systems
│   │   ├── GameWorld.cpp
│   │   ├── Player.cpp
│   │   └── VoxelSystem.cpp
│   ├── platform/          # Platform abstraction
│   │   └── Platform.cpp
│   ├── renderer/          # Multi-API renderer
│   │   ├── DirectX11Renderer.cpp
│   │   ├── DirectX12Renderer.cpp
│   │   ├── OpenGLRenderer.cpp
│   │   └── RendererFactory.cpp
│   └── main.cpp           # Application entry point
├── include/               # C++ header files
│   ├── engine/
│   ├── game/
│   ├── platform/
│   └── renderer/
└── tests/                 # C++ unit tests (CMakeLists.txt)
```

## Key Design Decisions

### Multi-API Renderer
The C++ version supported OpenGL, DirectX 11, and DirectX 12 through an abstraction layer. **Godot replaces this** with its RenderingServer that handles rendering automatically across platforms.

### Manual Game Loop
The C++ `Engine::Run()` method implemented a manual game loop. **Godot replaces this** with its SceneTree system that handles the loop automatically via `_process()` and `_physics_process()`.

### Window Management
The C++ `Window` class handled window creation and events. **Godot replaces this** with DisplayServer and automatic window management.

### Input System
The C++ `InputManager` tracked input state manually. **Godot replaces this** with its Input singleton and InputHelper provides additional utilities.

### Time Management
The C++ `TimeManager` calculated delta time and FPS. **Godot replaces this** with built-in Time and Engine classes, enhanced by TimeManager autoload.

## Conversion Documentation

For detailed information about the conversion process, see:
- **[docs/CONVERSION.md](../docs/CONVERSION.md)** - Complete conversion guide
- **[docs/CPP_RESTRUCTURING.md](../docs/CPP_RESTRUCTURING.md)** - Original C++ restructuring notes

## Building the Archived Code (Not Recommended)

**Note**: Building this code is not necessary and not supported. Use the Godot version instead.

If you're curious about the original C++ implementation:

```bash
# This won't work without dependencies and is not maintained
mkdir build && cd build
cmake ..
cmake --build .
```

**Dependencies Required** (not included):
- Visual Studio 2019+ (Windows)
- CMake 3.15+
- Windows 10 SDK (DirectX)
- GLFW (OpenGL)
- GLAD (OpenGL loader)
- GLM (Math library)

## Why Godot is Better

### Development Speed
- **C++**: Compile → Link → Run (30-60 seconds)
- **Godot**: Edit → Run (instant)

### Code Complexity
- **C++**: ~2500 lines with manual memory management
- **Godot**: ~1500 lines with automatic memory management

### Features
- **C++**: Manual implementation of everything
- **Godot**: Built-in physics, rendering, UI, networking, etc.

### Cross-Platform
- **C++**: Manual platform abstraction required
- **Godot**: Works everywhere by default

### Debugging
- **C++**: External debuggers, complex setup
- **Godot**: Built-in debugger, visual profiler, easy breakpoints

## For Developers

If you're coming from the C++ version or considering using C++:

**❌ Don't:**
- Try to build this C++ code
- Use C++ for Godot game development (unless making GDExtension plugins)
- Port new features back to this C++ code

**✅ Do:**
- Use the Godot/GDScript version
- Reference this code for architectural patterns
- Read CONVERSION.md to understand the migration
- Learn GDScript - it's similar to Python and much easier

## Questions?

**Q: Can I use this C++ code?**
A: It's archived for reference only. Use the Godot version instead.

**Q: Will this C++ code be maintained?**
A: No. All development happens in Godot/GDScript.

**Q: What if I prefer C++?**
A: You can create GDExtension plugins in C++ for performance-critical features, but the main game should use GDScript.

**Q: Is the C++ version faster?**
A: Not significantly. Godot's engine is highly optimized C++ under the hood.

**Q: Can I learn from this code?**
A: Absolutely! It shows good architectural patterns that translate well to Godot.

## Summary

This archived C++ code represents the foundation that informed our Godot implementation. It served its purpose as a learning exercise and architectural prototype. Now, the project thrives as a pure Godot game with all the benefits of a mature game engine.

**Use the Godot version. It's better.** 🎮

---

**Archived**: November 2025  
**Status**: Reference Only  
**Conversion**: Complete ✅  
**Godot Version**: 4.2+
