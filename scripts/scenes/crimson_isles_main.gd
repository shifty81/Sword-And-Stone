extends Node2D

## Main script for Crimson Isles scene
## Connects world generator to tilemap and initializes procedural terrain

@onready var world_generator = $WorldGenerator
@onready var tile_map = $TileMap

func _ready():
	if world_generator and tile_map:
		# Connect the generator to the tilemap
		world_generator.set_tile_map(tile_map)
		print("Crimson Isles world generation initialized!")
	else:
		push_error("World generator or TileMap not found in scene!")
