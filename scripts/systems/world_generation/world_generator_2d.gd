extends Node2D
class_name WorldGenerator2D

## Procedural 2D world generator for Crimson Isles
## Generates varied terrain using noise-based generation and TileMap

# Default configuration constants
const DEFAULT_SEED = 42
const DEFAULT_WORLD_SIZE_CHUNKS = 8
const DEFAULT_CHUNK_SIZE_TILES = 32
const DEFAULT_TERRAIN_SCALE = 0.05
const DEFAULT_MOISTURE_SCALE = 0.03
const DEFAULT_TEMPERATURE_SCALE = 0.04

@export_group("World Settings")
@export var world_seed: int = DEFAULT_SEED
@export var world_size_chunks: int = DEFAULT_WORLD_SIZE_CHUNKS  # 8x8 chunks
@export var chunk_size_tiles: int = DEFAULT_CHUNK_SIZE_TILES  # 32x32 tiles per chunk

@export_group("Terrain Generation")
@export var terrain_scale: float = DEFAULT_TERRAIN_SCALE
@export var moisture_scale: float = DEFAULT_MOISTURE_SCALE
@export var temperature_scale: float = DEFAULT_TEMPERATURE_SCALE

var terrain_noise: FastNoiseLite
var moisture_noise: FastNoiseLite
var temperature_noise: FastNoiseLite
var tile_map: TileMap

# Terrain type enum
enum TerrainType {
	DEEP_WATER,
	SHALLOW_WATER,
	SAND,
	GRASS,
	DIRT,
	STONE,
	SNOW,
	FOREST
}

func _ready():
	initialize_noise()
	if tile_map:
		generate_world()

func initialize_noise():
	# Terrain height noise
	terrain_noise = FastNoiseLite.new()
	terrain_noise.seed = world_seed
	terrain_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	terrain_noise.frequency = terrain_scale
	terrain_noise.fractal_octaves = 4
	
	# Moisture noise for biome variation
	moisture_noise = FastNoiseLite.new()
	moisture_noise.seed = world_seed + 1000
	moisture_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	moisture_noise.frequency = moisture_scale
	
	# Temperature noise for biome variation
	temperature_noise = FastNoiseLite.new()
	temperature_noise.seed = world_seed + 2000
	temperature_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	temperature_noise.frequency = temperature_scale

func set_tile_map(tm: TileMap):
	tile_map = tm
	if is_inside_tree():
		generate_world()

func generate_world():
	if not tile_map:
		push_error("TileMap not set for WorldGenerator2D")
		return
	
	print("Generating 2D world...")
	var total_size = world_size_chunks * chunk_size_tiles
	
	for y in range(-total_size / 2, total_size / 2):
		for x in range(-total_size / 2, total_size / 2):
			var terrain_type = get_terrain_type(x, y)
			place_tile(x, y, terrain_type)
	
	print("2D world generation complete!")

func get_terrain_type(x: int, y: int) -> TerrainType:
	# Get noise values
	var height = terrain_noise.get_noise_2d(x, y)
	var moisture = moisture_noise.get_noise_2d(x, y)
	var temp = temperature_noise.get_noise_2d(x, y)
	
	# Normalize to 0-1 range
	height = (height + 1.0) / 2.0
	moisture = (moisture + 1.0) / 2.0
	temp = (temp + 1.0) / 2.0
	
	# Determine terrain based on height first
	if height < 0.35:
		return TerrainType.DEEP_WATER
	elif height < 0.42:
		return TerrainType.SHALLOW_WATER
	elif height < 0.48:
		return TerrainType.SAND
	elif height > 0.75:
		# High elevation
		if temp < 0.3:
			return TerrainType.SNOW
		else:
			return TerrainType.STONE
	else:
		# Mid elevation - use moisture and temperature
		if moisture > 0.6 and temp > 0.4:
			return TerrainType.FOREST
		elif moisture < 0.3:
			return TerrainType.DIRT
		else:
			return TerrainType.GRASS
	
	return TerrainType.GRASS

func place_tile(x: int, y: int, terrain_type: TerrainType):
	# Atlas coords mapping for each terrain type
	# These correspond to the positions in our tileset atlas
	var atlas_coords = Vector2i(0, 0)
	
	match terrain_type:
		TerrainType.DEEP_WATER:
			atlas_coords = Vector2i(0, 0)
		TerrainType.SHALLOW_WATER:
			atlas_coords = Vector2i(1, 0)
		TerrainType.SAND:
			atlas_coords = Vector2i(2, 0)
		TerrainType.GRASS:
			atlas_coords = Vector2i(3, 0)
		TerrainType.DIRT:
			atlas_coords = Vector2i(4, 0)
		TerrainType.STONE:
			atlas_coords = Vector2i(5, 0)
		TerrainType.SNOW:
			atlas_coords = Vector2i(6, 0)
		TerrainType.FOREST:
			atlas_coords = Vector2i(7, 0)
	
	# Place the tile on layer 0 with the terrain tileset (source_id 0)
	tile_map.set_cell(0, Vector2i(x, y), 0, atlas_coords)

func get_world_bounds() -> Rect2i:
	var total_size = world_size_chunks * chunk_size_tiles
	return Rect2i(-total_size / 2, -total_size / 2, total_size, total_size)
