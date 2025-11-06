extends Node2D
class_name IsometricBuildingSystem

## System for placing modular building pieces in isometric world
## Allows players to build shelters with walls, floors, roofs, etc.

signal building_placed(building_type: String, position: Vector2i)
signal building_removed(position: Vector2i)

@export var tile_map: TileMap
@export var build_layer: int = 3  # Layer for placed buildings
@export var preview_modulate: Color = Color(1, 1, 1, 0.7)

# Building piece types
enum BuildingType {
	WALL_WOOD,
	WALL_STONE,
	FLOOR_WOOD,
	FLOOR_STONE,
	ROOF_THATCH,
	ROOF_TILE,
	DOOR_WOOD,
	WINDOW,
}

# Mapping building types to tileset atlas coordinates
var building_atlas_coords = {
	BuildingType.WALL_WOOD: Vector2i(2, 1),     # Wood tile
	BuildingType.WALL_STONE: Vector2i(0, 2),    # Cobblestone
	BuildingType.FLOOR_WOOD: Vector2i(2, 1),    # Wood
	BuildingType.FLOOR_STONE: Vector2i(0, 1),   # Stone
	BuildingType.ROOF_THATCH: Vector2i(2, 1),   # Wood/thatch color
	BuildingType.ROOF_TILE: Vector2i(0, 2),     # Cobblestone for tiles
	BuildingType.DOOR_WOOD: Vector2i(2, 1),     # Wood
	BuildingType.WINDOW: Vector2i(0, 1),        # Stone frame
}

# Building costs (simplified)
var building_costs = {
	BuildingType.WALL_WOOD: {"wood": 2},
	BuildingType.WALL_STONE: {"stone": 3},
	BuildingType.FLOOR_WOOD: {"wood": 1},
	BuildingType.FLOOR_STONE: {"stone": 2},
	BuildingType.ROOF_THATCH: {"wood": 1, "grass": 2},
	BuildingType.ROOF_TILE: {"stone": 2},
	BuildingType.DOOR_WOOD: {"wood": 3},
	BuildingType.WINDOW: {"wood": 1, "stone": 1},
}

var current_building_type: BuildingType = BuildingType.WALL_WOOD
var placement_mode: bool = false
var preview_position: Vector2i = Vector2i.ZERO
var player_inventory: Dictionary = {}  # Simplified inventory

func _ready():
	# Initialize with some resources for testing
	player_inventory = {
		"wood": 100,
		"stone": 100,
		"grass": 50
	}

func _process(delta):
	if placement_mode:
		update_preview()
		
		# Place building on left click
		if Input.is_action_just_pressed("break_voxel"):  # Left click
			try_place_building()
		
		# Remove building on right click
		if Input.is_action_just_pressed("place_voxel"):  # Right click
			try_remove_building()
		
		# Cancel placement on ESC
		if Input.is_action_just_pressed("ui_cancel"):
			set_placement_mode(false)

func _input(event):
	# Toggle placement mode with 'B' key
	if event is InputEventKey and event.pressed and event.keycode == KEY_B:
		set_placement_mode(not placement_mode)

func set_placement_mode(enabled: bool):
	placement_mode = enabled
	if enabled:
		print("Building mode ENABLED - Move mouse to place, ESC to cancel")
	else:
		clear_preview()
		print("Building mode DISABLED")

func update_preview():
	if not tile_map:
		return
	
	# Get mouse position in world space
	var mouse_pos = get_global_mouse_position()
	
	# Convert to tile coordinates
	var tile_pos = world_to_tile(mouse_pos)
	
	# Only update if position changed
	if tile_pos != preview_position:
		clear_preview()
		preview_position = tile_pos
		show_preview()

func show_preview():
	if not tile_map:
		return
	
	# Show semi-transparent preview of building piece
	var atlas_coords = building_atlas_coords[current_building_type]
	
	# Place preview on a temporary layer or use modulation
	# For simplicity, we'll use a marker
	# In a full implementation, you'd use a separate TileMap overlay

func clear_preview():
	# Clear preview visuals
	pass

func try_place_building() -> bool:
	if not tile_map:
		return false
	
	# Check if position is valid
	if not is_valid_placement_position(preview_position):
		print("Cannot place building here!")
		return false
	
	# Check if player has resources
	if not has_required_resources(current_building_type):
		print("Not enough resources!")
		return false
	
	# Deduct resources
	deduct_resources(current_building_type)
	
	# Place the building
	var atlas_coords = building_atlas_coords[current_building_type]
	tile_map.set_cell(build_layer, preview_position, 0, atlas_coords)
	
	print("Building placed at: ", preview_position)
	building_placed.emit(BuildingType.keys()[current_building_type], preview_position)
	
	return true

func try_remove_building() -> bool:
	if not tile_map:
		return false
	
	# Check if there's a building at this position
	var cell_data = tile_map.get_cell_source_id(build_layer, preview_position)
	if cell_data == -1:
		print("No building to remove here!")
		return false
	
	# Remove the building
	tile_map.erase_cell(build_layer, preview_position)
	
	# Optionally refund some resources
	refund_resources(current_building_type, 0.5)  # 50% refund
	
	print("Building removed from: ", preview_position)
	building_removed.emit(preview_position)
	
	return true

func is_valid_placement_position(tile_pos: Vector2i) -> bool:
	if not tile_map:
		return false
	
	# Check if there's already a building here
	var existing = tile_map.get_cell_source_id(build_layer, tile_pos)
	if existing != -1:
		return false
	
	# Check if there's valid ground (not water)
	var terrain = tile_map.get_cell_source_id(0, tile_pos)
	if terrain == -1:
		return false  # No terrain
	
	# Add more validation as needed (not in water, etc.)
	
	return true

func has_required_resources(building_type: BuildingType) -> bool:
	var costs = building_costs[building_type]
	
	for resource in costs:
		var required = costs[resource]
		var available = player_inventory.get(resource, 0)
		
		if available < required:
			return false
	
	return true

func deduct_resources(building_type: BuildingType):
	var costs = building_costs[building_type]
	
	for resource in costs:
		var required = costs[resource]
		player_inventory[resource] -= required

func refund_resources(building_type: BuildingType, refund_percent: float = 0.5):
	var costs = building_costs[building_type]
	
	for resource in costs:
		var required = costs[resource]
		var refund = int(required * refund_percent)
		player_inventory[resource] = player_inventory.get(resource, 0) + refund

func set_building_type(building_type: BuildingType):
	current_building_type = building_type
	print("Building type set to: ", BuildingType.keys()[building_type])

func world_to_tile(world_pos: Vector2) -> Vector2i:
	# Convert world coordinates to isometric tile coordinates
	# This is a simplified conversion - adjust based on your tile size
	var tile_width = 64
	var tile_height = 32
	
	# Inverse isometric projection
	var x = (world_pos.x / tile_width + world_pos.y / tile_height)
	var y = (world_pos.y / tile_height - world_pos.x / tile_width)
	
	return Vector2i(int(x), int(y))

func get_inventory() -> Dictionary:
	return player_inventory

func add_resource(resource: String, amount: int):
	player_inventory[resource] = player_inventory.get(resource, 0) + amount
	print("Added ", amount, " ", resource, " (Total: ", player_inventory[resource], ")")
