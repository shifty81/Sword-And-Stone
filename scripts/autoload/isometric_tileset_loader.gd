extends Node

## Runtime script to generate isometric tileset
## Runs at game startup to create the isometric tile atlas

func _ready():
	print("Generating isometric tileset at runtime...")
	
	# Load the generator
	var IsometricTileGenerator = load("res://scripts/utils/isometric_tile_generator.gd")
	
	# Generate the atlas
	var atlas = IsometricTileGenerator.generate_isometric_tileset()
	
	# Save to resources
	var path = "user://isometric_tileset.png"
	var err = atlas.save_png(path)
	
	if err == OK:
		print("✓ Isometric tileset generated at: ", path)
		
		# Also try to save in res:// if possible (for development)
		var res_path = "res://assets/textures/terrain/isometric_tileset.png"
		atlas.save_png(res_path)
	else:
		push_error("Failed to generate isometric tileset: ", err)
