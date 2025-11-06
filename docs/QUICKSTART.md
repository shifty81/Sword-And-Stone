# Quick Start Guide

## Opening the Project

1. **Install Godot 4.3 or newer** from [godotengine.org](https://godotengine.org/)
2. Clone or download this repository
3. Open Godot and click "Import"
4. Navigate to the project folder and select `project.godot`
5. Click "Import & Edit"

## Running the Game

1. Press **F5** or click the Play button in the top-right
2. The game will start and generate the world around you
3. Wait a few seconds for chunks to generate

## Controls

### Movement
- **W** - Move forward
- **A** - Move left
- **S** - Move backward
- **D** - Move right
- **Space** - Jump
- **Left Shift** - Sprint (hold while moving)

### Camera
- **Mouse** - Look around
- The camera is automatically locked. Move your mouse to look.

### Interaction
- **Left Mouse Button** - Break/destroy voxel blocks
- **Right Mouse Button** - Place stone blocks
- Look at a block and click to interact

### System
- **ESC** - Toggle mouse cursor (release/capture)
- Click the game window to recapture the mouse

## Understanding the World

### Terrain Features
- **Green blocks** - Grass (surface)
- **Brown blocks** - Dirt (underground)
- **Gray blocks** - Stone (deep underground)
- **Dark gray blocks** - Bedrock (unbreakable)
- **Blue blocks** - Water (oceans and rivers)
- **Tan blocks** - Sand (beaches)

### World Generation
- The world generates in **chunks** (16x16x16 blocks)
- **Continents** are large landmasses above sea level
- **Rivers** flow from mountains to the ocean
- Explore to see different terrain features

## Testing Features

### Breaking Blocks
1. Look at any block (except bedrock)
2. Left-click to break it
3. The block will disappear

### Placing Blocks
1. Look at an existing block
2. Right-click to place a stone block on top/side
3. You can build structures this way

### Exploring
1. Use WASD to move around
2. Sprint (Shift) to move faster
3. Jump (Space) to climb terrain
4. You cannot fall through the world

### Debug Info
- Top-left corner shows:
  - FPS (frames per second)
  - Your current position (X, Y, Z)

## Common Issues

### "Game runs slowly"
- **Solution**: Lower the render distance in the world generator settings
- Open `scenes/main.tscn` and reduce the `render_distance` property on WorldGenerator

### "I fell through the world"
- **Solution**: You spawned before chunks loaded. Press F5 to restart.
- The player starts at Y=80. Chunks should generate around you.

### "Blocks look wrong/missing"
- **Solution**: The mesh might not have generated. This can happen at chunk borders.
- Walk away and come back, or restart the game.

### "Mouse won't lock"
- **Solution**: Click on the game window to focus it, then move your mouse.
- Press ESC to unlock if needed.

## Next Steps

### For Players
- Explore the generated world
- Build structures
- Try to find rivers and continents
- Test the breaking/placing mechanics

### For Developers
- See `DEVELOPMENT.md` for technical details
- Read `docs/PHYSICS_SYSTEM.md` to learn about the physics engine
- Modify `scripts/world_generation/world_generator.gd` to change terrain
- Edit `scripts/voxel/voxel_type.gd` to add new block types
- Create new items in `resources/items/`
- Use `PhysicsManager` to create dynamic physics objects

### Testing Physics System
The game includes a physics test spawner. Press these keys in-game:
- **1** - Spawn a pickupable physics item
- **2** - Spawn a projectile
- **3** - Spawn a falling block
- **4** - Spawn a bouncy ball (demonstrates physics materials)
- **5** - Toggle physics debug visualization
- **Backspace** - Clean up all spawned physics objects

## Performance Tips

### If experiencing low FPS:
1. Reduce `render_distance` in WorldGenerator (default: 6, try: 4)
2. Reduce `chunk_size` (default: 16, try: 8)
3. Disable shadows in DirectionalLight3D
4. Lower window resolution

### Recommended Settings:
- **Good PC**: render_distance = 8, chunk_size = 16
- **Average PC**: render_distance = 6, chunk_size = 16  (default)
- **Low-end PC**: render_distance = 4, chunk_size = 8

## Getting Help

- Check `README.md` for feature overview
- Read `DEVELOPMENT.md` for technical details
- Review code comments in script files
- All scripts have descriptive comments

## Have Fun!

Explore, build, and experiment with the world generation system. This is an early prototype with more features planned!
