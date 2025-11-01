# Physics System Documentation

## Overview

The Sword And Stone physics engine is built on top of Godot's robust built-in physics system. This implementation provides a comprehensive framework for physics-based gameplay including dynamic objects, projectiles, item drops, and environmental triggers.

## Architecture

### Core Components

1. **PhysicsManager** (Autoload Singleton)
   - Centralized physics management
   - Physics material definitions
   - Object registration and tracking
   - Helper functions for common physics operations

2. **Physics Layers**
   - Layer 1: World (terrain, static geometry)
   - Layer 2: Player
   - Layer 3: Items (dropped items, collectibles)
   - Layer 4: Projectiles (arrows, thrown objects)
   - Layer 5: Enemies (future implementation)
   - Layer 6: Triggers (physics areas)
   - Layer 7: Interactables (doors, levers, etc.)

3. **Physics Materials**
   - Stone: High friction (0.8), no bounce
   - Grass: Medium friction (0.6), no bounce
   - Ice: Very low friction (0.1), no bounce
   - Metal: Medium friction (0.5), some bounce (0.3)
   - Wood: Medium-high friction (0.7), small bounce (0.1)
   - Rubber: High friction (0.9), high bounce (0.8)

### Physics Classes

#### PhysicsItem
Physics-based item that can be picked up by the player.

**Features:**
- Auto-pickup when player is nearby
- Pickup delay to prevent instant collection
- Proper collision layer configuration
- Automatic registration with PhysicsManager

**Usage:**
```gdscript
var item = PhysicsItem.new()
item.item_name = "Iron Ore"
item.item_id = "iron_ore"
item.auto_pickup_radius = 2.0
get_tree().root.add_child(item)
```

#### Projectile
Physics-based projectile for arrows, thrown items, etc.

**Features:**
- Damage on impact
- Stick to surfaces option
- Automatic lifetime management
- Proper collision filtering
- Automatic rotation to face direction of travel

**Usage:**
```gdscript
var projectile = Projectile.new()
projectile.damage = 15.0
projectile.stick_to_surfaces = true
get_tree().root.add_child(projectile)
projectile.launch(direction, 30.0)
```

#### FallingBlock
Physics-based falling block similar to Minecraft's sand/gravel.

**Features:**
- Falls when unsupported
- Settles after period of inactivity
- Can convert back to static voxel
- Proper mass and physics material

**Usage:**
```gdscript
var falling_block = FallingBlock.new()
falling_block.voxel_type = VoxelType.Type.SAND
falling_block.position = block_position
get_tree().root.add_child(falling_block)
```

#### PhysicsTrigger
Area3D-based trigger for environmental effects.

**Trigger Types:**
- **Wind**: Apply continuous force in a direction
- **Damage**: Deal damage over time to objects inside
- **Heal**: Restore health over time
- **Bounce**: Apply impulse when entering
- **Teleport**: Move object to another location
- **SlowMotion**: Reduce velocity of objects inside

**Usage:**
```gdscript
var wind_zone = PhysicsTrigger.new()
wind_zone.trigger_type = "Wind"
wind_zone.trigger_direction = Vector3.UP
wind_zone.trigger_strength = 20.0
get_tree().root.add_child(wind_zone)
```

#### PhysicsDebugger
Visual debugging tool for physics objects.

**Features:**
- Show collision shapes
- Display velocity vectors
- Visualize centers of mass
- Only active in debug builds

**Usage:**
```gdscript
var debugger = PhysicsDebugger.new()
debugger.enabled = true
debugger.show_velocities = true
get_tree().root.add_child(debugger)
```

## PhysicsManager API

### Physics Material Functions

```gdscript
# Get a predefined physics material
var stone_mat = PhysicsManager.get_physics_material("stone")

# Available materials: "stone", "grass", "ice", "metal", "wood", "rubber"
```

### Layer Management

```gdscript
# Set collision layer and mask on an object
PhysicsManager.set_collision_layer_and_mask(
    object,
    PhysicsManager.LAYER_ITEMS,
    PhysicsManager.LAYER_WORLD
)

# Get layer mask bit for a layer number
var mask = PhysicsManager.get_layer_mask(PhysicsManager.LAYER_PLAYER)
```

### Object Creation

```gdscript
# Create a physics-based item drop
var item = PhysicsManager.create_item_drop(position, item_type)
get_tree().root.add_child(item)

# Create a projectile
var projectile = PhysicsManager.create_projectile(
    start_position,
    direction,
    speed
)
get_tree().root.add_child(projectile)

# Create a falling block
var block = PhysicsManager.create_falling_block(position, voxel_type)
get_tree().root.add_child(block)
```

### Object Tracking

```gdscript
# Register a custom RigidBody3D
PhysicsManager.register_rigid_body(my_body)

# Register a custom Area3D
PhysicsManager.register_area(my_area)

# Get counts of active physics objects
var counts = PhysicsManager.get_active_physics_objects_count()
print("Active rigid bodies: ", counts["rigid_bodies"])
print("Active areas: ", counts["areas"])

# Cleanup sleeping objects to save performance
PhysicsManager.cleanup_sleeping_objects()
```

## Integration with Existing Systems

### Player Controller
The player uses `CharacterBody3D` and is configured to:
- Collide with World layer (terrain)
- Collide with Items layer (for pickup)
- Use Layer 2 (Player)

