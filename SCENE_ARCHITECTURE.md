# Crimson Isles - Scene Architecture

## Main Scene Hierarchy

```
📁 CrimsonIsles_Main (Node2D)
│
├── 🌍 GroundLayer (Node2D)
│   └── 🟩 GroundTile (ColorRect)
│       └── 4000x4000 green grass area
│
├── 🚶 Player (CharacterBody2D) ⭐ Main Character
│   ├── 🛡️ CollisionShape2D (24x32)
│   ├── 👤 Sprite2D (Blue placeholder)
│   ├── 🏷️ Label ("Player")
│   └── 📷 Camera2D (Follows player)
│       └── Zoom: 1.5x
│
├── 🌞 CanvasModulate
│   └── Controls day/night tinting
│
├── 🏗️ BuildingArea (Node2D) ⭐ ADD YOUR ASSETS HERE
│   └── (Empty - ready for your content!)
│
└── ℹ️ Label (Instructions)
```

## Dungeon Template Hierarchy

```
📁 DungeonTemplate (Node2D)
│
├── 🌍 GroundLayer (Node2D)
│   └── 🟦 GroundTile (ColorRect)
│       └── 1000x1000 dark floor
│
├── 🧱 WallsLayer (Node2D)
│   └── Add StaticBody2D nodes here
│       └── Each with CollisionShape2D + Sprite2D
│
├── 🎨 PropsLayer (Node2D)
│   └── Decorations, obstacles, furniture
│
├── 👾 EnemySpawns (Node2D)
│   └── Add Marker2D for spawn points
│
├── 💎 LootSpawns (Node2D)
│   └── Add Marker2D for treasure locations
│
└── 🚪 EntranceExit (Area2D)
    ├── CollisionShape2D
    └── Marker2D (Spawn point)
```

## Node Type Guide

### Common Node Types You'll Use

| Node Type | Purpose | Use For |
|-----------|---------|---------|
| **Node2D** | Basic 2D container | Organizing/grouping objects |
| **Sprite2D** | Display images | Characters, props, decorations |
| **CharacterBody2D** | Physics character | Player, NPCs |
| **StaticBody2D** | Static physics object | Walls, obstacles |
| **Area2D** | Detection zone | Triggers, pickups, zones |
| **CollisionShape2D** | Physics boundary | All physics objects |
| **Marker2D** | Position marker | Spawn points, waypoints |
| **ColorRect** | Colored rectangle | Placeholder backgrounds |
| **Label** | Text display | Names, instructions, UI |
| **Camera2D** | 2D camera | Follow player, zoom |

## Adding Interactive Objects

### Example: Wall

```
WallsLayer/
└── Wall_North (StaticBody2D)
    ├── CollisionShape2D
    │   └── Shape: RectangleShape2D (32x128)
    └── Sprite2D
        └── Texture: wall_stone.png
```

### Example: Enemy Spawn Point

```
EnemySpawns/
└── SpawnPoint_01 (Marker2D)
    └── Position: (100, 50)
```

### Example: Treasure Chest

```
LootSpawns/
└── Chest_Gold (Area2D)
    ├── CollisionShape2D
    │   └── Shape: RectangleShape2D (32x32)
    ├── Sprite2D
    │   └── Texture: chest_closed.png
    └── Script
        └── chest_interaction.gd
```

### Example: Door/Portal

```
PropsLayer/
└── Portal_Exit (Area2D)
    ├── CollisionShape2D
    ├── AnimatedSprite2D
    │   └── Animation: portal_swirl
    └── Script
        └── portal_teleport.gd
```

## Layer Organization Best Practices

### Main Scene Layers
1. **GroundLayer** - Lowest: Floor tiles, grass, water
2. **PropsLayer** - Middle: Trees, rocks, decorations (behind player)
3. **Player** - Above props
4. **TopPropsLayer** - Highest: Overhangs, treetops (in front of player)
5. **UILayer** - Top: Health bars, tooltips

### Sorting/Z-Index
- Use `z_index` property to control draw order
- Higher values draw on top
- Default is 0
- Range: -4096 to 4096

Example:
```
GroundLayer: z_index = -100
PropsLayer: z_index = 0
Player: z_index = 10
TopPropsLayer: z_index = 20
UILayer: z_index = 100
```

## Collision Layers

The project has these physics layers configured:

| Layer # | Name | Purpose |
|---------|------|---------|
| 1 | World | Terrain, walls, obstacles |
| 2 | Player | Player character |
| 3 | Items | Pickable items |
| 4 | Projectiles | Arrows, bullets |
| 5 | Enemies | Enemy characters |
| 6 | Triggers | Detection zones |
| 7 | Interactables | Chests, doors, NPCs |

### Setting Collision in Code
```gdscript
# Make a wall collide only with player and enemies
static_body.collision_layer = 1  # World layer
static_body.collision_mask = 6   # Layers 2 (player) + 4 (enemies)
```

### Setting Collision in Editor
1. Select the node (e.g., StaticBody2D)
2. Inspector → Collision
3. Check appropriate Layer and Mask boxes

## Tips for Scene Building

### Performance
- ✅ Group similar objects under parent Node2D
- ✅ Use StaticBody2D for non-moving objects
- ✅ Use Area2D for triggers (lighter than bodies)
- ❌ Don't add collision to purely visual objects

### Organization
- ✅ Name nodes descriptively: "Wall_North", "Tree_Oak_01"
- ✅ Use folders (Node2D containers) to group: "Trees", "Buildings"
- ✅ Keep layers consistent across scenes
- ✅ Use Marker2D for spawn points (not visible in game)

### Testing
- Press **F6** to test current scene alone
- Press **F5** to test in full game context
- Check Output panel (bottom) for errors

### Workflow
1. Build in editor
2. Test frequently (F5/F6)
3. Save often (Ctrl+S)
4. Organize as you go
5. Use version control (Git)

---

**Ready to build?** Open `crimson_isles_main.tscn` in Godot! 🎮
