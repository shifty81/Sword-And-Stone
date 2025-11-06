# Crimson Isles - Setup and Usage Guide

## ✅ What's Ready Right Now

You can **immediately** open and work with the project in Godot!

### Opening the Project

1. **Launch Godot 4.3+**
2. **Import Project** → Navigate to this directory → Select `project.godot`
3. **Open** the project

### Testing the Walkable Scene

Once Godot opens:

1. The main scene is **already set** as `scenes/main/crimson_isles_main.tscn`
2. Press **F5** or click the **Play** button ▶️
3. You should see:
   - A green ground area
   - A blue player character with "Player" label
   - Camera following the player

**Controls:**
- **W/A/S/D** - Move in 4 directions
- **Shift** - Sprint (hold while moving)
- **ESC** - Close game

### Building in the Editor

#### Working on the Main Scene

1. In Godot, open `scenes/main/crimson_isles_main.tscn` (double-click in FileSystem)
2. You'll see the scene tree on the left:
   ```
   CrimsonIsles_Main
   ├─ GroundLayer (where you can add terrain)
   ├─ Player (the character)
   ├─ BuildingArea (ADD YOUR ASSETS HERE)
   └─ CanvasModulate (for day/night lighting)
   ```

3. **To add objects:**
   - Right-click on `BuildingArea` node
   - Choose "Add Child Node"
   - Add Sprite2D, StaticBody2D, Area2D, etc.
   - Position them in the 2D view

4. **To add walls/obstacles:**
   - Right-click `BuildingArea` → Add Child Node → StaticBody2D
   - Right-click the new StaticBody2D → Add Child Node → CollisionShape2D
   - Right-click the StaticBody2D again → Add Child Node → Sprite2D or ColorRect
   - In Inspector, set the CollisionShape2D's Shape (click empty dropdown → New RectangleShape2D)
   - Adjust size and position

5. **Save** your changes (Ctrl+S)

#### Creating Custom Dungeons

1. In FileSystem, navigate to `scenes/dungeons/`
2. Double-click `dungeon_template.tscn`
3. Build your dungeon using the organized layers:
   - `GroundLayer` - Floor tiles
   - `WallsLayer` - Walls and barriers
   - `PropsLayer` - Decorations
   - `EnemySpawns` - Add Marker2D nodes for enemy spawn points
   - `LootSpawns` - Add Marker2D nodes for treasure
4. When done: **Scene** menu → **Save Scene As** → Name it (e.g., `cave_dungeon_01.tscn`)
5. Your dungeon is now a reusable scene!

## Scene Structure Explanation

### Current Main Scene Layout

```
CrimsonIsles_Main (Node2D) - Root
│
├─ GroundLayer (Node2D) - Background terrain layer
│  └─ GroundTile (ColorRect) - 4000x4000 green ground
│
├─ Player (CharacterBody2D) - Player character with physics
│  ├─ CollisionShape2D - Physics collision
│  ├─ Sprite2D - Visual representation
│  ├─ Label - "Player" text above character
│  └─ Camera2D - Follows player automatically
│
├─ CanvasModulate (CanvasModulate) - Controls screen tinting for day/night
│
├─ BuildingArea (Node2D) - **ADD YOUR ASSETS HERE**
│
└─ Label - Instructions text
```

### Player Movement

The player uses GDScript in `scripts/entities/player/topdown_player.gd`:
- Reads WASD input using Godot's Input system
- Moves at 250 pixels/second (or 400 when sprinting)
- Uses `CharacterBody2D.move_and_slide()` for smooth physics-based movement
- Camera follows automatically (child of Player node)

## Adding Your Own Assets

### Adding Sprites

1. Put your image files in `assets/sprites/` or `assets/textures/`
2. In Godot, they'll appear in the FileSystem panel
3. Drag and drop onto the scene or:
   - Add a Sprite2D node
   - In Inspector → Texture → Click and select your image

### Adding Tilesets (for terrain)

1. Create a TileMap node in your scene
2. In Inspector → TileSet → New TileSet
3. Click the TileSet to edit it
4. Add your tileset image and configure tiles
5. Paint terrain directly in the editor

### Adding Interactive Objects

Example - A treasure chest:
```
BuildingArea/
└─ TreasureChest (Area2D)
   ├─ Sprite2D (chest image)
   ├─ CollisionShape2D (for detecting player)
   └─ Script (chest_script.gd)
```

Connect the `body_entered` signal to detect when player touches it!

## What's Been Configured

### Project Settings
- ✅ Main scene set to top-down view
- ✅ Input mappings for WASD movement
- ✅ Sprint key (Shift) configured
- ✅ Camera system set up
- ✅ Physics layers configured

### Systems Ready
- ✅ **WorldStateManager** - Day/night cycle, seasons, weather (autoloaded)
- ✅ **Player Controller** - Smooth WASD movement with sprint
- ✅ **Camera System** - Automatic following camera

### Autoloaded Systems
These are globally available:
- `GameManager` - Game state management
- `WorldStateManager` - **NEW** - Time, weather, seasons
- `PhysicsManager` - Physics utilities
- `TimeManager` - Time tracking
- `InputHelper` - Input utilities
- `TextureLoader` - Texture management

You can access them from any script:
```gdscript
# Check if it's nighttime
if WorldStateManager.is_daytime:
    print("It's day!")
```

## Next Steps

Now that the scene is walkable, you can:

1. **Add visual assets** - Import sprites, tilesets, textures
2. **Build environments** - Create forests, towns, dungeons
3. **Add interactive objects** - Chests, NPCs, doors
4. **Test frequently** - Press F5 to run and test your changes
5. **Create dungeons** - Use the template to build reusable dungeon scenes

## Tips

- **Save often** (Ctrl+S)
- **Test frequently** (F5 to run)
- **Use layers** - Keep things organized in Node2D parent nodes
- **Name descriptively** - "ForestTree01" is better than "Node2D"
- **Use Ctrl+D** to duplicate nodes quickly
- **Press F6** to run just the current scene (great for testing dungeons)

## Troubleshooting

### Player doesn't move
- Make sure you pressed F5 (not just opened the scene)
- Check that the Player node has the script attached
- Verify WASD keys are mapped in Project → Project Settings → Input Map

### Can't see player
- Check the Sprite2D node is visible (eye icon in scene tree)
- Verify Camera2D is enabled and following player
- Try zooming out (mouse wheel) in game view

### Scene won't run
- Check Output panel (bottom) for errors
- Verify the scene file isn't corrupted
- Try File → Reload Current Scene

## Getting Help

- Check `scenes/dungeons/README.md` for dungeon building guide
- Review existing scripts in `scripts/entities/player/` for examples
- Godot docs: https://docs.godotengine.org/

---

**You're all set! Open Godot and start building! 🎮🏝️**
