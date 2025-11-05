extends Node

## Autoload script to generate 2D tileset textures on startup
## Ensures textures are available before the game starts

const TILESET_PATH = "res://assets/textures/terrain/tileset_2d.png"
const TileTextureGenerator2D = preload("res://scripts/utils/tile_texture_generator_2d.gd")

func _ready():
	print("Checking 2D tileset textures...")
	
	# Check if directory exists
	var dir = DirAccess.open("res://assets/textures/terrain/")
	if not dir:
		print("Creating terrain texture directory...")
		DirAccess.make_dir_recursive_absolute("res://assets/textures/terrain/")
	
	# Always regenerate on startup for development
	# In production, you might want to check if file exists first
	generate_textures()

func generate_textures():
	print("Generating 2D tileset textures...")
	var success = TileTextureGenerator2D.save_tileset_atlas(TILESET_PATH)
	
	if success:
		print("2D tileset generation complete!")
	else:
		push_error("Failed to generate 2D tileset!")

func get_tileset_path() -> String:
	return TILESET_PATH
