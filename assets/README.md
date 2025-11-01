# Assets Directory

This directory contains all game assets organized by type.

## Directory Structure

- **audio/** - Sound effects, music, and ambient sounds
  - `music/` - Background music tracks
  - `sfx/` - Sound effects for actions and events
  - `ambient/` - Environmental and ambient sounds

- **fonts/** - Custom fonts for UI and text rendering

- **models/** - 3D models and meshes (.gltf, .obj, .fbx, etc.)
  - `characters/` - Player and NPC character models
  - `items/` - Item and equipment 3D models
  - `props/` - Environmental objects and decorations
  - `environment/` - Terrain features and structures

- **sprites/** - 2D sprites and icons
  - `ui/` - User interface graphics
  - `icons/` - Item and ability icons
  - `effects/` - 2D particle effects and sprites

- **textures/** - Texture files for 3D models
  - `terrain/` - Ground, rock, and terrain textures
  - `items/` - Item and equipment textures
  - `materials/` - Material textures (metal, wood, etc.)

- **vfx/** - Visual effects and particle systems

## Notes

- All assets should be organized by type and purpose
- Use descriptive filenames (e.g., `sword_iron_diffuse.png`, not `texture1.png`)
- Keep source files (e.g., .blend, .psd) in a separate `/source/` directory (not committed to git)
- Optimize assets before importing (compress textures, reduce polygon counts where appropriate)
