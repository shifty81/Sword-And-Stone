# Crimson Isles - Scene Building Guide

## Quick Start

### Main Scene (`crimson_isles_main.tscn`)
This is your main playable world. Open it in Godot and you can:
- **Walk around** using WASD keys
- **Sprint** by holding Shift
- **Add assets** to the `BuildingArea` node
- **Build environments** directly in the editor

### Creating Dungeons

1. **Open** `scenes/dungeons/dungeon_template.tscn`
2. **Add your content** to the layers:
   - `GroundLayer` - Floor tiles and terrain
   - `WallsLayer` - Walls and barriers (add StaticBody2D with CollisionShape2D)
   - `PropsLayer` - Decorations, obstacles, interactive objects
   - `EnemySpawns` - Place Marker2D nodes where enemies should spawn
   - `LootSpawns` - Place Marker2D nodes for treasure chests/loot
3. **Save As** a new scene (e.g., `forest_dungeon_01.tscn`)
4. Your dungeon is ready to load dynamically!

## Scene Structure

### Building Collisions
When adding walls or obstacles:
```
WallsLayer/
  ├─ Wall (StaticBody2D)
  │  ├─ Sprite2D (visual)
  │  └─ CollisionShape2D (physics)
```

### Enemy Spawns
```
EnemySpawns/
  ├─ SpawnPoint1 (Marker2D)
  ├─ SpawnPoint2 (Marker2D)
  └─ SpawnPoint3 (Marker2D)
```

### Loot Spawns
```
LootSpawns/
  ├─ ChestSpawn1 (Marker2D)
  └─ ChestSpawn2 (Marker2D)
```

## Tips

- Use **ColorRect** nodes for quick placeholder floors/walls
- Use **Sprite2D** nodes when you add proper textures
- Add **StaticBody2D** with **CollisionShape2D** for solid walls
- Use **Area2D** for trigger zones (dungeon entrance, traps, etc.)
- Group similar objects under parent nodes for organization
- Name your nodes descriptively (e.g., "NorthWall", "TreasureChest_Gold")

## Controls in Editor
- **Middle Mouse** - Pan the view
- **Mouse Wheel** - Zoom in/out
- **Q** - Select mode
- **W** - Move mode
- **E** - Rotate mode
- **S** - Scale mode

## Testing Your Scene
1. Save your scene
2. Press **F6** to run the current scene (to test it standalone)
3. Or press **F5** to run the main scene (to test it in context)

## Workflow
1. Build your dungeon in `dungeon_template.tscn` or a copy
2. Add all visual assets, collisions, and spawn points
3. Save it as a unique scene
4. Later, we'll load these scenes dynamically during gameplay
