extends Area3D
class_name PhysicsTrigger

## Physics trigger area for environmental effects
## Can be used for wind zones, damage areas, teleporters, etc.

@export_enum("Wind", "Damage", "Heal", "Bounce", "Teleport", "SlowMotion") var trigger_type: String = "Wind"
@export var trigger_strength: float = 10.0
@export var trigger_direction: Vector3 = Vector3.UP
@export var affect_player: bool = true
@export var affect_items: bool = true
@export var affect_projectiles: bool = true

var affected_bodies: Array[RigidBody3D] = []

func _ready():
	# Configure collision layers
	if PhysicsManager:
		var mask = 0
		if affect_player:
			mask |= PhysicsManager.get_layer_mask(PhysicsManager.LAYER_PLAYER)
		if affect_items:
			mask |= PhysicsManager.get_layer_mask(PhysicsManager.LAYER_ITEMS)
		if affect_projectiles:
			mask |= PhysicsManager.get_layer_mask(PhysicsManager.LAYER_PROJECTILES)
		
		collision_layer = PhysicsManager.get_layer_mask(PhysicsManager.LAYER_TRIGGERS)
		collision_mask = mask
		
		PhysicsManager.register_area(self)
	
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Enable monitoring
	monitoring = true

func _physics_process(delta):
	# Apply effects to bodies in the trigger
	for body in affected_bodies:
		if is_instance_valid(body):
			apply_effect(body, delta)

func _on_body_entered(body: Node3D):
	if body is RigidBody3D:
		affected_bodies.append(body)
		on_trigger_enter(body)

func _on_body_exited(body: Node3D):
	if body is RigidBody3D:
		var index = affected_bodies.find(body)
		if index != -1:
			affected_bodies.remove_at(index)
		on_trigger_exit(body)

func on_trigger_enter(body: RigidBody3D):
	"""Called when a body enters the trigger"""
	match trigger_type:
		"Bounce":
			apply_bounce(body)
		"Teleport":
			apply_teleport(body)

func on_trigger_exit(body: RigidBody3D):
	"""Called when a body exits the trigger"""
	pass

func apply_effect(body: RigidBody3D, delta: float):
	"""Apply continuous effect to body"""
	match trigger_type:
		"Wind":
			apply_wind(body, delta)
		"Damage":
			apply_damage(body, delta)
		"Heal":
			apply_heal(body, delta)
		"SlowMotion":
			apply_slow_motion(body, delta)

func apply_wind(body: RigidBody3D, delta: float):
	"""Apply wind force to body"""
	var force = trigger_direction.normalized() * trigger_strength
	body.apply_central_force(force)

func apply_damage(body: RigidBody3D, delta: float):
	"""Apply damage to body"""
	if body.has_method("take_damage"):
		body.take_damage(trigger_strength * delta)

func apply_heal(body: RigidBody3D, delta: float):
	"""Apply healing to body"""
	if body.has_method("heal"):
		body.heal(trigger_strength * delta)

func apply_bounce(body: RigidBody3D):
	"""Apply bounce impulse to body"""
	var impulse = trigger_direction.normalized() * trigger_strength
	body.apply_central_impulse(impulse)

func apply_teleport(body: RigidBody3D):
	"""Teleport body to target location"""
	# TODO: Implement teleport logic
	pass

func apply_slow_motion(body: RigidBody3D, delta: float):
	"""Apply slow motion effect to body"""
	# Reduce velocity
	body.linear_velocity *= (1.0 - trigger_strength * delta)

func _exit_tree():
	# Unregister from physics manager
	if PhysicsManager:
		PhysicsManager.unregister_area(self)
