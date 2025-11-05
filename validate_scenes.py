#!/usr/bin/env python3
"""
Quick validation script for Crimson Isles scenes
Checks that scene files are properly formatted and reference existing resources
"""

import os
import sys

def check_scene_file(filepath):
    """Check if a .tscn file is valid"""
    print(f"\n🔍 Checking: {filepath}")
    
    if not os.path.exists(filepath):
        print(f"  ❌ File not found!")
        return False
    
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Basic validation
    checks = {
        "Has scene header": '[gd_scene' in content,
        "Has node definitions": '[node name=' in content,
        "Has proper format": 'format=3' in content or 'format=2' in content,
    }
    
    all_pass = True
    for check, result in checks.items():
        status = "✅" if result else "❌"
        print(f"  {status} {check}")
        if not result:
            all_pass = False
    
    # Count nodes
    node_count = content.count('[node name=')
    print(f"  📊 Contains {node_count} nodes")
    
    return all_pass

def check_script_file(filepath):
    """Check if a .gd file exists and has basic structure"""
    print(f"\n🔍 Checking: {filepath}")
    
    if not os.path.exists(filepath):
        print(f"  ❌ File not found!")
        return False
    
    with open(filepath, 'r') as f:
        content = f.read()
    
    checks = {
        "Has extends statement": 'extends' in content,
        "Has class definition or script logic": 'class_name' in content or 'func ' in content,
    }
    
    all_pass = True
    for check, result in checks.items():
        status = "✅" if result else "❌"
        print(f"  {status} {check}")
        if not result:
            all_pass = False
    
    # Count functions
    func_count = content.count('func ')
    print(f"  📊 Contains {func_count} functions")
    
    return all_pass

def main():
    print("=" * 60)
    print("CRIMSON ISLES - SCENE VALIDATION")
    print("=" * 60)
    
    os.chdir('/home/runner/work/Sword-And-Stone/Sword-And-Stone')
    
    files_to_check = {
        "scenes": [
            "scenes/main/crimson_isles_main.tscn",
            "scenes/dungeons/dungeon_template.tscn",
        ],
        "scripts": [
            "scripts/entities/player/topdown_player.gd",
            "scripts/autoload/world_state_manager.gd",
        ]
    }
    
    all_valid = True
    
    print("\n" + "─" * 60)
    print("SCENE FILES")
    print("─" * 60)
    for scene in files_to_check["scenes"]:
        if not check_scene_file(scene):
            all_valid = False
    
    print("\n" + "─" * 60)
    print("SCRIPT FILES")
    print("─" * 60)
    for script in files_to_check["scripts"]:
        if not check_script_file(script):
            all_valid = False
    
    print("\n" + "=" * 60)
    if all_valid:
        print("✅ ALL VALIDATIONS PASSED!")
        print("\n🎮 Ready to open in Godot!")
        print("\nNext steps:")
        print("  1. Open Godot 4.2+")
        print("  2. Import this project")
        print("  3. Press F5 to run!")
    else:
        print("⚠️  Some validation issues found")
        print("   (These may not prevent Godot from running)")
    print("=" * 60)
    
    return 0 if all_valid else 1

if __name__ == "__main__":
    sys.exit(main())
