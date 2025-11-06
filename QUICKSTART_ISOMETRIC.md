# Quick Start Guide - Isometric Edition

## 🎮 Play Now!

1. **Open in Godot 4.3+**
   - Open Godot
   - Click "Import"
   - Select `project.godot`

2. **Press F5 to Play**
   - World generates automatically (takes 1-2 seconds)
   - You spawn at world center

3. **Explore & Build!**
   - Walk around the procedurally generated world
   - Press B to build structures
   - Watch the day/night cycle

## 🎮 Controls

### Movement
- **W** - Move North-East
- **A** - Move North-West  
- **S** - Move South-East
- **D** - Move South-West
- **Shift** - Sprint (250 → 400 speed)

*Note: Movement is isometric - directions are diagonal to screen*

### Building
- **B** - Toggle Building Mode
- **Left Click** - Place building piece
- **Right Click** - Remove building piece
- **ESC** - Exit building mode

### Camera
- Camera follows player automatically
- Zoom: 1.2x (good balance for isometric view)

## 🌍 World Features

### Terrain Types (15 total)
- **Water** - Deep ocean (swim or boat)
- **Sand** - Beaches near water
- **Grass** - Plains and meadows
- **Dirt** - Dry areas
- **Stone** - Rocky hills and mountains
- **Snow** - Mountain peaks
- **Wood/Leaves** - Trees and forests
- **Ores** - Coal, Iron, Gold, Copper

### Biomes
- **Ocean** - Below 35% elevation
- **Beach** - Transition zone (sand)
- **Plains** - Grass with occasional trees
- **Forest** - Dense trees (15% spawn rate)
- **Hills** - Stone and gravel
- **Mountains** - Stone with snow peaks (>85% elevation)

### Decorations
- **Rocks** - Small and large boulders
- **Grass Tufts** - Small vegetation
- **Flowers** - Red and yellow variants
- **Bushes** - Green foliage

### Living World
- **Day/Night Cycle** - 5 minute full cycle
  - Midnight → Dawn → Noon → Dusk → Midnight
  - Visual lighting changes
  - Time displayed in HUD
- **Procedural Decorations** - Rocks, flowers, grass
- **Tree Generation** - Natural forests

## 🏗️ Building System

### Available Pieces
1. **Walls**
   - Wood Wall (2 wood)
   - Stone Wall (3 stone)
2. **Floors**
   - Wood Floor (1 wood)
   - Stone Floor (2 stone)
3. **Roofs**
   - Thatch Roof (1 wood, 2 grass)
   - Tile Roof (2 stone)
4. **Features**
   - Wood Door (3 wood)
   - Window (1 wood, 1 stone)

### Starting Resources
- Wood: 100
- Stone: 100
- Grass: 50

### Building Tips
- Build on solid ground (not water)
- Plan your layout before building
- Walls on layer 3, terrain on layer 0
- Right-click removes buildings (50% refund)

## 🎨 Visual Features

### Isometric Tiles
- **64x48 pixels** per tile
- **3-face rendering** - top, left, right
- **Shading** - Different brightness per face
- **Outlines** - Black borders for clarity

### Lighting
- **Day** - Full brightness
- **Dawn/Dusk** - Orange/red tint
- **Night** - Blue/purple tint
- Smooth transitions between phases

## 📊 HUD Information

### Top Left
- **Time Display** - Current time and day/night indicator
- **Resources** - Wood, Stone, Grass counts

### Bottom Left
- **Controls Reference** - Quick reminder

### Center (Build Mode)
- **Build Mode Indicator** - Shows when active
- **Instructions** - Place/Remove controls

## 🔧 Advanced Configuration

### In Godot Editor

1. **Open Scene**: `scenes/main/isometric_main.tscn`

2. **WorldGenerator Node**:
   - `world_seed` - Change for different worlds
   - `world_size_x/y` - World dimensions
   - `ocean_level` - Water level (0.0-1.0)
   - `tree_density` - Tree spawn rate (0.0-1.0)
   - `generate_decorations` - Enable/disable rocks, flowers

3. **Player Node**:
   - `move_speed` - Base movement speed
   - `sprint_speed` - Sprint speed

4. **DayNightCycle** (CanvasModulate):
   - `cycle_duration` - Seconds per full cycle
   - `enable_cycle` - Toggle day/night

## 🐛 Troubleshooting

### World Not Generating?
- Check Output panel in Godot
- Ensure `isometric_tileset.png` exists in `assets/textures/terrain/`
- Run `python3 generate_isometric_tileset.py` if missing

### Can't See Player?
- Press F5 to reload scene
- Check player is at position (0, 0)
- Camera should auto-follow

### Building Not Working?
- Press B to enable building mode
- Check resources (top-left HUD)
- Can't build on water or existing buildings

### Performance Issues?
- Reduce world size (128x128 → 64x64)
- Disable decorations
- Lower tree density

## 🎯 What to Try First

1. **Explore the World**
   - Walk to the ocean
   - Climb a mountain
   - Find a forest

2. **Build a Shelter**
   - Press B for build mode
   - Place 4 walls in a square
   - Add a roof
   - Add a door

3. **Watch Time Pass**
   - Observe lighting changes
   - See day turn to night
   - Notice different atmosphere

4. **Test Generation**
   - Edit `world_seed` in WorldGenerator
   - Press F5 to regenerate
   - Explore the new world!

## 📝 Next Development Steps

Want to enhance further?
- Add resource gathering (mining, chopping)
- Create crafting recipes
- Add NPC creatures
- Implement combat
- Add inventory UI
- Save/load system
- Multiplayer

## 🆘 Need Help?

- Check `ISOMETRIC_README.md` for full documentation
- See code comments in script files
- Godot docs: https://docs.godotengine.org/

## 🎉 Have Fun!

You now have a fully functional 2.5D isometric survival game foundation. 

Explore, build, and make it your own! 🏰🌲⛰️
