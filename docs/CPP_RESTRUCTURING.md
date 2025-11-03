# Native C++ Restructuring Guide

## Overview

Sword And Stone has been restructured from a Godot Engine project (GDScript) to a native C++ Windows application with support for multiple rendering APIs.

## Key Changes

### From Godot to Native C++

| Aspect | Before (Godot) | After (Native C++) |
|--------|----------------|-------------------|
| **Language** | GDScript | C++17 |
| **Engine** | Godot 4.x | Custom engine |
| **Rendering** | Godot renderer | OpenGL / DirectX 11 / DirectX 12 |
| **Build System** | None (interpreted) | CMake |
| **Platform** | Cross-platform | Windows (primary) |
| **Deployment** | Godot export | Native executable |

### Architecture Changes

#### Previous Architecture (Godot)
```
Scripts (GDScript)
    ↓
Godot Engine
    ↓
Rendering / Physics / Audio
```

#### New Architecture (Native C++)
```
Game Logic (C++)
    ↓
Custom Engine Layer
    ├── Renderer Abstraction
    │   ├── OpenGL Backend
    │   ├── DirectX 11 Backend
    │   └── DirectX 12 Backend
    ├── Input System
    ├── Window Management
    └── Time Management
```

## Directory Structure

### Old Structure (Godot)
```
project.godot           # Godot project file
scripts/                # GDScript files
├── systems/           # Game systems
├── entities/          # Game entities
└── autoload/          # Singletons
scenes/                # .tscn scene files
```

### New Structure (C++)
```
CMakeLists.txt         # Build configuration
src/                   # C++ source files
├── engine/           # Core engine
├── renderer/         # Rendering backends
├── platform/         # Platform-specific code
├── game/             # Game logic
└── main.cpp          # Entry point
include/              # Header files
├── engine/
├── renderer/
├── platform/
└── game/
third_party/          # External libraries
tests/                # Unit tests
```

## Component Mapping

### Renderer

| Godot Component | Native C++ Equivalent |
|-----------------|----------------------|
| `RenderingServer` | `IRenderer` interface |
| `MeshInstance3D` | Custom mesh system |
| `Camera3D` | Custom camera class |
| Godot shaders (.gdshader) | GLSL/HLSL shaders |

### World Generation

| Godot Component | Native C++ Equivalent |
|-----------------|----------------------|
| `scripts/systems/world_generation/world_generator.gd` | `src/game/WorldGenerator.cpp` (TODO) |
| `FastNoiseLite` | Custom or third-party noise library |
| `Node3D` scene tree | Custom scene graph |

### Player Controller

| Godot Component | Native C++ Equivalent |
|-----------------|----------------------|
| `CharacterBody3D` | Custom physics body |
| `Input.get_vector()` | `InputManager` class |
| `move_and_slide()` | Custom physics integration |

### Voxel System

| Godot Component | Native C++ Equivalent |
|-----------------|----------------------|
| `scripts/systems/voxel/chunk.gd` | `src/game/VoxelSystem.cpp` (TODO) |
| `ArrayMesh` | Custom mesh generation |
| Voxel array | `std::vector` or custom container |

## Rendering APIs

### OpenGL Support
- **Version**: OpenGL 3.3 Core or newer
- **Loader**: GLAD
- **Window**: GLFW
- **Shaders**: GLSL

### DirectX 11 Support
- **Version**: D3D11
- **API**: Direct3D 11
- **Shaders**: HLSL (Shader Model 5.0)
- **Features**: Hardware accelerated, widely supported

### DirectX 12 Support
- **Version**: D3D12
- **API**: Direct3D 12
- **Shaders**: HLSL (Shader Model 6.0)
- **Features**: Low-level API, best performance

## Migration Strategy

### Phase 1: Foundation (Complete)
- ✅ CMake build system
- ✅ Rendering abstraction layer
- ✅ OpenGL renderer
- ✅ DirectX 11 renderer
- ✅ DirectX 12 renderer (basic structure)
- ✅ Window management
- ✅ Input system
- ✅ Time management
- ✅ Test framework

