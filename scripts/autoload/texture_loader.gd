extends Node

## Utility tool to generate textures at runtime or in editor
## Call this once to generate all procedural textures

func _ready():
	# Check if textures need to be generated
	if should_generate_textures():
		generate_textures()

func should_generate_textures() -> bool:
	# Check if grass texture exists
	var test_path = "res://assets/textures/terrain/grass.png"
	return not FileAccess.file_exists(test_path)

func generate_textures():
	print("Generating procedural medieval textures...")
	
	# Ensure directories exist
	DirAccess.make_dir_recursive_absolute("res://assets/textures/terrain/")
	DirAccess.make_dir_recursive_absolute("res://assets/textures/items/")
	
	# Generate all textures
	TextureGenerator.generate_all_textures()
	
	print("Texture generation complete! Restart the game to load new textures.")

func _input(event):
	# Press F9 to regenerate textures
	if event is InputEventKey and event.pressed and event.keycode == KEY_F9:
		generate_textures()
