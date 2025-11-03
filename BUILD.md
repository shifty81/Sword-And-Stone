# Build Instructions - Native C++ Edition

**Sword And Stone** has been restructured as a native C++ Windows application with support for multiple rendering APIs (OpenGL, DirectX 11, DirectX 12).

## Prerequisites

### Required
- **Visual Studio 2019 or newer** (with C++ development tools)
- **CMake 3.15 or newer**
- **Windows 10 SDK** (for DirectX support)
- **Git** (for cloning submodules)

### Third-Party Dependencies
The following libraries are required and should be placed in the `third_party/` directory:
- **GLM** - Math library (header-only)
- **GLFW** - Window and input management (for OpenGL)
- **GLAD** - OpenGL loader
- **STB** - Image loading (header-only)

## Quick Start (Visual Studio)

1. **Clone the repository with submodules:**
   ```powershell
   git clone --recursive https://github.com/shifty81/Sword-And-Stone.git
   cd Sword-And-Stone
   ```

2. **Create build directory:**
   ```powershell
   mkdir build
   cd build
   ```

3. **Generate Visual Studio solution:**
   ```powershell
   cmake .. -G "Visual Studio 16 2019" -A x64
   ```
   
   Or for Visual Studio 2022:
   ```powershell
   cmake .. -G "Visual Studio 17 2022" -A x64
   ```

4. **Build the project:**
   ```powershell
   cmake --build . --config Release
   ```

5. **Run the game:**
   ```powershell
   .\bin\Release\SwordAndStone.exe
   ```

## Build Options

You can customize the build with CMake options:

```powershell
# Disable DirectX 12 support
cmake .. -DENABLE_DX12=OFF

# Disable DirectX 11 support
cmake .. -DENABLE_DX11=OFF

# Disable OpenGL support
cmake .. -DENABLE_OPENGL=OFF

# Disable tests
cmake .. -DBUILD_TESTS=OFF

# Example: Build with only DirectX 11
cmake .. -DENABLE_OPENGL=OFF -DENABLE_DX12=OFF
```

## Building from Visual Studio IDE

1. Open CMake project in Visual Studio:
   - File → Open → CMake
   - Select the root `CMakeLists.txt`

2. Configure build settings:
   - CMake → CMake Settings
   - Adjust configuration as needed

3. Build:
   - Build → Build All (Ctrl+Shift+B)

4. Run:
   - Select `SwordAndStone.exe` as startup item
   - Debug → Start Debugging (F5)

## Project Structure

```
├── src/
│   ├── engine/          # Core engine systems
│   ├── renderer/        # Rendering backends (OpenGL, DX11, DX12)
│   ├── platform/        # Platform-specific code
│   ├── game/            # Game logic and systems
│   └── main.cpp         # Entry point
├── include/             # Header files
├── third_party/         # External dependencies
├── assets/              # Game assets
├── tests/               # Unit tests
└── CMakeLists.txt       # Build configuration
```

## Rendering APIs

The engine supports multiple rendering backends:

### OpenGL 3.3+
- Cross-platform compatible
- Widely supported
- Good for development and testing

### DirectX 11
- Windows-only
- Excellent performance
- Mature and stable API
- Recommended for Windows releases

### DirectX 12
- Windows 10+ only
- Low-level modern API
- Best performance potential
- More complex to use

The engine automatically selects the best available API at runtime in this order:
1. DirectX 12 (if available)
2. DirectX 11 (if available)
3. OpenGL (fallback)

## Testing

Run unit tests with:

```powershell
cd build
ctest -C Release
```

Or run the test executable directly:

```powershell
.\bin\Release\SwordAndStone_Tests.exe
```

## Troubleshooting

### CMake can't find Visual Studio
Ensure Visual Studio is properly installed with C++ tools:
- Install "Desktop development with C++" workload
- Restart your terminal/command prompt

### Missing DirectX SDK
Windows 10 SDK includes DirectX. Install via Visual Studio Installer:
- Individual Components → Windows 10 SDK (latest version)

### GLFW/GLAD not found
Make sure submodules are initialized:
```powershell
git submodule update --init --recursive
```

### Compilation errors in renderer code
Ensure you have the correct Windows SDK:
- Check `#include <d3d11.h>` and `#include <d3d12.h>` work
- Update Windows 10 SDK if needed

## Development

### Adding New Features
1. Create header files in `include/`
2. Create implementation files in `src/`
3. Update appropriate `CMakeLists.txt`
4. Rebuild project

### Code Style
- Use modern C++17 features
- Follow naming conventions in existing code
- Document public APIs
- Write unit tests for new systems

### Debugging
- Use Visual Studio debugger (F5)
- Enable debug builds: `cmake --build . --config Debug`
- Check logs in console output

## Performance

### Release Build
Always use Release builds for performance testing:
```powershell
cmake --build . --config Release
```

### Profiling
- Use Visual Studio Profiler (Alt+F2)
- Monitor frame times and GPU usage
- Optimize hot paths identified by profiler

## Documentation

- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - System architecture (being updated)
- [DEVELOPMENT.md](docs/DEVELOPMENT.md) - Development guide (being updated)
- API documentation - Generated with Doxygen (coming soon)

## Migration from Godot

This project has been restructured from a Godot-based project to native C++. The original Godot project files (`project.godot`, `*.gd` scripts, `*.tscn` scenes) are being phased out but remain in the repository for reference during migration.

## Summary

- ✅ **Build system:** CMake
- ✅ **Compiler:** Visual Studio 2019+ (MSVC)
- ✅ **Platform:** Windows 10+ (primary), cross-platform potential
- ✅ **Graphics APIs:** OpenGL 3.3+, DirectX 11, DirectX 12
- ✅ **Language:** C++17
