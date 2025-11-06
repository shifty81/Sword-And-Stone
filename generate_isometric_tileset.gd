@tool
extends EditorScript

## Tool script to generate isometric tileset
## Run this from Godot: File -> Run

func _run():
	print("Generating isometric tileset...")
	
	# Load the generator class
	var IsometricTileGenerator = load("res://scripts/utils/isometric_tile_generator.gd")
	
	# Generate and save the tileset
	var success = IsometricTileGenerator.save_isometric_tileset()
	
	if success:
		print("✓ Isometric tileset generated successfully!")
		print("Location: res://assets/textures/terrain/isometric_tileset.png")
	else:
		print("✗ Failed to generate isometric tileset")
