extends EditorScript

## Tool script to generate 2D tileset texture
## Run this from the Godot editor: File > Run

func _run():
	print("=== Generating 2D Tileset Texture ===")
	
	# Load the generator class
	var generator = load("res://scripts/utils/tile_texture_generator_2d.gd")
	
	if not generator:
		print("ERROR: Could not load TileTextureGenerator2D")
		return
	
	# Ensure directory exists
	DirAccess.make_dir_recursive_absolute("res://assets/textures/terrain/")
	
	# Generate and save the tileset
	var path = "res://assets/textures/terrain/tileset_2d.png"
	var success = generator.save_tileset_atlas(path)
	
	if success:
		print("✓ Tileset generated successfully at: " + path)
		print("✓ You can now use this texture in your TileMap!")
	else:
		print("✗ Failed to generate tileset")
	
	print("=== Generation Complete ===")
