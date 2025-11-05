extends Node

## Input helper singleton
## Converted from C++ InputManager - provides input utilities beyond Godot's built-in Input
## Note: Godot's Input class handles most functionality, this adds convenience methods

signal key_just_pressed(keycode: int)
signal key_just_released(keycode: int)
signal mouse_button_just_pressed(button_index: int)
signal mouse_button_just_released(button_index: int)

# Input state tracking for frame-by-frame detection
var _previous_keys: Dictionary = {}
var _current_keys: Dictionary = {}
var _previous_mouse_buttons: Dictionary = {}
var _current_mouse_buttons: Dictionary = {}

# Mouse tracking
var mouse_position: Vector2 = Vector2.ZERO
var mouse_delta: Vector2 = Vector2.ZERO
var _last_mouse_position: Vector2 = Vector2.ZERO

# Input action buffering for better responsiveness
var action_buffer: Dictionary = {}
const ACTION_BUFFER_TIME: float = 0.1  # Buffer inputs for 100ms
var _expired_actions_cache: Array[String] = []  # Reused array to avoid allocations

func _ready() -> void:
	add_to_group("input_helper")
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("InputHelper initialized")

## Update input state each frame (converted from C++ InputManager::Update)
func _process(_delta: float) -> void:
	# Update mouse position and delta
	var current_mouse = get_viewport().get_mouse_position()
	mouse_delta = current_mouse - _last_mouse_position
	_last_mouse_position = current_mouse
	mouse_position = current_mouse
	
	# Process buffered actions
	_process_action_buffer(_delta)

## Handle input events for state tracking
func _input(event: InputEvent) -> void:
	# Track key presses
	if event is InputEventKey:
		var key = event.physical_keycode
		_current_keys[key] = event.pressed
		
		if event.pressed and not _previous_keys.get(key, false):
			key_just_pressed.emit(key)
		elif not event.pressed and _previous_keys.get(key, false):
			key_just_released.emit(key)
	
	# Track mouse buttons
	elif event is InputEventMouseButton:
		var button = event.button_index
		_current_mouse_buttons[button] = event.pressed
		
		if event.pressed and not _previous_mouse_buttons.get(button, false):
			mouse_button_just_pressed.emit(button)
		elif not event.pressed and _previous_mouse_buttons.get(button, false):
			mouse_button_just_released.emit(button)

## Update previous frame state
func _physics_process(_delta: float) -> void:
	_previous_keys = _current_keys.duplicate()
	_previous_mouse_buttons = _current_mouse_buttons.duplicate()

## Check if key was just pressed this frame (converted from C++ IsKeyPressed)
func is_key_just_pressed(keycode: Key) -> bool:
	return Input.is_physical_key_pressed(keycode) and not _previous_keys.get(keycode, false)

## Check if key is currently held down (converted from C++ IsKeyDown)
func is_key_down(keycode: Key) -> bool:
	return Input.is_physical_key_pressed(keycode)

## Check if key was just released this frame (converted from C++ IsKeyReleased)
func is_key_just_released(keycode: Key) -> bool:
	return not Input.is_physical_key_pressed(keycode) and _previous_keys.get(keycode, false)

## Check if mouse button was just pressed (converted from C++ IsMouseButtonPressed)
func is_mouse_button_just_pressed(button: MouseButton) -> bool:
	return Input.is_mouse_button_pressed(button) and not _previous_mouse_buttons.get(button, false)

## Check if mouse button is held down (converted from C++ IsMouseButtonDown)
func is_mouse_button_down(button: MouseButton) -> bool:
	return Input.is_mouse_button_pressed(button)

## Check if mouse button was just released (converted from C++ IsMouseButtonReleased)
func is_mouse_button_just_released(button: MouseButton) -> bool:
	return not Input.is_mouse_button_pressed(button) and _previous_mouse_buttons.get(button, false)

## Get current mouse position (converted from C++ GetMousePosition)
func get_mouse_position() -> Vector2:
	return mouse_position

## Get mouse movement delta since last frame (converted from C++ GetMouseDelta)
func get_mouse_delta() -> Vector2:
	return mouse_delta

