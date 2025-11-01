# Copilot Instructions for Sword And Stone

## Project Overview

Sword And Stone is a 3D voxel survival game inspired by Vintage Story, built with Godot 4.x. The game features procedurally generated worlds with continents and rivers, resource gathering, and an innovative voxel-based smithing system for crafting medieval weapons and armor. The project uses a custom cel-shaded visual style with Borderlands-inspired thick outlines.

**Key Features:**
- Procedural world generation with continents, rivers, and varied biomes
- Fully destructible and buildable voxel-based terrain
- Quality-based crafting system (Poor to Legendary quality items)
- Voxel smithing mechanics where players shape hot metal on an anvil
- First-person exploration with inventory management
- Custom cel-shaded graphics with stylized visuals

## Tech Stack

### Engine and Language
- **Engine**: Godot 4.2 or newer
- **Primary Language**: GDScript (Godot's Python-like scripting language)
- **Graphics**: Custom shaders for cel-shading with thick outlines
- **Rendering**: Forward+ renderer

### Project Structure
```
├── scripts/
│   ├── world_generation/   # Procedural world generation engine
│   ├── voxel/              # Voxel and chunk management
│   ├── player/             # Player controller and mechanics
│   ├── crafting/           # Crafting stations and recipes
│   └── items/              # Item, weapon, and armor classes
├── scenes/                 # Godot scene files (.tscn)
├── shaders/                # Custom shaders (cel-shading)
├── materials/              # Material resources
└── resources/              # Game data and assets
```

## Coding Guidelines

### GDScript Standards

1. **Naming Conventions**
   - Use `snake_case` for variables, functions, and file names
   - Use `PascalCase` for class names
   - Use `UPPER_SNAKE_CASE` for constants and enums
   - Example: `var player_position`, `func update_chunk()`, `const MAX_CHUNKS = 100`

2. **Code Organization**
   - Group related functions together
   - Place constants at the top of the file
   - Use `@export` for inspector-exposed variables
   - Use `@onready` for node references
   - Keep functions focused and single-purpose

3. **Documentation**
   - Add comments for complex algorithms (especially world generation and voxel meshing)
   - Document function parameters and return values for non-obvious functions
   - Keep comments concise and meaningful
   - Update comments when code changes

4. **Type Hints**
   - Use type hints for function parameters and return values
   - Example: `func get_voxel(x: int, y: int, z: int) -> int:`
   - This improves code clarity and catches errors early

### Performance Considerations

1. **Chunk Management**
   - Only generate chunks within render distance
   - Cache computed values to avoid recalculation
   - Use object pooling for frequently created/destroyed objects
   - Batch mesh updates when possible

2. **Optimization Priorities**
   - Voxel mesh generation is performance-critical
   - World generation should be efficient but can run at startup
   - Minimize per-frame calculations in player controller
   - Use Godot's profiler to identify bottlenecks

### Voxel System Guidelines

1. **Chunk Operations**
   - Chunks are 16x16x16 voxel segments
   - Only generate visible faces (hidden faces between solid voxels should be culled)
   - Update chunk meshes only when voxels change
   - Properly handle chunk boundaries to avoid visual artifacts

2. **Voxel Types**
   - Add new voxel types to the enum in `voxel_type.gd`
   - Provide color, hardness, and transparency properties
   - Consider mining speed and tool effectiveness

### Crafting System Guidelines

1. **Quality System**
   - Items have 6 quality levels: Poor (0.7x), Common (1.0x), Good (1.3x), Excellent (1.6x), Masterwork (2.0x), Legendary (2.5x)
   - Quality affects item stats multiplicatively
   - Quality is determined by player skill, crafting accuracy, and random chance

2. **Adding Recipes**
   - Create `CraftingRecipe` resources
   - Define required materials with quantities
   - Specify crafting station type
   - Set result item with base quality

## Architecture Patterns

### World Generation Flow
1. Continental noise determines landmasses vs ocean
2. Terrain noise adds height variation with multiple octaves
3. Rivers flow downhill from highlands to ocean using pathfinding
4. Chunks generate on-demand around the player

### Voxel Mesh Generation
- Use greedy meshing algorithm (future optimization)
- Generate only exposed faces
- Create collision shapes from mesh data
- Update meshes asynchronously to avoid frame drops

### Player Interaction
- Raycasting for voxel selection
- Input handling through Godot's Input system
- Mouse capture for look controls (ESC to toggle cursor)

## Common Patterns

### Adding a New Voxel Type
```gdscript
# In voxel_type.gd
enum VoxelType {
    AIR,
    GRASS,
    DIRT,
    STONE,
    YOUR_NEW_TYPE,  # Add here
}

# Add color
func get_voxel_color(type: VoxelType) -> Color:
    match type:
        VoxelType.YOUR_NEW_TYPE:
            return Color(1.0, 0.5, 0.0)  # Orange color
        # ... other cases

# Add hardness
func get_hardness(type: VoxelType) -> float:
    match type:
        VoxelType.YOUR_NEW_TYPE:
            return 2.5  # Mining difficulty
        # ... other cases
```

### Creating a New Item Class
```gdscript
extends Item
class_name YourItem

func _init():
    item_name = "Your Item"
    description = "Item description"
    quality = Quality.COMMON
    # Add item-specific properties
```

### Chunk Coordinate Conversions
```gdscript
# World position to chunk position
var chunk_pos = Vector3i(
    floor(world_pos.x / CHUNK_SIZE),
    floor(world_pos.y / CHUNK_SIZE),
    floor(world_pos.z / CHUNK_SIZE)
)

# Voxel position within chunk
var local_pos = Vector3i(
    int(world_pos.x) % CHUNK_SIZE,
    int(world_pos.y) % CHUNK_SIZE,
    int(world_pos.z) % CHUNK_SIZE
)
```

## Testing Guidelines

### Manual Testing Checklist
- Player movement and camera controls work smoothly
- Voxels can be broken and placed correctly
- No visual glitches at chunk borders
- Rivers generate and flow properly to ocean
- Frame rate remains stable (target >30fps)
- Crafting stations function correctly

### Common Issues to Check
- **Chunks not generating**: Verify player position and render distance settings
- **Missing faces**: Check neighbor voxel detection in mesh generation
- **Performance drops**: Profile and optimize mesh generation, reduce render distance
- **River artifacts**: Adjust river width and generation parameters

## Do's and Don'ts

### Do:
✅ Use Godot's built-in types (Vector3, Vector2, Color, etc.)  
✅ Leverage signals for event-driven communication between systems  
✅ Use `@export` variables for tweakable parameters  
✅ Test changes in the Godot editor with F5 or the Play button  
✅ Keep functions under 50 lines when possible  
✅ Use early returns to reduce nesting  
✅ Profile performance-critical code paths  

### Don't:
❌ Don't use C# code (this project uses GDScript only)  
❌ Don't create circular dependencies between scripts  
❌ Don't generate meshes every frame (cache and update only on change)  
❌ Don't ignore existing code style and patterns  
❌ Don't add external dependencies without careful consideration  
❌ Don't remove or modify shader code without understanding the cel-shading effect  

## Key Documentation References

- **[README.md](../README.md)**: Project overview, features, and getting started
- **[ARCHITECTURE.md](../ARCHITECTURE.md)**: Detailed system architecture and design decisions
- **[DEVELOPMENT.md](../DEVELOPMENT.md)**: Development guide with implementation details
- **[IMPLEMENTATION.md](../IMPLEMENTATION.md)**: Implementation notes and technical specifics
- **[QUICKSTART.md](../QUICKSTART.md)**: Quick reference for common tasks

## Future Development Priorities

1. Combat system with melee and ranged weapons
2. Creature AI for hostile and passive mobs
3. Multiplayer support with server-client architecture
4. World saving and loading system
5. Greedy meshing optimization for better performance
6. Chunk unloading system for memory management
7. Biome system based on temperature and humidity
8. Procedural structures (dungeons, villages)

## Notes for AI Assistants

- This is a Godot game project, so all code should be in GDScript (file extension `.gd`)
- Scene files (`.tscn`) are text-based and can be edited, but prefer using the Godot editor for scene changes
- The voxel system is performance-critical - always consider optimization
- The project uses a custom cel-shader for its distinctive art style - preserve this aesthetic
- When suggesting changes, consider the procedural generation system's complexity
- Test any player control changes carefully to maintain smooth gameplay feel
