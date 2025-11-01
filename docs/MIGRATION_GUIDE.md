# Project Restructure Migration Guide

This document explains the complete restructuring of the Sword And Stone project to follow Godot 4.x best practices.

## Summary of Changes

### Primary Objective
Restructure the entire project to follow Godot Engine's recommended directory structure and best practices, making it more maintainable, scalable, and professional.

### Secondary Objective
Fix the parse error in `world_generator.gd` line 165 that was preventing the project from compiling.

## Parse Error Fix

**Issue:** GDScript parser error at line 165 in `world_generator.gd`
```gdscript
ERROR: Expected expression after "/" operator.
```

**Root Cause:** The `//` operator (integer division) was being misinterpreted, especially when combined with a negative sign.

**Solution:** Replaced `//` operator with explicit `int()` function calls:
```gdscript
# Before (line 165-166):
var min_chunk_y = -(world_height_in_chunks // 2)
var max_chunk_y = (world_height_in_chunks // 2) - 1

# After:
var min_chunk_y = -int(world_height_in_chunks / 2)
var max_chunk_y = int(world_height_in_chunks / 2) - 1
```

**Result:** Parse error resolved, all dependent scripts now compile successfully.

## Directory Structure Changes

### Before Restructure
```
Sword-And-Stone/
├── materials/cel_material.tres
├── resources/items/
├── resources/recipes/
├── scenes/main.tscn
├── scenes/hud.tscn
├── scripts/
│   ├── crafting/
│   ├── items/
│   ├── player/
│   ├── ui/
│   ├── voxel/
│   ├── world_generation/
│   └── game_manager.gd
├── shaders/
├── ARCHITECTURE.md
├── DEVELOPMENT.md
└── ... (other docs in root)
```

### After Restructure
```
Sword-And-Stone/
├── assets/                    # NEW: Future game assets
│   ├── audio/
│   ├── fonts/
│   ├── models/
│   ├── sprites/
│   ├── textures/
│   └── vfx/
├── docs/                      # MOVED: Centralized documentation
│   ├── ARCHITECTURE.md
│   ├── DEVELOPMENT.md
│   ├── PROJECT_STRUCTURE.md   # NEW
│   └── ... (all docs)
├── resources/
│   ├── items/
│   ├── materials/             # MOVED from /materials
│   ├── recipes/
│   └── themes/                # NEW
├── scenes/
│   ├── main/main.tscn        # MOVED & RENAMED
│   ├── ui/hud/hud.tscn       # MOVED
│   ├── entities/             # NEW
│   └── world/                # NEW
├── scripts/
│   ├── autoload/             # NEW: Singletons
│   │   └── game_manager.gd
│   ├── components/           # NEW: Reusable components
│   ├── entities/             # REORGANIZED
│   │   └── player/
│   ├── systems/              # REORGANIZED
│   │   ├── crafting/
│   │   ├── inventory/        # RENAMED from items/
│   │   ├── voxel/
│   │   └── world_generation/
│   ├── ui/
│   └── utils/                # NEW: Helper scripts
└── shaders/
```

## File Migrations

### Documentation
| Old Path | New Path |
|----------|----------|
| `/ARCHITECTURE.md` | `/docs/ARCHITECTURE.md` |
| `/BUGFIX_SUMMARY.md` | `/docs/BUGFIX_SUMMARY.md` |
| `/DEVELOPMENT.md` | `/docs/DEVELOPMENT.md` |
| `/IMPLEMENTATION.md` | `/docs/IMPLEMENTATION.md` |
| `/METADATA_IMPLEMENTATION.md` | `/docs/METADATA_IMPLEMENTATION.md` |
| `/PROJECT_SUMMARY.md` | `/docs/PROJECT_SUMMARY.md` |
| `/QUICKSTART.md` | `/docs/QUICKSTART.md` |
| `/WORLD_GENERATION_FIX.md` | `/docs/WORLD_GENERATION_FIX.md` |

### Materials
| Old Path | New Path |
|----------|----------|
| `/materials/cel_material.tres` | `/resources/materials/cel_material.tres` |

### Scenes
| Old Path | New Path |
|----------|----------|
| `/scenes/main.tscn` | `/scenes/main/main.tscn` |
| `/scenes/hud.tscn` | `/scenes/ui/hud/hud.tscn` |

### Scripts
| Old Path | New Path |
|----------|----------|
| `/scripts/game_manager.gd` | `/scripts/autoload/game_manager.gd` |
| `/scripts/player/player_controller.gd` | `/scripts/entities/player/player_controller.gd` |
| `/scripts/crafting/*` | `/scripts/systems/crafting/*` |
| `/scripts/items/*` | `/scripts/systems/inventory/*` |
| `/scripts/voxel/*` | `/scripts/systems/voxel/*` |
| `/scripts/world_generation/*` | `/scripts/systems/world_generation/*` |

