extends Control
class_name HUD

## Main HUD for the game

@onready var crosshair = $Crosshair
@onready var debug_label = $DebugInfo

var player: PlayerController

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(_delta):
	update_debug_info()

func update_debug_info():
	if not player or not debug_label:
		return
	
	var pos = player.global_position
	var fps = Engine.get_frames_per_second()
	
	debug_label.text = "FPS: %d\nPosition: (%.1f, %.1f, %.1f)" % [
		fps,
		pos.x,
		pos.y,
		pos.z
	]
