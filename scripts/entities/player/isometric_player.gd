extends CharacterBody2D
class_name IsometricPlayer

## Isometric player controller with 8-directional movement
## Handles WASD input for natural isometric movement

@export var move_speed: float = 200.0
@export var sprint_speed: float = 350.0

@export_group("Animation")
@export var sprite: Sprite2D  # Reference to sprite for animations
@export var animated_sprite: AnimatedSprite2D  # Alternative: use AnimatedSprite2D

var is_sprinting: bool = false
var last_direction: Vector2 = Vector2.DOWN  # Track facing direction

# Direction enum for 8-way movement
enum Direction {
	SOUTH,
	SOUTH_EAST,
	EAST,
	NORTH_EAST,
	NORTH,
	NORTH_WEST,
	WEST,
	SOUTH_WEST
}

func _ready():
	add_to_group("player")
	
	# Get sprite reference if not set
	if not sprite and not animated_sprite:
		sprite = $Sprite2D if has_node("Sprite2D") else null
		animated_sprite = $AnimatedSprite2D if has_node("AnimatedSprite2D") else null

func _physics_process(delta):
	# Get raw WASD input
	var input_x = Input.get_axis("move_left", "move_right")
	var input_y = Input.get_axis("move_forward", "move_back")
	var input_dir = Vector2(input_x, input_y).normalized()
	
	# Check if sprinting
	is_sprinting = Input.is_action_pressed("sprint")
	
	# Convert to isometric coordinates
	# In isometric view, moving "right" moves down-right, "up" moves up-right, etc.
	var iso_dir = cartesian_to_isometric(input_dir)
	
	# Calculate velocity
	var speed = sprint_speed if is_sprinting else move_speed
	velocity = iso_dir * speed
	
	# Move the player
	move_and_slide()
	
	# Update facing direction and animation
	if input_dir.length() > 0.1:
		last_direction = input_dir
		update_animation(input_dir)

## Convert cartesian input to isometric movement direction
func cartesian_to_isometric(cart_dir: Vector2) -> Vector2:
	if cart_dir.length() < 0.01:
		return Vector2.ZERO
	
	# Isometric projection transformation
	# Right in screen space = move down-right in world
	# Up in screen space = move up-right in world
	var iso_x = cart_dir.x - cart_dir.y
	var iso_y = (cart_dir.x + cart_dir.y) * 0.5
	
	return Vector2(iso_x, iso_y).normalized()

## Update sprite animation based on movement direction
func update_animation(dir: Vector2):
	var direction = get_8_direction(dir)
	
	# If using AnimatedSprite2D
	if animated_sprite:
		update_animated_sprite(direction)
	# If using simple Sprite2D with rotation
	elif sprite:
		update_simple_sprite(direction)

## Get 8-way direction from vector
func get_8_direction(dir: Vector2) -> Direction:
	var angle = dir.angle()
	
	# Convert angle to 8 directions
	# Angle is in radians, 0 = right, PI/2 = down
	var angle_deg = rad_to_deg(angle)
	if angle_deg < 0:
		angle_deg += 360
	
	# Divide 360 degrees into 8 sections (45 degrees each)
	var section = int((angle_deg + 22.5) / 45.0) % 8
	
	match section:
		0: return Direction.EAST
		1: return Direction.SOUTH_EAST
		2: return Direction.SOUTH
		3: return Direction.SOUTH_WEST
		4: return Direction.WEST
		5: return Direction.NORTH_WEST
		6: return Direction.NORTH
		7: return Direction.NORTH_EAST
		_: return Direction.SOUTH

## Update AnimatedSprite2D with 8-directional animations
func update_animated_sprite(direction: Direction):
	# Animation naming convention: "walk_south", "walk_north_east", "idle_west", etc.
	var anim_prefix = "walk" if velocity.length() > 10 else "idle"
	var dir_suffix = get_direction_suffix(direction)
	var anim_name = anim_prefix + "_" + dir_suffix
	
	if animated_sprite.sprite_frames.has_animation(anim_name):
		animated_sprite.play(anim_name)
	else:
		# Fallback to 4-way animations if 8-way not available
		var simple_dir = get_4_direction_suffix(direction)
		var fallback_name = anim_prefix + "_" + simple_dir
		if animated_sprite.sprite_frames.has_animation(fallback_name):
			animated_sprite.play(fallback_name)

## Update simple sprite with rotation (for prototype)
func update_simple_sprite(direction: Direction):
	# Simple rotation for prototype
	# You can replace this with sprite sheet frames later
	var rotation_angles = {
		Direction.SOUTH: 90,
		Direction.SOUTH_EAST: 45,
		Direction.EAST: 0,
		Direction.NORTH_EAST: -45,
		Direction.NORTH: -90,
		Direction.NORTH_WEST: -135,
		Direction.WEST: 180,
		Direction.SOUTH_WEST: 135
	}
	
	if sprite and rotation_angles.has(direction):
		sprite.rotation_degrees = rotation_angles[direction]

## Get direction suffix for animation names
func get_direction_suffix(direction: Direction) -> String:
	match direction:
		Direction.SOUTH: return "south"
		Direction.SOUTH_EAST: return "south_east"
		Direction.EAST: return "east"
		Direction.NORTH_EAST: return "north_east"
		Direction.NORTH: return "north"
		Direction.NORTH_WEST: return "north_west"
		Direction.WEST: return "west"
		Direction.SOUTH_WEST: return "south_west"
		_: return "south"

## Get 4-direction suffix as fallback
func get_4_direction_suffix(direction: Direction) -> String:
	match direction:
		Direction.SOUTH, Direction.SOUTH_EAST, Direction.SOUTH_WEST:
			return "south"
		Direction.NORTH, Direction.NORTH_EAST, Direction.NORTH_WEST:
			return "north"
		Direction.EAST:
			return "east"
		Direction.WEST:
			return "west"
		_:
			return "south"

## Get current position in world tile coordinates
func get_tile_position() -> Vector2i:
	# Convert world position to tile coordinates
	# Assuming tile size of 64x32 for isometric
	return Vector2i(int(position.x / 64), int(position.y / 32))
