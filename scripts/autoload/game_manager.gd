extends Node

## Main game manager singleton
## Converted from C++ Engine class - manages core game systems and lifecycle
## Godot handles window management, rendering pipeline, and base input automatically

signal game_paused()
signal game_resumed()
signal game_initialized()
signal game_shutdown()

# Core game references
var player: PlayerController
var world_generator: WorldGenerator
var player_inventory: Inventory

# Engine state
var is_running: bool = true
var is_paused: bool = false
var is_initialized: bool = false

# Performance tracking (converted from C++ TimeManager functionality)
var fps_history: Array[float] = []
var frame_time_history: Array[float] = []
const MAX_HISTORY_SIZE: int = 60

func _ready() -> void:
	add_to_group("game_manager")
	process_mode = Node.PROCESS_MODE_ALWAYS  # Always process, even when paused
	
	# Initialize on next frame to allow scene setup
	call_deferred("initialize_game")
	
	print("=== Sword And Stone - Godot Edition ===")
	print("Engine: Godot ", Engine.get_version_info().string)
	print("Rendering: ", RenderingServer.get_video_adapter_name())

func _process(delta: float) -> void:
	# Track performance metrics
	_update_performance_metrics(delta)
	
	# Handle ESC for pause/unpause (converted from C++ Engine::ProcessInput)
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			toggle_pause()
		elif is_paused:
			toggle_pause()

func _notification(what: int) -> void:
	# Handle application lifecycle events
	match what:
		NOTIFICATION_WM_CLOSE_REQUEST:
			shutdown_game()
			get_tree().quit()
		NOTIFICATION_APPLICATION_PAUSED:
			if not is_paused:
				toggle_pause()
		NOTIFICATION_APPLICATION_RESUMED:
			if is_paused:
				toggle_pause()

## Initialize core game systems (converted from C++ Engine::Initialize)
func initialize_game() -> bool:
	if is_initialized:
		push_warning("Game already initialized")
		return true
	
	print("Initializing game systems...")
	
	# Find game components
	player = get_tree().get_first_node_in_group("player")
	if not player:
		push_error("Failed to find player in scene tree!")
		return false
	
	world_generator = get_tree().get_first_node_in_group("world_generator")
	if not world_generator:
		push_warning("World generator not found - may be added dynamically")
	
	# Create player inventory
	player_inventory = Inventory.new()
	add_child(player_inventory)
	
	is_initialized = true
	is_running = true
	game_initialized.emit()
	
	print("✓ Game initialized successfully")
	print("  - Player: ", player.name if player else "None")
	print("  - World: ", world_generator.name if world_generator else "None")
	print("  - Inventory: Ready")
	
	return true

## Main game loop update (converted from C++ Engine::Update)
## Note: Godot handles the loop automatically via _process
func update_game_systems(delta: float) -> void:
	if not is_running or is_paused:
		return
	
	# Game systems are updated via Godot's scene tree
	# This function is available for custom update logic
	pass

## Shutdown game systems (converted from C++ Engine::Shutdown)
func shutdown_game() -> void:
	print("Shutting down game...")
	
	is_running = false
	
	# Cleanup systems
	if player_inventory:
		player_inventory.queue_free()
		player_inventory = null
	
	# Clear references
	player = null
	world_generator = null
	
	game_shutdown.emit()
	print("✓ Game shut down")

## Request application exit (converted from C++ Engine::RequestExit)
func request_exit() -> void:
	is_running = false
	shutdown_game()
	get_tree().quit()

## Toggle pause state
func toggle_pause() -> void:
	is_paused = not is_paused
	
	if is_paused:
		game_paused.emit()
		get_tree().paused = true
		print("Game paused")
	else:
		game_resumed.emit()
		get_tree().paused = false
		print("Game resumed")

## Performance tracking (converted from C++ TimeManager)
func _update_performance_metrics(delta: float) -> void:
	# Track FPS
	var current_fps = Engine.get_frames_per_second()
	fps_history.append(current_fps)
	if fps_history.size() > MAX_HISTORY_SIZE:
		fps_history.pop_front()
	
	# Track frame time
	frame_time_history.append(delta)
	if frame_time_history.size() > MAX_HISTORY_SIZE:
		frame_time_history.pop_front()

## Get average FPS over last second
func get_average_fps() -> float:
	if fps_history.is_empty():
		return 0.0
	var sum = 0.0
	for fps in fps_history:
		sum += fps
	return sum / fps_history.size()

## Get average frame time in milliseconds
func get_average_frame_time_ms() -> float:
	if frame_time_history.is_empty():
		return 0.0
	var sum = 0.0
	for ft in frame_time_history:
		sum += ft
	return (sum / frame_time_history.size()) * 1000.0

## Get current frame count
func get_frame_count() -> int:
	return Engine.get_frames_drawn()

## Get time since engine started
func get_time_since_start() -> float:
	return Time.get_ticks_msec() / 1000.0

## Save game to disk
func save_game(save_path: String = "user://savegame.save") -> void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	if save_file == null:
		push_error("Failed to save game: " + str(FileAccess.get_open_error()))
		return
	
	var save_data = {
		"version": "1.0",
		"timestamp": Time.get_datetime_string_from_system(),
		"player_position": player.global_position if player else Vector3.ZERO,
		"player_rotation": player.rotation.y if player else 0.0,
		"world_seed": world_generator.world_seed if world_generator else 12345,
		"play_time": get_time_since_start(),
		# Add inventory data when available
		# "inventory": player_inventory.serialize() if player_inventory else {}
	}
	
	save_file.store_var(save_data)
	save_file.close()
	print("✓ Game saved to: ", save_path)

## Load game from disk
func load_game(save_path: String = "user://savegame.save") -> bool:
	if not FileAccess.file_exists(save_path):
		push_warning("Save file doesn't exist: " + save_path)
		return false
	
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	if save_file == null:
		push_error("Failed to load game: " + str(FileAccess.get_open_error()))
		return false
	
	var save_data = save_file.get_var()
	save_file.close()
	
	if typeof(save_data) != TYPE_DICTIONARY:
		push_error("Invalid save file format")
		return false
	
	# Restore game state
	if player and save_data.has("player_position"):
		player.global_position = save_data["player_position"]
	if player and save_data.has("player_rotation"):
		player.rotation.y = save_data["player_rotation"]
	
	print("✓ Game loaded from: ", save_path)
	print("  - Save version: ", save_data.get("version", "unknown"))
	print("  - Saved at: ", save_data.get("timestamp", "unknown"))
	
	return true
