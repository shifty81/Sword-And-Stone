# Metadata Structure Implementation

## Overview

This document describes the metadata structure implementation for the Sword And Stone project, completing the requirement to add proper metadata for all resources in the project.

## What is Metadata in Godot?

In Godot 4.x, metadata refers to the structured information that describes resources, scenes, and assets. The primary metadata system includes:

1. **UIDs (Unique Identifiers)**: Unique resource identifiers for tracking and referencing
2. **Resource Files (.tres)**: Text-based resource files with serialized properties
3. **Scene Files (.tscn)**: Scene descriptions with node hierarchy and properties
4. **Class Names**: Global class registration via `class_name` declarations
5. **Documentation**: Inline documentation using `##` comments

## Implementation Details

### 1. Resource Files (.tres)

Created proper `.tres` resource files for all game items and recipes with unique UIDs:

#### Item Resources (resources/items/)
Each item now has a `.tres` file that:
- References the corresponding `.gd` script
- Defines all item properties (name, type, quality, stats)
- Has a unique UID for Godot's resource tracking
- Can be loaded and instantiated through Godot's resource system

**Files Created:**
- `iron_sword.tres` - Basic iron sword (UID: uid://c8yhvnj4xk2p5)
- `steel_longsword.tres` - Advanced steel sword (UID: uid://bq3m7n8xr4k1w)
- `battle_axe.tres` - Heavy combat axe (UID: uid://dpx2v5k9mn6qr)
- `iron_chestplate.tres` - Iron armor piece (UID: uid://ct4r8w6xp2h9n)

#### Recipe Resources (resources/recipes/)
Crafting recipes that define how items are created:
- Reference both the recipe logic script and result item
- Define crafting requirements (materials, time, station, skill)
- Have unique UIDs for recipe identification

**Files Created:**
- `iron_sword_recipe.tres` (UID: uid://dk5p9wm2xv7hn)
- `steel_longsword_recipe.tres` (UID: uid://cqm8r4xt5y2pk)
- `battle_axe_recipe.tres` (UID: uid://b7xn3v9pm4kw2)
- `iron_chestplate_recipe.tres` (UID: uid://cy6k2n8xr9vpm)

### 2. UID Registry

All UIDs are documented in `resources/README.md` to prevent conflicts and provide a central reference. UIDs follow the format `uid://[alphanumeric]` and must be unique across the project.

### 3. Resource Format Structure

Every `.tres` file follows this structure:

```godot
[gd_resource type="Resource" load_steps=N format=3 uid="uid://xxxxx"]

[ext_resource type="Script" path="res://path/to/script.gd" id="1"]
[ext_resource type="Resource" uid="uid://yyyyy" path="res://path/to/resource.tres" id="2"]

[resource]
script = ExtResource("1")
property_name = value
another_property = value
reference_property = ExtResource("2")
```

Key components:
- **Header**: Defines resource type, format version, and UID
- **External Resources**: Links to dependencies (scripts, other resources)
- **Resource Section**: Serialized property values

### 4. Class Names and Documentation

All script files already have:
- `class_name` declarations for global class registration
- Documentation comments (`##`) describing their purpose
- Proper inheritance hierarchy

## Benefits of This Structure

1. **Resource Tracking**: Godot can track and manage resources via UIDs
2. **Data Separation**: Game data (stats, values) separated from logic (scripts)
3. **Easy Modification**: Designers can modify `.tres` files without touching code
4. **Version Control**: Text-based `.tres` files work well with git
5. **Reusability**: Resources can be referenced and reused across scenes
6. **Type Safety**: Godot validates resource types and properties

## Usage Examples

### Loading a Resource
```gdscript
# Load by path
var sword = load("res://resources/items/iron_sword.tres")

# Load by UID (Godot 4.x)
var sword = load("uid://c8yhvnj4xk2p5")

# Use in scene
@export var default_weapon: Weapon = preload("res://resources/items/iron_sword.tres")
```

### Creating New Resources

1. **Create the script** (if needed):
```gdscript
extends Weapon
class_name BronzeSword

func _init():
    item_name = "Bronze Sword"
    base_damage = 12.0
    # ... other properties
```

2. **Create the .tres file**:
```godot
[gd_resource type="Resource" load_steps=2 format=3 uid="uid://newuniqueid"]

[ext_resource type="Script" path="res://path/to/bronze_sword.gd" id="1"]

[resource]
script = ExtResource("1")
```

3. **Register the UID** in `resources/README.md`

## Files Modified

### New Files Created:
- `resources/README.md` - Metadata documentation and UID registry
- `resources/items/*.tres` (4 files) - Item resource definitions
- `resources/recipes/*.tres` (4 files) - Recipe resource definitions
- `METADATA_IMPLEMENTATION.md` (this file) - Implementation documentation

### Existing Files:
- All `.gd` scripts remain unchanged (they already had proper structure)
- `.tscn` scene files remain unchanged (they already had UIDs)

## Maintenance

When adding new items or recipes:

1. Create the `.gd` script with proper `class_name` and documentation
2. Create a corresponding `.tres` file with a unique UID
3. Add the UID to the registry in `resources/README.md`
4. Test loading the resource in Godot editor

## Future Enhancements

Potential metadata improvements for the future:

1. **Icon Resources**: Add @icon annotations to class_name declarations
2. **Localization**: Add translation keys for item names/descriptions
3. **Asset Metadata**: Create .import configuration for custom import settings
4. **Audio Resources**: Add sound effect and music resource files
5. **Material Resources**: Expand material library with proper UIDs
6. **Shader Parameters**: Create shader parameter presets as resources

## Conclusion

The metadata structure is now complete and follows Godot 4.x best practices. All items and recipes have proper resource files with unique UIDs, enabling better resource management, tracking, and modification workflows.
