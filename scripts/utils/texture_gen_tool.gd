@tool
extends EditorScript

## Editor script to generate all medieval textures
## Run this from the Godot editor: File -> Run -> texture_gen_tool.gd

func _run():
	print("=== Medieval Texture Generator ===")
	print("Generating procedural textures...")
	
	# Ensure directories exist
	var terrain_dir = "res://assets/textures/terrain/"
	var items_dir = "res://assets/textures/items/"
	
	DirAccess.make_dir_recursive_absolute(terrain_dir)
	DirAccess.make_dir_recursive_absolute(items_dir)
	
	# Generate all textures
	TextureGenerator.generate_all_textures()
	
	print("=== Texture Generation Complete ===")
	print("Please reimport textures in the Godot editor (Project -> Reload Current Project)")