### Phase 2: Core Systems (TODO)
- [ ] Math library integration (GLM)
- [ ] Camera system
- [ ] Scene graph
- [ ] Resource manager
- [ ] Shader system
- [ ] Mesh generation

### Phase 3: Game Systems (TODO)
- [ ] Voxel system
  - [ ] Chunk management
  - [ ] Mesh generation
  - [ ] Greedy meshing
- [ ] World generation
  - [ ] Noise generation
  - [ ] Biome system
  - [ ] River generation
  - [ ] Ore placement
- [ ] Player controller
  - [ ] Movement
  - [ ] Camera controls
  - [ ] Interaction

### Phase 4: Advanced Features (TODO)
- [ ] Physics system
- [ ] Inventory system
- [ ] Crafting system
- [ ] Combat system
- [ ] Audio system
- [ ] UI system

## Building the Project

### Prerequisites
```
- Visual Studio 2019+ with C++ tools
- CMake 3.15+
- Windows 10 SDK
- Git
```

### Build Steps
```powershell
# Clone with submodules
git clone --recursive https://github.com/shifty81/Sword-And-Stone.git
cd Sword-And-Stone

# Setup third-party dependencies
cd third_party
# Follow instructions in third_party/README.md

# Generate build files
cd ..
mkdir build
cd build
cmake .. -G "Visual Studio 17 2022" -A x64

# Build
cmake --build . --config Release

# Run
.\bin\Release\SwordAndStone.exe
```

## Testing

### Unit Tests
```powershell
cd build
ctest -C Release
```

### Manual Testing
- Launch the executable
- Verify window creation
- Check rendering API initialization
- Test input response
- Verify frame rate

## Development Workflow

### Adding New Features
1. Create header in `include/`
2. Create implementation in `src/`
3. Update `CMakeLists.txt`
4. Write tests in `tests/`
5. Build and test
6. Commit changes

### Debugging
- Use Visual Studio debugger
- Enable debug build: `cmake --build . --config Debug`
- Check console output
- Use RenderDoc for graphics debugging

## Performance Considerations

### Compared to Godot
- **Pros**:
  - Lower overhead
  - Direct hardware access
  - Better optimization potential
  - Native Windows integration
  
- **Cons**:
  - More manual memory management
  - Need to implement missing features
  - More complex debugging

### Optimization Tips
- Use Release builds for performance testing
- Profile with Visual Studio Profiler
- Optimize hot paths (voxel meshing, rendering)
- Use efficient data structures
- Consider multi-threading

## Known Limitations

### Current State
- DirectX 12 renderer is incomplete (basic structure only)
- No game logic ported yet
- Missing many engine features
- No audio system
- No UI system

### Future Work
- Complete DirectX 12 implementation
- Port voxel system from GDScript
- Implement physics engine
- Add multi-threading support
- Create comprehensive test suite

## Resources

### Documentation
- [BUILD.md](BUILD.md) - Build instructions
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture (being updated)
- [third_party/README.md](third_party/README.md) - Dependencies guide

### External Resources
- OpenGL: https://www.opengl.org/
- DirectX 11: https://docs.microsoft.com/en-us/windows/win32/direct3d11/
- DirectX 12: https://docs.microsoft.com/en-us/windows/win32/direct3d12/
- GLM: https://github.com/g-truc/glm
- GLFW: https://www.glfw.org/

## FAQ

### Q: Why restructure from Godot to C++?
A: To have full control over rendering pipelines, better Windows integration, and support for multiple graphics APIs including DirectX.

### Q: Will this still work on other platforms?
A: The OpenGL renderer can be made cross-platform. DirectX is Windows-only. Future work could add Vulkan or Metal support.

### Q: How much of the game logic has been ported?
A: Currently, only the foundation is complete. Game logic porting is in progress.

### Q: Can I still use the Godot version?
A: Yes, the Godot project files are still in the repository for reference, but they are being phased out.

### Q: Which renderer should I use?
A: DirectX 11 is recommended for Windows. OpenGL is good for development and cross-platform work.

## Contributing

When contributing to the native C++ version:
1. Follow C++17 standards
2. Use the established project structure
3. Write unit tests for new features
4. Document public APIs
5. Test on Windows 10+

## License

Same as the original Godot version - provided as-is for educational purposes.
