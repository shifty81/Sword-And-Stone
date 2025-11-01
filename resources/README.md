# Resources Directory

This directory contains Godot resource files (.tres) that define game data with proper metadata structure.

## Structure

### items/
Contains item resource files with unique UIDs (UIDs). Each item has:
- **Script reference**: Links to the corresponding .gd script in resources/items/
- **Properties**: Item name, type, quality, description, stats, etc.
- **UID**: Unique identifier for Godot's resource tracking system

Example items:
- `iron_sword.tres` (UID: uid://c8yhvnj4xk2p5)
- `steel_longsword.tres` (UID: uid://bq3m7n8xr4k1w)
- `battle_axe.tres` (UID: uid://dpx2v5k9mn6qr)
- `iron_chestplate.tres` (UID: uid://ct4r8w6xp2h9n)

### recipes/
Contains crafting recipe resource files. Each recipe defines:
- **Recipe name**: Display name for the recipe
- **Required materials**: Array of items and amounts needed
- **Result item**: Reference to the item resource created
- **Crafting time**: Time in seconds to craft
- **Required station**: Which crafting station is needed (Workbench, Anvil, etc.)
- **Required skill level**: Minimum skill required to craft

Example recipes:
- `iron_sword_recipe.tres` (UID: uid://dk5p9wm2xv7hn)
- `steel_longsword_recipe.tres` (UID: uid://cqm8r4xt5y2pk)
- `battle_axe_recipe.tres` (UID: uid://b7xn3v9pm4kw2)
- `iron_chestplate_recipe.tres` (UID: uid://cy6k2n8xr9vpm)

## Metadata Structure

All .tres files follow Godot's resource format:
```
[gd_resource type="Resource" load_steps=N format=3 uid="uid://xxxxx"]

[ext_resource type="Script" path="res://path/to/script.gd" id="1"]

[resource]
script = ExtResource("1")
property_name = value
...
```

### Key Metadata Components:

1. **UID (Unique Identifier)**: Every resource has a unique UID that Godot uses for tracking and references
   - Format: `uid://[alphanumeric]`
   - Generated automatically by Godot or manually assigned
   - Must be unique across the entire project

2. **External Resources**: References to scripts and other resources
   - Scripts that define the resource's behavior
   - Other resources this resource depends on

3. **Properties**: Serialized values for all @export variables defined in the script
   - Enums are stored as integers (their ordinal value)
   - Resource references use ExtResource() notation

## Adding New Resources

When creating new items or recipes:

1. Create the script file (.gd) in the appropriate scripts directory
2. Create a corresponding .tres file with:
   - A unique UID (check existing UIDs to avoid conflicts)
   - Reference to the script
   - All necessary property values
3. Update this README with the new resource's UID

## UID Registry

### Items
- `uid://c8yhvnj4xk2p5` - Iron Sword
- `uid://bq3m7n8xr4k1w` - Steel Longsword
- `uid://dpx2v5k9mn6qr` - Battle Axe
- `uid://ct4r8w6xp2h9n` - Iron Chestplate

### Recipes
- `uid://dk5p9wm2xv7hn` - Iron Sword Recipe
- `uid://cqm8r4xt5y2pk` - Steel Longsword Recipe
- `uid://b7xn3v9pm4kw2` - Battle Axe Recipe
- `uid://cy6k2n8xr9vpm` - Iron Chestplate Recipe

## Best Practices

1. **Always use .tres files** for resource data instead of instantiating scripts directly
2. **Keep UIDs unique** - never reuse or duplicate UIDs
3. **Document UIDs** - add new UIDs to the registry in this README
4. **Reference properly** - use resource paths (res://) for all references
5. **Version control** - commit .tres files with their .gd counterparts
