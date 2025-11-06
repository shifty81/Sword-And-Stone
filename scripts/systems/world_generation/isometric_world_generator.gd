extends Node2D
class_name IsometricWorldGenerator

## Procedural isometric world generator
## Creates a 2.5D world with mountains, oceans, forests, and more

# World configuration
@export_group("World Settings")
@export var world_seed: int = 42
@export var world_size_x: int = 128  # Tiles in X direction
@export var world_size_y: int = 128  # Tiles in Y direction

@export_group("Terrain Generation")
@export var terrain_scale: float = 0.03
@export var height_scale: float = 0.04  # For mountain height variation
@export var moisture_scale: float = 0.02

@export_group("Features")
@export var generate_trees: bool = true
@export var tree_density: float = 0.15  # Chance of tree on grass/forest
@export var generate_decorations: bool = true  # Rocks, flowers, grass tufts
@export var generate_ores: bool = true
@export var ocean_level: float = 0.35  # Below this height = water

var terrain_noise: FastNoiseLite
var height_noise: FastNoiseLite
var moisture_noise: FastNoiseLite
var tile_map: TileMap
var decorations: Node  # IsometricDecorations instance

# Terrain type enum - matches our tileset
enum TerrainType {
	WATER = 0,
	SAND = 1,
	GRASS = 2,
	DIRT = 3,
	STONE = 4,
	SNOW = 5,
	WOOD = 6,
	LEAVES = 7,
	COBBLESTONE = 8,
	GRAVEL = 9,
	ICE = 10,
	COAL_ORE = 11,
	IRON_ORE = 12,
	GOLD_ORE = 13,
	COPPER_ORE = 14,
}

# Tile atlas coordinates (4 tiles per row in our generated tileset)
var terrain_atlas_coords = {
	TerrainType.WATER: Vector2i(0, 0),
	TerrainType.SAND: Vector2i(1, 0),
	TerrainType.GRASS: Vector2i(2, 0),
	TerrainType.DIRT: Vector2i(3, 0),
	TerrainType.STONE: Vector2i(0, 1),
	TerrainType.SNOW: Vector2i(1, 1),
	TerrainType.WOOD: Vector2i(2, 1),
	TerrainType.LEAVES: Vector2i(3, 1),
	TerrainType.COBBLESTONE: Vector2i(0, 2),
	TerrainType.GRAVEL: Vector2i(1, 2),
	TerrainType.ICE: Vector2i(2, 2),
	TerrainType.COAL_ORE: Vector2i(3, 2),
	TerrainType.IRON_ORE: Vector2i(0, 3),
	TerrainType.GOLD_ORE: Vector2i(1, 3),
	TerrainType.COPPER_ORE: Vector2i(2, 3),
}

func _ready():
	initialize_noise()
	
	# Load decorations system
	if generate_decorations:
		var IsometricDecorations = load("res://scripts/systems/world_generation/isometric_decorations.gd")
		decorations = IsometricDecorations.new(world_seed)
	
	if tile_map:
		generate_world()

func initialize_noise():
	# Terrain/elevation noise
	terrain_noise = FastNoiseLite.new()
	terrain_noise.seed = world_seed
	terrain_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	terrain_noise.frequency = terrain_scale
	terrain_noise.fractal_octaves = 5
	
	# Height variation for mountains
	height_noise = FastNoiseLite.new()
	height_noise.seed = world_seed + 1000
	height_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	height_noise.frequency = height_scale
	height_noise.fractal_octaves = 6
	
	# Moisture for biome variation
	moisture_noise = FastNoiseLite.new()
	moisture_noise.seed = world_seed + 2000
	moisture_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	moisture_noise.frequency = moisture_scale
	moisture_noise.fractal_octaves = 3

func set_tile_map(tm: TileMap):
	tile_map = tm
	if is_inside_tree():
		generate_world()

