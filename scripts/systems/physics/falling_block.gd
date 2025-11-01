extends RigidBody3D
class_name FallingBlock

## Physics-based falling block (like sand/gravel in Minecraft)
## Falls when unsupported and can be placed back in the world

@export var voxel_type: int = 0
@export var settle_time: float = 2.0  # Time before converting back to static voxel

var has_settled: bool = false
var settle_timer: float = 0.0

func _ready():
	# Set physics properties
	mass = 2.0
	gravity_scale = 1.0
	contact_monitor = true
	max_contacts_reported = 4
	
	# Apply physics material
	if PhysicsManager:
		physics_material_override = PhysicsManager.get_physics_material("stone")
		PhysicsManager.set_collision_layer_and_mask(self, PhysicsManager.LAYER_ITEMS, PhysicsManager.LAYER_WORLD)
		PhysicsManager.register_rigid_body(self)
	
	# Connect signals
	sleeping_state_changed.connect(_on_sleeping_state_changed)

func _physics_process(delta):
	# Check if block has settled
	if sleeping and not has_settled:
		settle_timer += delta
		if settle_timer >= settle_time:
			settle_block()

func _on_sleeping_state_changed():
	if not sleeping:
		settle_timer = 0.0

func settle_block():
	"""Convert the falling block back to a static voxel"""
	if has_settled:
		return
	
	has_settled = true
	
	# Get the world generator to place the block
	var world_gen = get_tree().get_first_node_in_group("world_generator")
	if world_gen:
		var block_pos = global_position.round()
		# TODO: Place voxel back into chunk at this position
		print("FallingBlock settled at %s" % block_pos)
	
	queue_free()

func _exit_tree():
	# Unregister from physics manager
	if PhysicsManager:
		PhysicsManager.unregister_rigid_body(self)
