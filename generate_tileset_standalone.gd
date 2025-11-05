#!/usr/bin/env -S godot --headless --script

# Standalone script to generate 2D tileset texture
# Can be run from command line: godot --headless --script generate_tileset_standalone.gd

extends SceneTree

func _init():
	print("=== Generating 2D Tileset Texture ===")
	
	# Ensure directory exists
	DirAccess.make_dir_recursive_absolute("res://assets/textures/terrain/")
	
	# Load and instantiate the generator
	var TileTextureGenerator2D = load("res://scripts/utils/tile_texture_generator_2d.gd")
	
	# Generate and save
	var path = "res://assets/textures/terrain/tileset_2d.png"
	var success = TileTextureGenerator2D.save_tileset_atlas(path)
	
	if success:
		print("✓ Tileset generated successfully!")
		print("✓ Saved to: " + path)
	else:
		print("✗ Failed to generate tileset")
	
	print("=== Generation Complete ===")
	quit()
