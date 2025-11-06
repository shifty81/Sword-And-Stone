extends CanvasLayer
class_name IsometricHUD

## HUD for isometric game showing time, resources, and info

@onready var time_label = $TimeLabel
@onready var resources_label = $ResourcesLabel
@onready var controls_label = $ControlsLabel
@onready var build_mode_label = $BuildModeLabel

var day_night_cycle: DayNightCycle
var building_system: Node2D
var player: CharacterBody2D

func _ready():
	# Find references
	var root = get_tree().root
	day_night_cycle = find_node_recursive(root, "CanvasModulate") as DayNightCycle
	building_system = find_node_recursive(root, "BuildingSystem")
	player = find_node_recursive(root, "Player")
	
	# Update initial state
	update_hud()

func _process(delta):
	update_hud()

func update_hud():
	# Update time display
	if time_label and day_night_cycle:
		var time_str = day_night_cycle.get_time_string()
		var day_night = "☀️ Day" if day_night_cycle.is_day() else "🌙 Night"
		time_label.text = "Time: %s (%s)" % [time_str, day_night]
	
	# Update resources display
	if resources_label and building_system:
		var inventory = building_system.get_inventory()
		resources_label.text = "Resources:\n  Wood: %d\n  Stone: %d\n  Grass: %d" % [
			inventory.get("wood", 0),
			inventory.get("stone", 0),
			inventory.get("grass", 0)
		]
	
	# Update build mode indicator
	if build_mode_label and building_system:
		build_mode_label.visible = building_system.placement_mode

func find_node_recursive(node: Node, node_name: String) -> Node:
	if node.name == node_name:
		return node
	
	for child in node.get_children():
		var result = find_node_recursive(child, node_name)
		if result:
			return result
	
	return null
