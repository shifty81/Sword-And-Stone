extends CharacterBody3D
class_name PlayerController

## First-person player controller for exploring the world
## Similar to Minecraft/Vintage Story controls

@export_group("Movement")
@export var walk_speed: float = 5.0
@export var run_speed: float = 8.0
@export var jump_velocity: float = 6.0
@export var mouse_sensitivity: float = 0.002

@export_group("Interaction")
@export var reach: float = 5.0
@export var interact_cooldown: float = 0.1  # Minimum time between interactions

var gravity = 20.0
var camera: Camera3D
var camera_pivot: Node3D
var last_interact_time: float = 0.0

func _ready():
	add_to_group("player")
	
	# Create camera pivot for look rotation
	camera_pivot = Node3D.new()
	camera_pivot.name = "CameraPivot"
	add_child(camera_pivot)
	camera_pivot.position = Vector3(0, 1.7, 0)
	
	# Create camera
	camera = Camera3D.new()
	camera.name = "Camera"
	camera_pivot.add_child(camera)
	camera.current = true
	
	# Capture mouse
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	# Mouse look
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -PI/2, PI/2)
	
	# Toggle mouse capture
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	handle_movement(delta)
	handle_interaction()

func handle_movement(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Get input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Apply speed
	var speed = run_speed if Input.is_action_pressed("sprint") else walk_speed
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func handle_interaction():
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	# Throttle interactions to prevent spam
	var current_time = Time.get_ticks_msec() / 1000.0
	if current_time - last_interact_time < interact_cooldown:
		return
	
	# Raycast for voxel interaction
	var space_state = get_world_3d().direct_space_state
	if not space_state:
		return
	
	var from = camera.global_position
	var to = from + (-camera.global_transform.basis.z * reach)
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		# Left click to break voxel
		if Input.is_action_just_pressed("break_voxel"):
			break_voxel(result)
			last_interact_time = current_time
		
		# Right click to place voxel
		if Input.is_action_just_pressed("place_voxel"):
			place_voxel(result)
			last_interact_time = current_time

func break_voxel(hit: Dictionary):
	var chunk = hit.collider as Chunk
	if not chunk:
		return
	
	var hit_point = hit.position - hit.normal * 0.5
	var local_pos = hit_point - chunk.global_position
	
	var x = floori(local_pos.x)
	var y = floori(local_pos.y)
	var z = floori(local_pos.z)
	
	# Verify the voxel coordinates are valid
	if x < 0 or x >= chunk.chunk_size or y < 0 or y >= chunk.chunk_size or z < 0 or z >= chunk.chunk_size:
		print("Invalid voxel coordinates: (%d, %d, %d)" % [x, y, z])
		return
	
	chunk.set_voxel(x, y, z, VoxelType.Type.AIR)
	print("Broke voxel at (%d, %d, %d)" % [x, y, z])

func place_voxel(hit: Dictionary):
	var chunk = hit.collider as Chunk
	if not chunk:
		return
	
	var hit_point = hit.position + hit.normal * 0.5
	var local_pos = hit_point - chunk.global_position
	
	var x = floori(local_pos.x)
	var y = floori(local_pos.y)
	var z = floori(local_pos.z)
	
	# Verify the voxel coordinates are valid
	if x < 0 or x >= chunk.chunk_size or y < 0 or y >= chunk.chunk_size or z < 0 or z >= chunk.chunk_size:
		print("Invalid voxel coordinates: (%d, %d, %d)" % [x, y, z])
		return
	
	chunk.set_voxel(x, y, z, VoxelType.Type.STONE)
	print("Placed voxel at (%d, %d, %d)" % [x, y, z])
