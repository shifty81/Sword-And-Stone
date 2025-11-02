# ============================================================================
# STOP! This is a Godot Project, Not a CMake Project
# ============================================================================
#
# If you're seeing this file, you're trying to build this project with CMake.
# This will NOT work because this is a Godot game project, not a C++ project.
#
# ERROR: This project does NOT use CMake!
#
# ============================================================================
# How to Run This Project
# ============================================================================
#
# 1. Download Godot Engine 4.2 or newer from:
#    https://godotengine.org/download
#
# 2. Open Godot and import this project by selecting:
#    project.godot
#
# 3. Press F5 or click the Play button to run the game
#
# NO COMPILATION NEEDED - Godot uses interpreted GDScript!
#
# ============================================================================
# For Full Instructions
# ============================================================================
#
# Please read: BUILD.md
#
# ============================================================================

cmake_minimum_required(VERSION 3.10)

message(FATAL_ERROR "
╔════════════════════════════════════════════════════════════════════╗
║                                                                    ║
║  ❌ ERROR: This is a Godot Project, Not a CMake Project!         ║
║                                                                    ║
║  This project uses the Godot Engine and GDScript.                 ║
║  It does NOT require CMake, Make, or any C++ compiler.            ║
║                                                                    ║
║  📖 How to Run This Project:                                      ║
║                                                                    ║
║  1. Download Godot 4.2+ from: https://godotengine.org/download    ║
║  2. Open Godot and import 'project.godot'                         ║
║  3. Press F5 to run the game                                      ║
║                                                                    ║
║  📄 For detailed instructions, see: BUILD.md                      ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
")

# This line will never be reached due to FATAL_ERROR above
project(SwordAndStone_CMakeError CXX)
