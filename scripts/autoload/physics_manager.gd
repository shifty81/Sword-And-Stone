extends Node

## Physics Manager
## Centralized physics management for the game
## Handles physics materials, layers, and dynamic objects

# Physics layers as constants for easy reference
const LAYER_WORLD: int = 1
const LAYER_PLAYER: int = 2
const LAYER_ITEMS: int = 3
const LAYER_PROJECTILES: int = 4
const LAYER_ENEMIES: int = 5
const LAYER_TRIGGERS: int = 6
const LAYER_INTERACTABLES: int = 7

# Physics materials
var physics_materials: Dictionary = {}

# Active physics objects tracking
var active_rigid_bodies: Array[RigidBody3D] = []
var active_areas: Array[Area3D] = []

func _ready():
	print("PhysicsManager: Initializing...")
	create_physics_materials()
	print("PhysicsManager: Ready")

func create_physics_materials():
	"""Create physics materials for different surface types"""
	
	# Stone - high friction, no bounce
	var stone_material = PhysicsMaterial.new()
	stone_material.friction = 0.8
	stone_material.bounce = 0.0
	physics_materials["stone"] = stone_material
	
	# Grass - medium friction, no bounce
	var grass_material = PhysicsMaterial.new()
	grass_material.friction = 0.6
	grass_material.bounce = 0.0
	physics_materials["grass"] = grass_material
	
	# Ice - very low friction, no bounce
	var ice_material = PhysicsMaterial.new()
	ice_material.friction = 0.1
	ice_material.bounce = 0.0
	physics_materials["ice"] = ice_material
	
	# Metal - medium friction, some bounce
	var metal_material = PhysicsMaterial.new()
	metal_material.friction = 0.5
	metal_material.bounce = 0.3
	physics_materials["metal"] = metal_material
	
	# Wood - medium-high friction, small bounce
	var wood_material = PhysicsMaterial.new()
	wood_material.friction = 0.7
	wood_material.bounce = 0.1
	physics_materials["wood"] = wood_material
	
	# Rubber - high friction, high bounce
	var rubber_material = PhysicsMaterial.new()
	rubber_material.friction = 0.9
	rubber_material.bounce = 0.8
	physics_materials["rubber"] = rubber_material
	
	print("PhysicsManager: Created %d physics materials" % physics_materials.size())

func get_physics_material(material_name: String) -> PhysicsMaterial:
	"""Get a physics material by name"""
	if physics_materials.has(material_name):
		return physics_materials[material_name]
	
	push_warning("PhysicsManager: Physics material '%s' not found, returning default" % material_name)
	return null

func register_rigid_body(body: RigidBody3D):
	"""Register a RigidBody3D for tracking and management"""
	if not active_rigid_bodies.has(body):
		active_rigid_bodies.append(body)
		body.tree_exited.connect(_on_rigid_body_removed.bind(body))

func unregister_rigid_body(body: RigidBody3D):
	"""Unregister a RigidBody3D"""
	var index = active_rigid_bodies.find(body)
	if index != -1:
		active_rigid_bodies.remove_at(index)

func _on_rigid_body_removed(body: RigidBody3D):
	"""Callback when a RigidBody3D is removed from the scene tree"""
	unregister_rigid_body(body)

func register_area(area: Area3D):
	"""Register an Area3D for tracking"""
	if not active_areas.has(area):
		active_areas.append(area)
		area.tree_exited.connect(_on_area_removed.bind(area))

func unregister_area(area: Area3D):
	"""Unregister an Area3D"""
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)

func _on_area_removed(area: Area3D):
	"""Callback when an Area3D is removed from the scene tree"""
	unregister_area(area)

func get_layer_mask(layer: int) -> int:
	"""Convert a layer number to a layer mask bit"""
	return 1 << (layer - 1)

func set_collision_layer_and_mask(node: CollisionObject3D, layer: int, mask: int = 0):
	"""Helper to set collision layer and mask on a CollisionObject3D"""
	node.collision_layer = get_layer_mask(layer)
	if mask > 0:
		node.collision_mask = get_layer_mask(mask)
	else:
		# Default: collide with everything except self
		node.collision_mask = 0xFFFFFFFF & ~get_layer_mask(layer)