### Chunk System
Chunks use `StaticBody3D` and are configured to:
- Use Layer 1 (World)
- No collision mask (they only receive collisions)
- Create trimesh collision shapes from voxel geometry

### World Generator
Can spawn physics objects during world generation:
```gdscript
# Example: Spawn item drops on surface
if should_spawn_item:
    var item = PhysicsManager.create_item_drop(surface_position, item_type)
    world_node.add_child(item)
```

## Performance Considerations

### Optimization Tips

1. **Limit Active Physics Objects**
   - Use `PhysicsManager.cleanup_sleeping_objects()` periodically
   - Remove physics objects that are far from the player
   - Pool frequently created/destroyed objects

2. **Collision Layer Filtering**
   - Only set necessary collision layers
   - Use specific masks to avoid unnecessary collision checks
   - Items should not collide with other items

3. **Physics Material Usage**
   - Reuse physics materials from PhysicsManager
   - Don't create new PhysicsMaterial instances unnecessarily

4. **Contact Monitoring**
   - Only enable `contact_monitor` when needed
   - Set `max_contacts_reported` to minimum required

5. **Sleeping Objects**
   - Let objects sleep when possible (default behavior)
   - Don't wake sleeping objects unnecessarily
   - Use the settle system for falling blocks

### Performance Monitoring

```gdscript
# Check active object counts
var counts = PhysicsManager.get_active_physics_objects_count()
print("Physics objects: ", counts)

# Use PhysicsDebugger to visualize performance issues
var debugger = PhysicsDebugger.new()
debugger.enabled = true
```

## Project Settings

### Physics Configuration (project.godot)

```ini
[physics]
3d/default_gravity=20.0
3d/default_linear_damp=0.1
3d/default_angular_damp=0.1

[layer_names]
3d_physics/layer_1="World"
3d_physics/layer_2="Player"
3d_physics/layer_3="Items"
3d_physics/layer_4="Projectiles"
3d_physics/layer_5="Enemies"
3d_physics/layer_6="Triggers"
3d_physics/layer_7="Interactables"
```

## Usage Examples

### Creating a Throwable Item

```gdscript
extends PhysicsItem
class_name ThrowableItem

func throw(direction: Vector3, force: float):
    linear_velocity = direction.normalized() * force
    # Optionally change to projectile layer
    if PhysicsManager:
        PhysicsManager.set_collision_layer_and_mask(
            self,
            PhysicsManager.LAYER_PROJECTILES,
            PhysicsManager.LAYER_WORLD | PhysicsManager.LAYER_ENEMIES
        )
```

### Creating a Damage Zone

```gdscript
# Create an area that damages players and enemies
var damage_zone = PhysicsTrigger.new()
damage_zone.trigger_type = "Damage"
damage_zone.trigger_strength = 10.0
damage_zone.affect_player = true
damage_zone.position = Vector3(0, 10, 0)

# Add collision shape
var collision = CollisionShape3D.new()
var box = BoxShape3D.new()
box.size = Vector3(5, 2, 5)
collision.shape = box
damage_zone.add_child(collision)

add_child(damage_zone)
```

### Creating Falling Sand/Gravel

```gdscript
# When a block is broken, check if blocks above should fall
func check_falling_blocks(broken_pos: Vector3i):
    var above_pos = broken_pos + Vector3i.UP
    var voxel_above = get_voxel(above_pos)
    
    if VoxelType.should_fall(voxel_above):
        # Remove voxel from world
        set_voxel(above_pos, VoxelType.Type.AIR)
        
        # Create falling block
        var falling = PhysicsManager.create_falling_block(
            Vector3(above_pos),
            voxel_above
        )
        get_tree().root.add_child(falling)
```

### Adding Physics to Player Actions

```gdscript
# In player_controller.gd
func throw_item():
    var projectile = Projectile.new()
    projectile.position = camera.global_position
    projectile.damage = 20.0
    get_tree().root.add_child(projectile)
    
    # Launch forward
    var forward = -camera.global_transform.basis.z
    projectile.launch(forward, 25.0)
```

## Future Enhancements

Planned features for the physics system:

1. **Rope/Chain Physics** - Using joints and constraints
2. **Destructible Objects** - Breaking apart on impact
3. **Vehicle Physics** - Carts, boats, etc.
4. **Ragdoll Physics** - For character deaths
5. **Cloth Simulation** - Capes, banners
6. **Water Physics** - Buoyancy and flow
7. **Explosion Forces** - Radial impulses
8. **Physics-Based Puzzles** - Levers, pressure plates, etc.

## Troubleshooting

### Objects Fall Through World
- Check collision layers are properly set
- Ensure chunks have collision shapes generated
- Verify object is on correct layer

### Objects Don't Collide
- Check layer masks are configured correctly
- Use PhysicsDebugger to visualize collision shapes
- Verify collision shapes exist and have proper size

### Performance Issues
- Use `PhysicsManager.cleanup_sleeping_objects()`
- Reduce number of active physics objects
- Check if too many objects have `contact_monitor` enabled
- Use simpler collision shapes when possible

### Objects Behave Strangely
- Check mass and physics material settings
- Verify gravity scale is appropriate
- Ensure linear/angular damping is set correctly
- Check for conflicting forces being applied

## Credits

Built using Godot 4.x's powerful built-in physics engine (Godot Physics / Jolt Physics).
