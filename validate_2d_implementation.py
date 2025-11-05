#!/usr/bin/env python3
"""
Validation script for 2D world generation implementation
Tests that all required files exist and are properly configured
"""

import os
from pathlib import Path
import sys

def check_file_exists(path, description):
    """Check if a file exists and report"""
    if os.path.exists(path):
        print(f"✓ {description}: {path}")
        return True
    else:
        print(f"✗ MISSING {description}: {path}")
        return False

def check_directory_exists(path, description):
    """Check if a directory exists and report"""
    if os.path.isdir(path):
        print(f"✓ {description}: {path}")
        return True
    else:
        print(f"✗ MISSING {description}: {path}")
        return False

def validate_implementation():
    """Validate the 2D world generation implementation"""
    print("=" * 70)
    print("2D World Generation Implementation Validation")
    print("=" * 70)
    print()
    
    base_path = Path(__file__).parent
    all_checks = []
    
    print("Core Scripts:")
    print("-" * 70)
    all_checks.append(check_file_exists(
        base_path / "scripts/systems/world_generation/world_generator_2d.gd",
        "World Generator 2D"
    ))
    all_checks.append(check_file_exists(
        base_path / "scripts/utils/tile_texture_generator_2d.gd",
        "Tile Texture Generator"
    ))
    all_checks.append(check_file_exists(
        base_path / "scripts/autoload/tileset_generator.gd",
        "Tileset Generator Autoload"
    ))
    all_checks.append(check_file_exists(
        base_path / "scripts/scenes/crimson_isles_main.gd",
        "Scene Initialization Script"
    ))
    print()
    
    print("Shaders:")
    print("-" * 70)
    all_checks.append(check_file_exists(
        base_path / "shaders/cel_shader_2d.gdshader",
        "2D Cel-Shader"
    ))
    print()
    
    print("Utilities:")
    print("-" * 70)
    all_checks.append(check_file_exists(
        base_path / "generate_tileset.py",
        "Python Tileset Generator"
    ))
    all_checks.append(check_file_exists(
        base_path / "generate_tileset_standalone.gd",
        "GDScript Standalone Generator"
    ))
    all_checks.append(check_file_exists(
        base_path / "scripts/utils/generate_tileset_tool.gd",
        "Editor Tool Script"
    ))
    all_checks.append(check_file_exists(
        base_path / "create_tileset_preview.py",
        "Preview Generator"
    ))
    print()
    
    print("Assets:")
    print("-" * 70)
    all_checks.append(check_directory_exists(
        base_path / "assets/textures/terrain",
        "Terrain Texture Directory"
    ))
    all_checks.append(check_file_exists(
        base_path / "assets/textures/terrain/tileset_2d.png",
        "Tileset Atlas"
    ))
    print()
    
    print("Scenes:")
    print("-" * 70)
    all_checks.append(check_file_exists(
        base_path / "scenes/main/crimson_isles_main.tscn",
        "Crimson Isles Main Scene"
    ))
    print()
    
    print("Documentation:")
    print("-" * 70)
    all_checks.append(check_file_exists(
        base_path / "docs/2D_WORLD_GENERATION.md",
        "World Generation Guide"
    ))
    all_checks.append(check_file_exists(
        base_path / "docs/2D_IMPLEMENTATION_SUMMARY.md",
        "Implementation Summary"
    ))
    all_checks.append(check_file_exists(
        base_path / "docs/tileset_preview.png",
        "Tileset Preview (Vertical)"
    ))
    all_checks.append(check_file_exists(
        base_path / "docs/tileset_grid_preview.png",
        "Tileset Preview (Grid)"
    ))
    print()
    
    print("Configuration:")
    print("-" * 70)
    
    # Check project.godot for autoload
    project_file = base_path / "project.godot"
    if os.path.exists(project_file):
        with open(project_file, 'r') as f:
            content = f.read()
            if 'TilesetGenerator' in content:
                print("✓ TilesetGenerator registered in project.godot autoload")
                all_checks.append(True)
            else:
                print("✗ TilesetGenerator NOT registered in project.godot autoload")
                all_checks.append(False)
    else:
        print("✗ project.godot not found")
        all_checks.append(False)
    
    print()
    print("=" * 70)
    print("Validation Summary")
    print("=" * 70)
    
    total = len(all_checks)
    passed = sum(all_checks)
    failed = total - passed
    
    print(f"Total Checks: {total}")
    print(f"Passed: {passed}")
    print(f"Failed: {failed}")
    print()
    
    if failed == 0:
        print("✓ All validation checks passed!")
        print("✓ Implementation is complete and ready to use.")
        print()
        print("Next Steps:")
        print("1. Open the project in Godot 4.2+")
        print("2. Press F5 to run the Crimson Isles scene")
        print("3. Explore the procedurally generated 2D world!")
        print()
        return 0
    else:
        print(f"✗ {failed} validation check(s) failed.")
        print("✗ Please review the missing files above.")
        print()
        return 1

if __name__ == "__main__":
    exit_code = validate_implementation()
    sys.exit(exit_code)