## Get mouse position in world 3D space (requires camera)
func get_mouse_world_position_3d(camera: Camera3D, distance: float = 10.0) -> Vector3:
	if not camera:
		return Vector3.ZERO
	
	var mouse_pos = get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * distance
	return to

## Perform raycast from mouse position
func raycast_from_mouse(camera: Camera3D, max_distance: float = 1000.0, collision_mask: int = 0xFFFFFFFF) -> Dictionary:
	if not camera:
		return {}
	
	var space_state = camera.get_world_3d().direct_space_state
	var mouse_pos = get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * max_distance
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = collision_mask
	
	return space_state.intersect_ray(query)

## Buffer an action for improved input responsiveness
func buffer_action(action: String) -> void:
	action_buffer[action] = ACTION_BUFFER_TIME

## Check if buffered action is available
func is_action_buffered(action: String) -> bool:
	return action_buffer.has(action) and action_buffer[action] > 0.0

## Consume a buffered action (remove it from buffer)
func consume_buffered_action(action: String) -> void:
	action_buffer.erase(action)

## Process action buffer timers
func _process_action_buffer(delta: float) -> void:
	_expired_actions_cache.clear()
	
	for action in action_buffer.keys():
		action_buffer[action] -= delta
		if action_buffer[action] <= 0.0:
			_expired_actions_cache.append(action)
	
	for action in _expired_actions_cache:
		action_buffer.erase(action)

## Get directional input as Vector2 (for 2D movement or menu navigation)
func get_direction_2d(left: String = "ui_left", right: String = "ui_right", 
					   up: String = "ui_up", down: String = "ui_down") -> Vector2:
	return Input.get_vector(left, right, up, down)

## Get directional input as Vector3 (for 3D movement)
func get_direction_3d(left: String = "move_left", right: String = "move_right",
					   forward: String = "move_forward", back: String = "move_back") -> Vector3:
	var input_2d = Input.get_vector(left, right, forward, back)
	return Vector3(input_2d.x, 0, input_2d.y)

## Check if any key is pressed
func is_any_key_pressed() -> bool:
	for key in _current_keys.keys():
		if _current_keys[key]:
			return true
	return false

## Check if any mouse button is pressed
func is_any_mouse_button_pressed() -> bool:
	for button in _current_mouse_buttons.keys():
		if _current_mouse_buttons[button]:
			return true
	return false

## Get all currently pressed keys
func get_pressed_keys() -> Array[int]:
	var pressed: Array[int] = []
	for key in _current_keys.keys():
		if _current_keys[key]:
			pressed.append(key)
	return pressed

## Get all currently pressed mouse buttons
func get_pressed_mouse_buttons() -> Array[int]:
	var pressed: Array[int] = []
	for button in _current_mouse_buttons.keys():
		if _current_mouse_buttons[button]:
			pressed.append(button)
	return pressed

## Set mouse mode with validation
func set_mouse_mode(mode: Input.MouseMode) -> void:
	Input.mouse_mode = mode
	print("Mouse mode changed to: ", _get_mouse_mode_name(mode))

## Get mouse mode as readable string
func _get_mouse_mode_name(mode: Input.MouseMode) -> String:
	match mode:
		Input.MOUSE_MODE_VISIBLE:
			return "Visible"
		Input.MOUSE_MODE_HIDDEN:
			return "Hidden"
		Input.MOUSE_MODE_CAPTURED:
			return "Captured"
		Input.MOUSE_MODE_CONFINED:
			return "Confined"
		Input.MOUSE_MODE_CONFINED_HIDDEN:
			return "Confined Hidden"
		_:
			return "Unknown"

## Toggle mouse capture
func toggle_mouse_capture() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

## Debug: Print current input state
func print_input_state() -> void:
	print("=== Input State ===")
	print("Mouse Position: ", mouse_position)
	print("Mouse Delta: ", mouse_delta)
	print("Pressed Keys: ", get_pressed_keys())
	print("Pressed Mouse Buttons: ", get_pressed_mouse_buttons())
	print("Action Buffer: ", action_buffer)