func create_item_drop(item_position: Vector3, item_type: int = 0) -> RigidBody3D:
	"""Create a physics-based item drop that can be picked up"""
	var item = RigidBody3D.new()
	item.position = item_position
	
	# Add collision shape
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = Vector3(0.3, 0.3, 0.3)
	collision.shape = shape
	item.add_child(collision)
	
	# Add visual mesh
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(0.3, 0.3, 0.3)
	mesh_instance.mesh = box_mesh
	item.add_child(mesh_instance)
	
	# Configure physics properties
	item.mass = 0.5
	item.physics_material_override = get_physics_material("stone")
	set_collision_layer_and_mask(item, LAYER_ITEMS, LAYER_WORLD)
	
	# Add custom data for item type
	item.set_meta("item_type", item_type)
	item.set_meta("is_item_drop", true)
	
	# Register with manager
	register_rigid_body(item)
	
	return item

func create_projectile(start_position: Vector3, direction: Vector3, speed: float = 20.0) -> RigidBody3D:
	"""Create a physics-based projectile"""
	var projectile = RigidBody3D.new()
	projectile.position = start_position
	projectile.gravity_scale = 0.5
	
	# Add collision shape
	var collision = CollisionShape3D.new()
	var shape = SphereShape3D.new()
	shape.radius = 0.1
	collision.shape = shape
	projectile.add_child(collision)
	
	# Add visual mesh
	var mesh_instance = MeshInstance3D.new()
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = 0.1
	sphere_mesh.height = 0.2
	mesh_instance.mesh = sphere_mesh
	projectile.add_child(mesh_instance)
	
	# Configure physics
	projectile.mass = 0.1
	projectile.physics_material_override = get_physics_material("metal")
	set_collision_layer_and_mask(projectile, LAYER_PROJECTILES, LAYER_WORLD | LAYER_ENEMIES)
	
	# Apply initial velocity
	projectile.linear_velocity = direction.normalized() * speed
	
	# Add metadata
	projectile.set_meta("is_projectile", true)
	projectile.set_meta("spawn_time", Time.get_ticks_msec())
	
	# Register with manager
	register_rigid_body(projectile)
	
	# Auto-cleanup after 10 seconds
	await get_tree().create_timer(10.0).timeout
	if is_instance_valid(projectile):
		projectile.queue_free()
	
	return projectile

func create_falling_block(block_position: Vector3, voxel_type: int) -> RigidBody3D:
	"""Create a falling block that respects physics"""
	var block = RigidBody3D.new()
	block.position = block_position
	
	# Add collision shape
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = Vector3(1.0, 1.0, 1.0)
	collision.shape = shape
	block.add_child(collision)
	
	# Add visual mesh
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(1.0, 1.0, 1.0)
	mesh_instance.mesh = box_mesh
	block.add_child(mesh_instance)
	
	# Configure physics
	block.mass = 2.0
	block.physics_material_override = get_physics_material("stone")
	set_collision_layer_and_mask(block, LAYER_ITEMS, LAYER_WORLD)
	
	# Add metadata
	block.set_meta("is_falling_block", true)
	block.set_meta("voxel_type", voxel_type)
	
	# Register with manager
	register_rigid_body(block)
	
	return block

func get_active_physics_objects_count() -> Dictionary:
	"""Get counts of active physics objects"""
	return {
		"rigid_bodies": active_rigid_bodies.size(),
		"areas": active_areas.size()
	}

func cleanup_sleeping_objects():
	"""Remove objects that have been sleeping for a while to save performance"""
	var removed_count = 0
	for body in active_rigid_bodies.duplicate():
		if is_instance_valid(body) and body.sleeping:
			# Check if it has been sleeping for a while
			if body.has_meta("sleep_time"):
				var sleep_time = body.get_meta("sleep_time")
				if Time.get_ticks_msec() - sleep_time > 5000:  # 5 seconds
					body.queue_free()
					removed_count += 1
			else:
				body.set_meta("sleep_time", Time.get_ticks_msec())
	
	if removed_count > 0:
		print("PhysicsManager: Cleaned up %d sleeping objects" % removed_count)
