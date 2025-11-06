@tool
extends EditorScript

## Tool script to generate the player sprite
## Run this from the Godot editor: File > Run

func _run():
	var generator_script = load("res://scripts/utils/player_sprite_generator.gd")
	var output_path = "res://assets/sprites/player_character.png"
	
	# Convert to absolute path for saving
	var absolute_path = ProjectSettings.globalize_path(output_path)
	
	print("Generating player sprite...")
	var result = generator_script.save_player_sprite(absolute_path)
	
	if result:
		print("✅ Player sprite generated successfully!")
		print("Saved to: ", output_path)
		print("Reimporting asset...")
		
		# Trigger reimport
		var filesystem = EditorInterface.get_resource_filesystem()
		if filesystem:
			filesystem.scan()
			print("✅ Asset reimported!")
	else:
		print("❌ Failed to generate player sprite")
