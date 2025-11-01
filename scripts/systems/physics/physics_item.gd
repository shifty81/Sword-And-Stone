extends RigidBody3D
class_name PhysicsItem

## Physics-based item that can be picked up
## Used for dropped items, collectibles, etc.

@export var item_id: String = ""
@export var item_name: String = "Item"
@export var auto_pickup_radius: float = 2.0
@export var pickup_delay: float = 0.5  # Seconds before item can be picked up

var can_be_picked_up: bool = false
var spawn_time: float = 0.0

func _ready():
	# Set physics properties
	mass = 0.5
	gravity_scale = 1.0
	
	# Apply physics material from PhysicsManager
	if PhysicsManager:
		physics_material_override = PhysicsManager.get_physics_material("stone")
		PhysicsManager.set_collision_layer_and_mask(
			self, 
			PhysicsManager.LAYER_ITEMS, 
			PhysicsManager.get_layer_mask(PhysicsManager.LAYER_WORLD)
		)
		PhysicsManager.register_rigid_body(self)
	
	# Set spawn time
	spawn_time = Time.get_ticks_msec() / 1000.0
	
	# Enable pickup after delay
	await get_tree().create_timer(pickup_delay).timeout
	can_be_picked_up = true

func _process(delta):
	if not can_be_picked_up:
		return
	
	# Check for nearby player
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance < auto_pickup_radius:
			pickup(player)

func pickup(player):
	"""Called when the item is picked up by the player"""
	print("Item '%s' picked up by player" % item_name)
	# TODO: Add to player inventory
	queue_free()

func _exit_tree():
	# Unregister from physics manager
	if PhysicsManager:
		PhysicsManager.unregister_rigid_body(self)
