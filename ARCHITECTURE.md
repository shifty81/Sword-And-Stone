# System Architecture Diagram

## Overview

```
┌─────────────────────────────────────────────────────────────┐
│                         Main Scene                          │
│  ┌────────────┐  ┌──────────────┐  ┌────────────────────┐  │
│  │   Player   │  │    World     │  │   Environment &   │  │
│  │ Controller │  │  Generator   │  │      Lighting     │  │
│  └────────────┘  └──────────────┘  └────────────────────┘  │
│         │                │                      │            │
│         │                │                      │            │
│    ┌────▼────┐    ┌─────▼─────┐           ┌───▼────┐       │
│    │  Camera │    │   Chunks  │           │  Light │       │
│    └─────────┘    └───────────┘           └────────┘       │
└─────────────────────────────────────────────────────────────┘
```

## Component Relationships

### World Generation Flow
```
WorldGenerator
    ├── initialize_noise()
    │   ├── Create continent_noise (FastNoiseLite)
    │   └── Create terrain_noise (FastNoiseLite)
    │
    ├── generate_continents()
    │   └── (Happens during chunk generation)
    │
    ├── generate_rivers()
    │   └── Creates 50+ River instances
    │       └── River.generate_river_path()
    │           └── Follow downhill gradient
    │
    └── _process()
        └── generate_chunk() for each position
            └── Creates Chunk instance
                ├── Initialize voxel array
                ├── generate_voxels()
                │   └── get_voxel_type() for each position
                │       ├── get_terrain_height()
                │       │   ├── get_continent_value()
                │       │   └── Check river distances
                │       └── Return voxel type
                └── generate_mesh()
                    └── Create visible geometry
```

### Player Interaction Flow
```
PlayerController
    ├── _physics_process()
    │   ├── handle_movement()
    │   │   ├── Input.get_vector()
    │   │   ├── Apply velocity
    │   │   └── move_and_slide()
    │   │
    │   └── handle_interaction()
    │       └── Physics raycast
    │           ├── Left Click → break_voxel()
    │           │   └── chunk.set_voxel(AIR)
    │           └── Right Click → place_voxel()
    │               └── chunk.set_voxel(STONE)
    │
    └── _unhandled_input()
        └── Mouse motion → rotate camera
```

### Crafting System Flow
```
CraftingStation (Base)
    ├── can_craft() → Check materials
    ├── start_crafting() → Remove materials
    └── complete_crafting() → Create item with quality

AnvilStation (Extends CraftingStation)
    ├── smithing_voxels[16][16][16]
    ├── start_smithing()
    │   └── load_smithing_template()
    │       └── Create hot metal shape
    │
    ├── hammer_voxel()
    │   ├── Move voxel in direction
    │   └── update_smithing_quality()
    │       └── calculate_shape_match()
    │
    └── finish_smithing()
        └── Create item with calculated quality
```

### Item Hierarchy
```
Item (Base Resource)
    ├── Properties
    │   ├── item_name, description
    │   ├── quality (Poor to Legendary)
    │   ├── durability, max_durability
    │   └── max_stack_size
    │
    ├── Weapon (Extends Item)
    │   ├── weapon_type (Sword, Axe, etc.)
    │   ├── base_damage
    │   ├── attack_speed
    │   └── get_damage() → base * quality_multiplier
    │
    └── Armor (Extends Item)
        ├── armor_type (Helmet, Chestplate, etc.)
        ├── armor_material (Leather, Iron, Steel)
        ├── base_defense
        └── get_defense() → base * quality_multiplier
```

## Data Flow Diagrams

### Chunk Generation
```
Player Position → Calculate Chunk Coords → Check if exists
                                                    ↓
                                                   NO
                                                    ↓
                                        Create new Chunk node
                                                    ↓
                                        For each voxel position:
                                                    ↓
                                    WorldGenerator.get_voxel_type()
                                                    ↓
                                            ┌──────┴──────┐
                                            ↓             ↓
                                    get_terrain_height  Above/Below?
                                            ↓             ↓
                              ┌─────────────┴─────────┐   ↓
                              ↓                       ↓   ↓
                      get_continent_value    Check rivers ↓
                              ↓                       ↓   ↓
                        Continental or      River depth  ↓
                        oceanic terrain          ↓       ↓
                              └──────────────────┴───────┘
                                            ↓
                                    Return VoxelType
                                            ↓
                                    Store in voxel array
                                            ↓
                                    generate_mesh()
                                            ↓
                                    Visible chunk!
```

