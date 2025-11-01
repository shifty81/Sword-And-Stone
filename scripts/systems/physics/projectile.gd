extends RigidBody3D
class_name Projectile

## Physics-based projectile
## Can be used for arrows, thrown items, etc.

@export var damage: float = 10.0
@export var lifetime: float = 10.0
@export var stick_to_surfaces: bool = true

var has_hit: bool = false
var spawn_time: float = 0.0

func _ready():
	# Set physics properties
	mass = 0.1
	gravity_scale = 0.5
	contact_monitor = true
	max_contacts_reported = 4
	
	# Apply physics material
	if PhysicsManager:
		physics_material_override = PhysicsManager.get_physics_material("metal")
		PhysicsManager.set_collision_layer_and_mask(
			self, 
			PhysicsManager.LAYER_PROJECTILES, 
			PhysicsManager.get_layer_mask(PhysicsManager.LAYER_WORLD) | PhysicsManager.get_layer_mask(PhysicsManager.LAYER_ENEMIES)
		)
		PhysicsManager.register_rigid_body(self)
	
	spawn_time = Time.get_ticks_msec() / 1000.0
	
	# Connect collision signal
	body_entered.connect(_on_body_entered)
	
	# Auto-cleanup after lifetime
	await get_tree().create_timer(lifetime).timeout
	if is_instance_valid(self):
		queue_free()

func _physics_process(delta):
	if not has_hit and linear_velocity.length() > 0.1:
		# Rotate to face direction of travel
		look_at(global_position + linear_velocity.normalized(), Vector3.UP)

func _on_body_entered(body: Node):
	if has_hit:
		return
	
	has_hit = true
	
	# Deal damage if hitting an enemy
	if body.has_method("take_damage"):
		body.take_damage(damage)
		print("Projectile hit %s for %d damage" % [body.name, damage])
	
	if stick_to_surfaces:
		# Stop physics and stick to surface
		freeze = true
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		
		# Fade out and remove after a delay
		await get_tree().create_timer(3.0).timeout
		if is_instance_valid(self):
			queue_free()
	else:
		# Just remove on impact
		queue_free()

func launch(direction: Vector3, speed: float):
	"""Launch the projectile in a direction"""
	linear_velocity = direction.normalized() * speed
	look_at(global_position + direction, Vector3.UP)

func _exit_tree():
	# Unregister from physics manager
	if PhysicsManager:
		PhysicsManager.unregister_rigid_body(self)
