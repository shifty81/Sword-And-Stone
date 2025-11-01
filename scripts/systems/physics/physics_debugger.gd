extends Node3D
class_name PhysicsDebugger

## Debug visualizer for physics objects
## Shows collision shapes, velocities, and other physics info

@export var enabled: bool = false
@export var show_collision_shapes: bool = true
@export var show_velocities: bool = true
@export var show_centers_of_mass: bool = true
@export var velocity_scale: float = 0.1

var debug_meshes: Dictionary = {}

func _ready():
	# Only run in debug builds
	if not OS.is_debug_build():
		enabled = false

func _process(delta):
	if not enabled:
		clear_debug_visuals()
		return
	
	clear_debug_visuals()
	
	if PhysicsManager:
		# Debug rigid bodies
		for body in PhysicsManager.active_rigid_bodies:
			if is_instance_valid(body):
				debug_rigid_body(body)

func debug_rigid_body(body: RigidBody3D):
	"""Draw debug information for a RigidBody3D"""
	
	# Show velocity vector
	if show_velocities and body.linear_velocity.length() > 0.1:
		draw_velocity_arrow(body.global_position, body.linear_velocity)
	
	# Show center of mass
	if show_centers_of_mass:
		draw_sphere(body.global_position, 0.1, Color.YELLOW)
	
	# Show collision shapes
	if show_collision_shapes:
		for child in body.get_children():
			if child is CollisionShape3D:
				debug_collision_shape(child)

func debug_collision_shape(collision_shape: CollisionShape3D):
	"""Draw debug visualization for a collision shape"""
	var shape = collision_shape.shape
	if not shape:
		return
	
	var pos = collision_shape.global_position
	
	if shape is BoxShape3D:
		draw_box(pos, shape.size, Color.GREEN)
	elif shape is SphereShape3D:
		draw_sphere(pos, shape.radius, Color.GREEN)
	elif shape is CapsuleShape3D:
		draw_capsule(pos, shape.radius, shape.height, Color.GREEN)

func draw_velocity_arrow(pos: Vector3, velocity: Vector3):
	"""Draw an arrow showing velocity"""
	var end_pos = pos + velocity * velocity_scale
	var immediate_mesh = ImmediateMesh.new()
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = immediate_mesh
	add_child(mesh_instance)
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_add_vertex(pos)
	immediate_mesh.surface_add_vertex(end_pos)
	immediate_mesh.surface_end()
	
	debug_meshes[mesh_instance] = true

func draw_sphere(pos: Vector3, radius: float, color: Color):
	"""Draw a debug sphere"""
	var mesh_instance = MeshInstance3D.new()
	var sphere_mesh = SphereMesh.new()
	sphere_mesh.radius = radius
	sphere_mesh.height = radius * 2
	mesh_instance.mesh = sphere_mesh
	mesh_instance.position = pos
	add_child(mesh_instance)
	
	# Create material
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color.a = 0.3
	mesh_instance.set_surface_override_material(0, material)
	
	debug_meshes[mesh_instance] = true

func draw_box(pos: Vector3, size: Vector3, color: Color):
	"""Draw a debug box"""
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = size
	mesh_instance.mesh = box_mesh
	mesh_instance.position = pos
	add_child(mesh_instance)
	
	# Create material
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color.a = 0.3
	mesh_instance.set_surface_override_material(0, material)
	
	debug_meshes[mesh_instance] = true

func draw_capsule(pos: Vector3, radius: float, height: float, color: Color):
	"""Draw a debug capsule"""
	var mesh_instance = MeshInstance3D.new()
	var capsule_mesh = CapsuleMesh.new()
	capsule_mesh.radius = radius
	capsule_mesh.height = height
	mesh_instance.mesh = capsule_mesh
	mesh_instance.position = pos
	add_child(mesh_instance)
	
	# Create material
	var material = StandardMaterial3D.new()
	material.albedo_color = color
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color.a = 0.3
	mesh_instance.set_surface_override_material(0, material)
	
	debug_meshes[mesh_instance] = true

func clear_debug_visuals():
	"""Remove all debug visualization meshes"""
	for mesh in debug_meshes.keys():
		if is_instance_valid(mesh):
			mesh.queue_free()
	debug_meshes.clear()

func toggle_debug():
	"""Toggle debug visualization"""
	enabled = not enabled
	print("Physics debug: %s" % ("enabled" if enabled else "disabled"))
