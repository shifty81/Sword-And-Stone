extends CharacterBody2D
class_name TopDownPlayer

## Top-down player controller for the Crimson Isles

@export var move_speed: float = 200.0
@export var sprint_speed: float = 350.0

var is_sprinting: bool = false

func _ready():
	add_to_group("player")

func _physics_process(delta):
	# Get input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	
	# Check if sprinting
	is_sprinting = Input.is_action_pressed("sprint")
	
	# Calculate velocity
	var speed = sprint_speed if is_sprinting else move_speed
	velocity = input_dir * speed
	
	# Move
	move_and_slide()
	
	# Update sprite rotation to face movement direction
	if input_dir.length() > 0:
		rotation = input_dir.angle()
