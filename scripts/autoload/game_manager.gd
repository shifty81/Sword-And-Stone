extends Node
class_name GameManager

## Main game manager singleton

signal game_paused()
signal game_resumed()

var player: PlayerController
var world_generator: WorldGenerator
var player_inventory: Inventory

var is_paused: bool = false

func _ready():
	# Make this a singleton
	if not Engine.has_singleton("GameManager"):
		add_to_group("game_manager")

func _process(_delta):
	# Handle pause
	if Input.is_action_just_pressed("ui_cancel") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		toggle_pause()

func initialize_game():
	# Find game components
	player = get_tree().get_first_node_in_group("player")
	world_generator = get_tree().get_first_node_in_group("world_generator")
	
	# Create player inventory
	player_inventory = Inventory.new()
	add_child(player_inventory)
	
	print("Game initialized")

func toggle_pause():
	is_paused = not is_paused
	
	if is_paused:
		game_paused.emit()
		get_tree().paused = true
	else:
		game_resumed.emit()
		get_tree().paused = false

func save_game(save_path: String = "user://savegame.save"):
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	if save_file == null:
		print("Failed to save game")
		return
	
	var save_data = {
		"player_position": player.global_position if player else Vector3.ZERO,
		"world_seed": world_generator.world_seed if world_generator else 12345,
		# Add more save data as needed
	}
	
	save_file.store_var(save_data)
	save_file.close()
	print("Game saved")

func load_game(save_path: String = "user://savegame.save"):
	if not FileAccess.file_exists(save_path):
		print("Save file doesn't exist")
		return
	
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	if save_file == null:
		print("Failed to load game")
		return
	
	var save_data = save_file.get_var()
	save_file.close()
	
	# Restore game state
	if player and save_data.has("player_position"):
		player.global_position = save_data["player_position"]
	
	print("Game loaded")