## Path Reference Updates

All internal references were updated automatically:

### In project.godot
```ini
# Before:
run/main_scene="res://scenes/main.tscn"

# After:
run/main_scene="res://scenes/main/main.tscn"
```

### In scenes/main/main.tscn
```
# Before:
[ext_resource type="Script" path="res://scripts/world_generation/world_generator.gd" id="1"]
[ext_resource type="Script" path="res://scripts/player/player_controller.gd" id="2"]

# After:
[ext_resource type="Script" path="res://scripts/systems/world_generation/world_generator.gd" id="1"]
[ext_resource type="Script" path="res://scripts/entities/player/player_controller.gd" id="2"]
```

### In scripts/systems/voxel/chunk.gd
```gdscript
# Before:
voxel_material = load("res://materials/cel_material.tres")

# After:
voxel_material = load("res://resources/materials/cel_material.tres")
```

### In resources/recipes/*.tres
```
# Before:
[ext_resource type="Script" path="res://scripts/crafting/crafting_station.gd" id="1"]

# After:
[ext_resource type="Script" path="res://scripts/systems/crafting/crafting_station.gd" id="1"]
```

## New Files Created

### Documentation
- `/docs/README.md` - Documentation index
- `/docs/PROJECT_STRUCTURE.md` - Comprehensive structure reference
- `/docs/MIGRATION_GUIDE.md` - This file

### Directory Documentation
- `/assets/README.md` - Assets organization guide
- `/scenes/README.md` - Scene structure guide
- `/scripts/README.md` - Script organization guide

### Placeholder Files
- 22 `.gitkeep` files in empty directories to preserve structure in git

## Validation Performed

### Script References ✓
- All 12 `class_name` declarations validated
- All scene script references verified
- All resource script references checked
- No broken references found

### Parse Errors ✓
- Original parse error in `world_generator.gd` fixed
- All scripts compile without errors
- No dependency issues

### File Structure ✓
- 51 directories properly organized
- 69 files correctly placed
- All paths updated and validated

## Benefits of Restructure

### 1. Professional Organization
- Follows Godot 4.x official recommendations
- Industry-standard structure
- Easy for new developers to understand

### 2. Better Separation of Concerns
- Assets separate from code
- Documentation centralized
- Resources organized by type
- Scripts organized by system

### 3. Scalability
- Clear places for new content
- Room for growth in all categories
- Won't become cluttered over time

### 4. Maintainability
- Easy to find files
- Logical grouping
- Clear naming conventions
- Good for team collaboration

### 5. Future-Proof
- Ready for CI/CD integration
- Easy to add build scripts
- Prepared for asset pipelines
- Structured for expansion

## Migration Checklist for Developers

If you're working on a branch that needs to be updated:

- [ ] Pull the latest changes from main branch
- [ ] Update any custom scripts that reference old paths
- [ ] Check your scenes for old script references
- [ ] Update any documentation that references old structure
- [ ] Test that your features still work
- [ ] Commit your updated changes

### Common Issues & Solutions

**Issue:** Scene can't find script
- **Solution:** Update the script path in the scene file to the new location

**Issue:** Script can't load resource
- **Solution:** Update `load()` or `preload()` paths to new resource locations

**Issue:** Class not found error
- **Solution:** Check that `class_name` is declared in the script - paths are resolved automatically for classes

## Testing Recommendations

After migrating or updating code:

1. **Open Project in Godot**
   - Verify no error messages in the console
   - Check that all scripts compile

2. **Test Main Scene**
   - Run the main scene (F5)
   - Verify world generation works
   - Test player movement

3. **Check Resources**
   - Verify materials load correctly
   - Check that items display properly
   - Test crafting recipes

4. **Validate Paths**
   - Search for any remaining old paths
   - Update as needed

## Rollback Instructions

If you need to rollback this restructure:

```bash
# Checkout the commit before the restructure
git checkout <commit-before-restructure>

# Or revert the restructure commits
git revert <restructure-commit-hashes>
```

**Warning:** Only rollback if absolutely necessary. The new structure is much better for long-term development.

## Additional Resources

- [Godot Best Practices - Project Organization](https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html)
- [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Complete structure reference
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture
- [DEVELOPMENT.md](DEVELOPMENT.md) - Development guide

## Questions?

If you have questions about the restructure or need help migrating your code, please:

1. Review the PROJECT_STRUCTURE.md document
2. Check this migration guide
3. Look at the git commit history for examples
4. Open an issue if you're still stuck

---

**Migration Completed:** November 1, 2025
**Total Commits:** 3 (Parse fix, Restructure, .gitkeep files)
**Files Affected:** 69 files total
**Directories Created:** 51 directories
**Status:** ✅ Complete and Validated