func generate_world():
	if not tile_map:
		push_error("TileMap not set for IsometricWorldGenerator")
		return
	
	print("=== Generating Isometric World ===")
	print("Size: ", world_size_x, "x", world_size_y, " tiles")
	
	var tree_count = 0
	var decoration_count = 0
	
	# Generate terrain
	for y in range(world_size_y):
		for x in range(world_size_x):
			var world_x = x - world_size_x / 2
			var world_y = y - world_size_y / 2
			
			var terrain_type = get_terrain_type(world_x, world_y)
			place_tile(world_x, world_y, terrain_type, 0)  # Layer 0 = base terrain
			
			# Get terrain name for decoration logic
			var terrain_name = TerrainType.keys()[terrain_type].to_lower()
			
			# Generate trees on grass
			if generate_trees and terrain_type == TerrainType.GRASS:
				if randf() < tree_density:
					place_tree(world_x, world_y)
					tree_count += 1
			
			# Generate decorations
			elif generate_decorations and decorations:
				if decorations.should_place_decoration(world_x, world_y, terrain_name):
					var deco_type = decorations.get_decoration_type(terrain_name)
					var atlas_coords = decorations.get_decoration_atlas_coords(deco_type)
					tile_map.set_cell(1, Vector2i(world_x, world_y), 0, atlas_coords)
					decoration_count += 1
	
	print("✓ Isometric world generation complete!")
	print("  - Ocean level: ", ocean_level)
	print("  - Trees: ", tree_count)
	print("  - Decorations: ", decoration_count)

func get_terrain_type(x: int, y: int) -> TerrainType:
	# Get noise values
	var elevation = terrain_noise.get_noise_2d(x, y)
	var height_detail = height_noise.get_noise_2d(x, y)
	var moisture = moisture_noise.get_noise_2d(x, y)
	
	# Normalize to 0-1 range
	elevation = (elevation + 1.0) / 2.0
	height_detail = (height_detail + 1.0) / 2.0
	moisture = (moisture + 1.0) / 2.0
	
	# Combine elevation and height detail for varied terrain
	var final_height = (elevation + height_detail) / 2.0
	
	# Determine terrain type based on height and moisture
	if final_height < ocean_level:
		# Ocean
		if final_height < ocean_level - 0.1:
			return TerrainType.WATER  # Deep water
		else:
			return TerrainType.WATER  # Shallow water
	elif final_height < ocean_level + 0.05:
		# Beach
		return TerrainType.SAND
	elif final_height > 0.75:
		# Mountains
		if final_height > 0.85:
			return TerrainType.SNOW  # Snow peaks
		else:
			return TerrainType.STONE  # Rocky mountains
	elif final_height > 0.65:
		# Hills
		if moisture < 0.3:
			return TerrainType.GRAVEL  # Dry hills
		else:
			return TerrainType.STONE  # Rocky hills
	else:
		# Plains/forests
		if moisture > 0.6:
			return TerrainType.GRASS  # Wet grassland (will add trees)
		elif moisture < 0.3:
			return TerrainType.DIRT  # Dry plains
		else:
			return TerrainType.GRASS  # Normal grassland
	
	return TerrainType.GRASS

func place_tile(x: int, y: int, terrain_type: TerrainType, layer: int = 0):
	if not terrain_atlas_coords.has(terrain_type):
		push_warning("Unknown terrain type: ", terrain_type)
		return
	
	var atlas_coords = terrain_atlas_coords[terrain_type]
	tile_map.set_cell(layer, Vector2i(x, y), 0, atlas_coords)  # source_id = 0

func place_tree(x: int, y: int):
	# Place tree trunk on layer 1 (objects layer)
	tile_map.set_cell(1, Vector2i(x, y), 0, terrain_atlas_coords[TerrainType.WOOD])
	
	# Place leaves on top (layer 2 for tall objects)
	tile_map.set_cell(2, Vector2i(x, y), 0, terrain_atlas_coords[TerrainType.LEAVES])

func get_world_bounds() -> Rect2i:
	return Rect2i(-world_size_x / 2, -world_size_y / 2, world_size_x, world_size_y)

## Get terrain at specific position for gameplay logic
func get_terrain_at(x: int, y: int) -> TerrainType:
	var tile_data = tile_map.get_cell_atlas_coords(0, Vector2i(x, y))
	
	# Find matching terrain type
	for terrain_type in terrain_atlas_coords:
		if terrain_atlas_coords[terrain_type] == tile_data:
			return terrain_type
	
	return TerrainType.GRASS  # Default
