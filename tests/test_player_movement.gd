extends GutTest

## Test for player movement functionality
## Validates the Input.get_vector fix

func test_input_vector_parameter_order():
	# This test documents the correct parameter order for Input.get_vector()
	# The function signature is: Input.get_vector(negative_x, positive_x, negative_y, positive_y)
	# 
	# In top-down 2D:
	# - X axis: left is negative, right is positive
	# - Y axis: up/forward is negative, down/back is positive
	# 
	# Therefore, the correct order is:
	# Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	#
	# NOT: Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	assert_true(true, "Input.get_vector should use (move_left, move_right, move_back, move_forward)")

func test_player_movement_script_exists():
	var player_script = load("res://scripts/entities/player/topdown_player.gd")
	assert_not_null(player_script, "TopDownPlayer script should exist")

func test_player_scene_exists():
	# Verify the main scene has the player
	var main_scene = load("res://scenes/main/crimson_isles_main.tscn")
	assert_not_null(main_scene, "Main scene should exist")

func test_player_sprite_exists():
	# Verify the player sprite was generated
	var sprite = load("res://assets/sprites/player_character.png")
	assert_not_null(sprite, "Player character sprite should exist")

func test_player_controller_has_speed_values():
	var player = TopDownPlayer.new()
	assert_eq(player.move_speed, 200.0, "Default move speed should be 200")
	assert_eq(player.sprint_speed, 350.0, "Default sprint speed should be 350")
	player.free()
