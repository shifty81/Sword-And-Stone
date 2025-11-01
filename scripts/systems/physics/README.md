# Physics System

This directory contains the core physics components for Sword And Stone.

## Files

- **physics_item.gd** - Physics-based pickupable items
- **projectile.gd** - Physics-based projectiles (arrows, thrown objects)
- **falling_block.gd** - Falling blocks like sand/gravel
- **physics_trigger.gd** - Environmental trigger areas
- **physics_debugger.gd** - Visual debugging tool

## Usage

See [docs/PHYSICS_SYSTEM.md](../../../docs/PHYSICS_SYSTEM.md) for comprehensive documentation.

### Quick Example

```gdscript
# Spawn a physics item
var item = PhysicsManager.create_item_drop(position, item_type)
get_tree().root.add_child(item)

# Spawn a projectile
var projectile = PhysicsManager.create_projectile(start_pos, direction, 30.0)
get_tree().root.add_child(projectile)

# Create a trigger zone
var trigger = PhysicsTrigger.new()
trigger.trigger_type = "Wind"
trigger.trigger_direction = Vector3.UP
add_child(trigger)
```

## Integration

All physics objects are automatically registered with PhysicsManager for tracking and management.
