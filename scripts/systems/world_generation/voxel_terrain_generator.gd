extends VoxelGeneratorScript
class_name VoxelTerrainGenerator

## Custom generator for godot_voxel that uses existing biome/terrain logic
## This bridges the gap between our custom WorldGenerator and godot_voxel

# World generation parameters
@export var world_seed: int = 12345
@export var sea_level: int = 0
@export var chunk_size: int = 16

# Noise generators
var continent_noise: FastNoiseLite
var terrain_noise: FastNoiseLite
var ore_noise: FastNoiseLite

# Biome generator
var biome_generator: BiomeGenerator

# Constants for voxel type mapping
const VOXEL_AIR = 0
const VOXEL_GRASS = 1
const VOXEL_DIRT = 2
const VOXEL_STONE = 3
const VOXEL_BEDROCK = 4
const VOXEL_WATER = 5
const VOXEL_SAND = 6
const VOXEL_WOOD = 7
const VOXEL_LEAVES = 8

func _init():
	initialize_noise()
	biome_generator = BiomeGenerator.new(world_seed)

func initialize_noise():
	# Continental noise (same as WorldGenerator)
	continent_noise = FastNoiseLite.new()
	continent_noise.seed = world_seed
	continent_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	continent_noise.frequency = 0.005
	
	# Terrain noise (same as WorldGenerator)
	terrain_noise = FastNoiseLite.new()
	terrain_noise.seed = world_seed + 1
	terrain_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	terrain_noise.frequency = 0.02
	terrain_noise.fractal_octaves = 4
	terrain_noise.fractal_lacunarity = 2.0
	terrain_noise.fractal_gain = 0.5
	
	# Ore noise (same as WorldGenerator)
	ore_noise = FastNoiseLite.new()
	ore_noise.seed = world_seed + 2
	ore_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	ore_noise.frequency = 0.05
	ore_noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE

func _generate_block(out_buffer: VoxelBuffer, origin: Vector3i, lod: int) -> void:
	# NOTE: This function is called by godot_voxel to generate chunks
	# out_buffer is the voxel buffer to fill
	# origin is the world position of this block
	# lod is level of detail (0 = full detail)
	
	if lod != 0:
		# For now, only support full detail
		return
	
	var block_size = out_buffer.get_size()
	
	for x in range(block_size.x):
		for z in range(block_size.z):
			for y in range(block_size.y):
				var world_x = origin.x + x
				var world_y = origin.y + y
				var world_z = origin.z + z
				
				# Get voxel type using our existing logic
				var voxel_type = get_voxel_type(world_x, world_y, world_z)
				
				# Map to godot_voxel IDs and set in buffer
				var voxel_id = map_voxel_type_to_id(voxel_type)
				out_buffer.set_voxel(voxel_id, x, y, z, 0)  # Channel 0 = TYPE

func get_terrain_height(x: float, z: float) -> float:
	# Reuse terrain height calculation from WorldGenerator
	var continent_value = continent_noise.get_noise_2d(x, z)
	var continent_threshold = 0.3
	
	# If below continent threshold, it's ocean
	if continent_value < continent_threshold:
		return sea_level - 10
	
	# Get base terrain height
	var terrain_value = terrain_noise.get_noise_2d(x, z)
	var height = sea_level + (terrain_value * 50.0)  # terrain_height_multiplier = 50.0
	
	# Blend continent edges smoothly
	var continent_blend = clamp((continent_value - continent_threshold) / 0.2, 0.0, 1.0)
	height = lerp(float(sea_level - 5), height, continent_blend)
	
	return height

func get_voxel_type(x: float, y: float, z: float) -> VoxelType.Type:
	# Reuse voxel type logic from WorldGenerator
	var terrain_height = get_terrain_height(x, z)
	
	if y > terrain_height:
		return VoxelType.Type.WATER if y <= sea_level else VoxelType.Type.AIR
	
	# Get biome for this location
	var biome = biome_generator.get_biome(x, z, terrain_height, sea_level)
	
	# Surface layer - biome dependent
	if y > terrain_height - 1:
		match biome:
			BiomeGenerator.BiomeType.DESERT:
				return VoxelType.Type.SAND
			BiomeGenerator.BiomeType.TUNDRA:
				return VoxelType.Type.SNOW
			BiomeGenerator.BiomeType.SWAMP:
				return VoxelType.Type.CLAY if terrain_height < sea_level + 2 else VoxelType.Type.GRASS
			BiomeGenerator.BiomeType.OCEAN:
				return VoxelType.Type.SAND
			_:
				return VoxelType.Type.SAND if terrain_height < sea_level else VoxelType.Type.GRASS
	
	# Sub-surface layer
	if y > terrain_height - 4:
		if biome == BiomeGenerator.BiomeType.DESERT:
			return VoxelType.Type.SAND
		return VoxelType.Type.DIRT
	
	# Bedrock layer at bottom
	if y < -500:
		return VoxelType.Type.BEDROCK
	
	# Underground - check for ores
	var ore_type = get_ore_type(x, y, z)
	if ore_type != VoxelType.Type.STONE:
		return ore_type
	
	return VoxelType.Type.STONE

func get_ore_type(x: float, y: float, z: float) -> VoxelType.Type:
	# Simplified ore generation (full version in WorldGenerator)
	var ore_value = ore_noise.get_noise_3d(x, y, z)
	
	# Coal: -50 to 50
	if y > -50 and y < 50 and ore_value > 0.85:
		return VoxelType.Type.COAL
	
	# Iron: -100 to 0
	if y > -100 and y < 0 and ore_value > 0.88:
		return VoxelType.Type.IRON_ORE
	
	# Copper: -80 to 20
	if y > -80 and y < 20 and ore_value > 0.87:
		return VoxelType.Type.COPPER_ORE
	
	return VoxelType.Type.STONE

func map_voxel_type_to_id(type: VoxelType.Type) -> int:
	# Map our VoxelType enum to godot_voxel block IDs
	# These IDs must match the VoxelBlockyLibrary setup
	match type:
		VoxelType.Type.AIR:
			return VOXEL_AIR
		VoxelType.Type.GRASS:
			return VOXEL_GRASS
		VoxelType.Type.DIRT:
			return VOXEL_DIRT
		VoxelType.Type.STONE:
			return VOXEL_STONE
		VoxelType.Type.BEDROCK:
			return VOXEL_BEDROCK
		VoxelType.Type.WATER:
			return VOXEL_WATER
		VoxelType.Type.SAND:
			return VOXEL_SAND
		VoxelType.Type.WOOD:
			return VOXEL_WOOD
		VoxelType.Type.LEAVES:
			return VOXEL_LEAVES
		VoxelType.Type.IRON_ORE:
			return VOXEL_STONE  # For simplicity, map ores to stone for now
		VoxelType.Type.COPPER_ORE:
			return VOXEL_STONE
		VoxelType.Type.COAL:
			return VOXEL_STONE
		_:
			return VOXEL_AIR
