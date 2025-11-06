extends CanvasModulate
class_name DayNightCycle

## Simple day/night cycle for isometric world
## Modulates canvas color to simulate time of day

@export var cycle_duration: float = 300.0  # 5 minutes per full cycle
@export var enable_cycle: bool = true

var time_of_day: float = 0.5  # 0=midnight, 0.5=noon, 1.0=midnight

# Color tints for different times of day
var midnight_color = Color(0.2, 0.2, 0.4, 1.0)
var dawn_color = Color(0.9, 0.6, 0.5, 1.0)
var noon_color = Color(1.0, 1.0, 1.0, 1.0)
var dusk_color = Color(0.9, 0.5, 0.3, 1.0)

func _ready():
	# Start at noon for better initial visibility
	time_of_day = 0.5
	update_lighting()

func _process(delta):
	if not enable_cycle:
		return
	
	# Advance time
	time_of_day += delta / cycle_duration
	
	# Wrap around
	if time_of_day >= 1.0:
		time_of_day -= 1.0
	
	update_lighting()

func update_lighting():
	# Calculate current color based on time of day
	var current_color: Color
	
	if time_of_day < 0.25:
		# Midnight to dawn (0.0 - 0.25)
		var t = time_of_day / 0.25
		current_color = midnight_color.lerp(dawn_color, t)
	elif time_of_day < 0.5:
		# Dawn to noon (0.25 - 0.5)
		var t = (time_of_day - 0.25) / 0.25
		current_color = dawn_color.lerp(noon_color, t)
	elif time_of_day < 0.75:
		# Noon to dusk (0.5 - 0.75)
		var t = (time_of_day - 0.5) / 0.25
		current_color = noon_color.lerp(dusk_color, t)
	else:
		# Dusk to midnight (0.75 - 1.0)
		var t = (time_of_day - 0.75) / 0.25
		current_color = dusk_color.lerp(midnight_color, t)
	
	color = current_color

func get_time_string() -> String:
	var hour = int(time_of_day * 24.0)
	var minute = int((time_of_day * 24.0 - hour) * 60.0)
	return "%02d:%02d" % [hour, minute]

func is_day() -> bool:
	return time_of_day > 0.25 and time_of_day < 0.75

func is_night() -> bool:
	return not is_day()

func set_time(t: float):
	time_of_day = clamp(t, 0.0, 1.0)
	update_lighting()
