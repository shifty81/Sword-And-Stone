extends Node2D
class_name WaterAnimator

## Animates water tiles to make them feel alive
## Creates subtle wave effects on water surfaces

@export var tile_map: TileMap
@export var water_layer: int = 0
@export var wave_speed: float = 1.0
@export var wave_amplitude: float = 0.05

var time: float = 0.0
var water_tiles: Array[Vector2i] = []

func _ready():
	if tile_map:
		find_water_tiles()

func find_water_tiles():
	# Find all water tiles in the map
	var used_cells = tile_map.get_used_cells(water_layer)
	
	for cell_pos in used_cells:
		var atlas_coords = tile_map.get_cell_atlas_coords(water_layer, cell_pos)
		# Check if it's a water tile (atlas coords 0,0)
		if atlas_coords == Vector2i(0, 0):
			water_tiles.append(cell_pos)
	
	print("Found ", water_tiles.size(), " water tiles to animate")

func _process(delta):
	if water_tiles.size() == 0:
		return
	
	time += delta * wave_speed
	
	# Animate water tiles with subtle modulation
	# In a full implementation, you'd use a shader for this
	# For now, we'll just demonstrate the concept