### Voxel Interaction
```
Player clicks → Raycast from camera → Hit chunk?
                                           ↓
                                          YES
                                           ↓
                        ┌──────────────────┴──────────────┐
                        ↓                                  ↓
                  Left Click                         Right Click
                        ↓                                  ↓
                Calculate hit position             Calculate adjacent
                - normal * 0.5                     + normal * 0.5
                        ↓                                  ↓
                Convert to local coords           Convert to local coords
                        ↓                                  ↓
                chunk.set_voxel(x,y,z,AIR)        chunk.set_voxel(x,y,z,STONE)
                        └──────────────────┬───────────────┘
                                           ↓
                                   generate_mesh()
                                           ↓
                                   Update collision
                                           ↓
                                   Visual update!
```

## Threading Model

### Current: Single-Threaded
```
Main Thread
    ├── Process Input
    ├── Update Physics
    ├── Generate Chunks (blocking)
    ├── Render Frame
    └── Repeat
```

### Future: Multi-Threaded (Planned)
```
Main Thread                  Worker Threads
    ├── Process Input             ├── Thread 1: Generate chunk voxels
    ├── Update Physics            ├── Thread 2: Generate chunk voxels
    ├── Request chunks ──────────►├── Thread 3: Generate meshes
    ├── Receive completed ◄───────┤
    ├── Apply meshes              └── Queue system
    ├── Render Frame
    └── Repeat
```

## Memory Layout

### Chunk Storage
```
chunks: Dictionary {
    Vector3i(0, 0, 0): Chunk {
        voxels: Array[16][16][16] of VoxelType
        mesh_instance: MeshInstance3D
        collision_shape: CollisionShape3D
    },
    Vector3i(1, 0, 0): Chunk { ... },
    ...
}
```

### Voxel Array (per chunk)
```
voxels[x][y][z] = VoxelType enum

Memory per chunk:
16 × 16 × 16 = 4,096 voxels
Each voxel = 1 byte (enum)
Total = ~4 KB per chunk (minimal!)
```

## Signal/Event System

### Events and Listeners
```
CraftingStation
    signals:
        ↓ crafting_started(recipe)
        ↓ crafting_completed(item)
        ↓ crafting_failed()
            ↓
        ┌───┴───┐
        ↓       ↓
       UI    Sound

Inventory
    signals:
        ↓ inventory_changed()
        ↓ item_added(item, amount)
        ↓ item_removed(item, amount)
            ↓
        ┌───┴───┐
        ↓       ↓
      HUD    Stats

GameManager
    signals:
        ↓ game_paused()
        ↓ game_resumed()
            ↓
        ┌───┴───┐
        ↓       ↓
      Menu    Time
```

## Rendering Pipeline

### Chunk Rendering
```
For each chunk in view:
    1. Check frustum culling (Godot automatic)
    2. Draw mesh with vertex colors
    3. Apply cel-shader
        ├── Calculate lighting (quantized)
        ├── Add rim lighting
        ├── Add specular highlight
        └── Draw outline
    4. Update shadows (DirectionalLight3D)
```

### Shader Pipeline
```
Vertex Shader
    ↓
    Pass world position & normal
    ↓
Fragment Shader
    ├── Calculate view direction
    ├── Quantize lighting (cel levels)
    ├── Add rim effect
    ├── Add specular
    ├── Detect edges (outline)
    └── Output final color
```

## Scale and Performance

### Render Distance Impact
```
Render Distance = 6 (default)
Chunks loaded = (2*6+1)² × 1 = 169 chunks
Voxels active = 169 × 4,096 = 692,224 voxels

Memory usage:
- Voxel data: 169 × 4KB = ~676 KB
- Mesh data: Varies by complexity
- Total: ~10-50 MB (reasonable)
```

### Performance Targets
```
60 FPS:  Generate 1 chunk per frame max
30 FPS:  Generate 2-3 chunks per frame
15 FPS:  Too many chunks generating

Solution: Stagger generation across frames
```

## Extension Points

### Adding New Systems
```
New Voxel Type
    ↓ Add to VoxelType enum
    ↓ Add color in get_voxel_color()
    ↓ Add hardness in get_hardness()
    ↓ Update world generation logic
    ↓ Done!

New Item Type
    ↓ Create class extending Item
    ↓ Add specific properties
    ↓ Create resource instances
    ↓ Add to crafting recipes
    ↓ Done!

New Crafting Station
    ↓ Create class extending CraftingStation
    ↓ Override crafting logic
    ↓ Add specific mechanics
    ↓ Create scene with 3D model
    ↓ Done!
```

This architecture provides a clean, modular foundation that's easy to extend and maintain!
