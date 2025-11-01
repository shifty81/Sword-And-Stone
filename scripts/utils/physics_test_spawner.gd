extends Node3D

## Physics test spawner for demonstrating the physics engine
## Press keys to spawn different physics objects

@export var spawn_distance: float = 5.0
@export var spawn_height: float = 10.0

var player: Node3D = null

func _ready():
	print("PhysicsTestSpawner ready! Controls:")
	print("  1 - Spawn physics item")
	print("  2 - Spawn projectile")
	print("  3 - Spawn falling block")
	print("  4 - Spawn bouncy ball")
	print("  5 - Toggle physics debug")

func _process(_delta):
	# Get player reference
	if not player:
		player = get_tree().get_first_node_in_group("player")
		return
	
	# Handle input
	if Input.is_action_just_pressed("ui_text_backspace"):
		# Clean up all spawned objects
		cleanup_physics_objects()
	
	# Spawn different physics objects
	if Input.is_key_pressed(KEY_1):
		spawn_physics_item()
	
	if Input.is_key_pressed(KEY_2):
		spawn_projectile()
	
	if Input.is_key_pressed(KEY_3):
		spawn_falling_block()
	
	if Input.is_key_pressed(KEY_4):
		spawn_bouncy_ball()
	
	if Input.is_key_pressed(KEY_5):
		toggle_physics_debug()

func get_spawn_position() -> Vector3:
	"""Get a position in front of the player"""
	if not player:
		return Vector3(0, spawn_height, 0)
	
	var forward = -player.global_transform.basis.z
	return player.global_position + forward * spawn_distance + Vector3.UP * 2

func spawn_physics_item():
	"""Spawn a physics item that can be picked up"""
	var item = PhysicsManager.create_item_drop(get_spawn_position(), 1)
	get_tree().root.add_child(item)
	print("Spawned physics item")

func spawn_projectile():
	"""Spawn a projectile"""
	if not player or not player.has_node("CameraPivot/Camera"):
		return
	
	var camera = player.get_node("CameraPivot/Camera")
	var forward = -camera.global_transform.basis.z
	var projectile = PhysicsManager.create_projectile(
		camera.global_position,
		forward,
		30.0
	)
	get_tree().root.add_child(projectile)
	print("Spawned projectile")

func spawn_falling_block():
	"""Spawn a falling block"""
	var block = PhysicsManager.create_falling_block(
		get_spawn_position() + Vector3.UP * spawn_height,
		1  # VoxelType
	)
	get_tree().root.add_child(block)
	print("Spawned falling block")

func spawn_bouncy_ball():
	"""Spawn a bouncy ball to test physics materials"""
	var ball = RigidBody3D.new()
	ball.position = get_spawn_position() + Vector3.UP * spawn_height
	
	# Add collision shape
	var collision = CollisionShape3D.new()
	var shape = SphereShape3D.new()
	shape.radius = 0.5
	collision.shape = shape
	ball.add_child(collision)
	
	# Add visual mesh
	var mesh_instance = MeshInstance3D.new()
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = 0.5
	sphere_mesh.height = 1.0
	mesh_instance.mesh = sphere_mesh
	ball.add_child(mesh_instance)
	
	# Configure physics with rubber material for bounce
	ball.mass = 0.5
	ball.physics_material_override = PhysicsManager.get_physics_material("rubber")
	PhysicsManager.set_collision_layer_and_mask(ball, PhysicsManager.LAYER_ITEMS, PhysicsManager.LAYER_WORLD)
	PhysicsManager.register_rigid_body(ball)
	
	get_tree().root.add_child(ball)
	print("Spawned bouncy ball")

func cleanup_physics_objects():
	"""Remove all spawned physics objects"""
	if PhysicsManager:
		var count = 0
		for body in PhysicsManager.active_rigid_bodies.duplicate():
			if is_instance_valid(body):
				body.queue_free()
				count += 1
		print("Cleaned up %d physics objects" % count)

func toggle_physics_debug():
	"""Toggle physics debug visualization"""
	# Find or create physics debugger
	var debugger = get_tree().root.get_node_or_null("PhysicsDebugger")
	if not debugger:
		debugger = PhysicsDebugger.new()
		debugger.name = "PhysicsDebugger"
		get_tree().root.add_child(debugger)
	
	debugger.toggle_debug()
