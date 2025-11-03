# Third-Party Dependencies

This directory contains external libraries required to build Sword And Stone.

## Required Libraries

### GLM (OpenGL Mathematics)
- **Version:** 0.9.9.8 or newer
- **License:** MIT
- **URL:** https://github.com/g-truc/glm
- **Purpose:** Math library for graphics (vectors, matrices, quaternions)
- **Installation:**
  ```bash
  cd third_party
  git clone https://github.com/g-truc/glm.git
  ```

### GLFW (Graphics Library Framework)
- **Version:** 3.3 or newer
- **License:** zlib/libpng
- **URL:** https://github.com/glfw/glfw
- **Purpose:** Window creation, input handling, OpenGL context
- **Required for:** OpenGL renderer
- **Installation:**
  ```bash
  cd third_party
  git clone https://github.com/glfw/glfw.git
  ```

### GLAD (OpenGL Loader)
- **Version:** OpenGL 3.3+
- **License:** Public Domain / MIT
- **URL:** https://glad.dav1d.de/ or https://github.com/Dav1dde/glad
- **Purpose:** OpenGL function loader
- **Required for:** OpenGL renderer
- **Installation:**
  1. Generate loader from https://glad.dav1d.de/
     - Language: C/C++
     - API gl: Version 3.3+
     - Profile: Core
  2. Download and extract to `third_party/glad/`
  
  Or clone prebuilt:
  ```bash
  cd third_party
  git clone https://github.com/Dav1dde/glad.git
  cd glad
  cmake . -DGLAD_INSTALL=ON
  ```

### STB (Sean Barrett's Libraries)
- **Version:** Latest
- **License:** Public Domain / MIT
- **URL:** https://github.com/nothings/stb
- **Purpose:** Image loading (stb_image.h)
- **Installation:**
  ```bash
  cd third_party
  git clone https://github.com/nothings/stb.git
  ```

## Quick Setup (All Dependencies)

Run this script to clone all dependencies at once:

```bash
cd third_party

# GLM
git clone https://github.com/g-truc/glm.git

# GLFW
git clone https://github.com/glfw/glfw.git

# STB
git clone https://github.com/nothings/stb.git

# GLAD (you may need to generate this separately)
# See https://glad.dav1d.de/ for custom generation
```

## Using Git Submodules (Recommended)

To manage dependencies as git submodules:

```bash
# From project root
git submodule add https://github.com/g-truc/glm.git third_party/glm
git submodule add https://github.com/glfw/glfw.git third_party/glfw
git submodule add https://github.com/nothings/stb.git third_party/stb

# When cloning the project
git clone --recursive <your-repo-url>

# Or if already cloned
git submodule update --init --recursive
```

## DirectX Dependencies

DirectX 11 and DirectX 12 support requires:
- **Windows 10 SDK** (included with Visual Studio)
- No additional downloads needed

These are automatically available when building on Windows with Visual Studio.

## Directory Structure

After setup, your `third_party/` directory should look like:

```
third_party/
├── CMakeLists.txt      # Build configuration
├── README.md           # This file
├── glm/                # GLM math library
├── glfw/               # GLFW windowing library
├── glad/               # GLAD OpenGL loader
└── stb/                # STB image library
```

## Build Integration

All dependencies are integrated via the `third_party/CMakeLists.txt` file. CMake will automatically find and link these libraries when you build the project.

## Troubleshooting

### Missing dependencies error
- Ensure all libraries are cloned/downloaded
- Check directory names match exactly (lowercase)
- Re-run CMake configuration

### GLAD not found
- GLAD requires special generation from https://glad.dav1d.de/
- Ensure you have both `include/` and `src/` directories
- Check that `glad.h` is in `glad/include/glad/`

### GLFW build errors
- GLFW requires CMake to build
- It will be built automatically as part of the main project
- Ensure you have a C compiler available

## License Compliance

When distributing your game:
- **GLM:** Include GLM license (MIT)
- **GLFW:** Include GLFW license (zlib/libpng)
- **GLAD:** Public Domain, attribution appreciated
- **STB:** Public Domain, attribution appreciated
- **DirectX:** Microsoft DirectX is part of Windows

See individual library directories for full license texts.
