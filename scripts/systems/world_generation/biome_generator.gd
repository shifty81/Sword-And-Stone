extends RefCounted
class_name BiomeGenerator

## Generates biomes for world generation
## Medieval-themed biomes: Plains, Forests, Mountains, Deserts, Tundra

enum BiomeType {
	PLAINS = 0,
	FOREST = 1,
	MOUNTAINS = 2,
	DESERT = 3,
	TUNDRA = 4,
	SWAMP = 5,
	OCEAN = 6
}

var temperature_noise: FastNoiseLite
var moisture_noise: FastNoiseLite
var world_seed: int

func _init(seed_value: int):
	world_seed = seed_value
	initialize_noise()

func initialize_noise():
	# Temperature noise for climate zones
	temperature_noise = FastNoiseLite.new()
	temperature_noise.seed = world_seed + 100
	temperature_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	temperature_noise.frequency = 0.01
	
	# Moisture noise for wet/dry areas
	moisture_noise = FastNoiseLite.new()
	moisture_noise.seed = world_seed + 200
	moisture_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	moisture_noise.frequency = 0.015

func get_biome(x: float, z: float, height: float, sea_level: float) -> BiomeType:
	# Ocean biome for underwater areas
	if height <= sea_level - 2:
		return BiomeType.OCEAN
	
	# Get temperature and moisture values
	var temperature = temperature_noise.get_noise_2d(x, z)  # -1 to 1
	var moisture = moisture_noise.get_noise_2d(x, z)  # -1 to 1
	
	# Altitude affects temperature (higher = colder)
	var altitude_factor = clamp((height - sea_level) / 100.0, -0.5, 0.5)
	temperature -= altitude_factor
	
	# Biome determination using temperature-moisture chart
	# Cold (temperature < -0.3)
	if temperature < -0.3:
		return BiomeType.TUNDRA
	
	# Hot (temperature > 0.3)
	elif temperature > 0.3:
		if moisture < -0.2:
			return BiomeType.DESERT
		elif moisture > 0.2:
			return BiomeType.SWAMP
		else:
			return BiomeType.PLAINS
	
	# Temperate (temperature between -0.3 and 0.3)
	else:
		if moisture < -0.3:
			return BiomeType.PLAINS
		elif moisture > 0.3:
			return BiomeType.FOREST
		elif height > sea_level + 40:
			return BiomeType.MOUNTAINS
		else:
			return BiomeType.PLAINS
	
	return BiomeType.PLAINS

## Get terrain color tint for biome
static func get_biome_grass_color(biome: BiomeType) -> Color:
	match biome:
		BiomeType.PLAINS:
			return Color(0.4, 0.7, 0.2)
		BiomeType.FOREST:
			return Color(0.25, 0.5, 0.15)
		BiomeType.MOUNTAINS:
			return Color(0.5, 0.5, 0.5)
		BiomeType.DESERT:
			return Color(0.85, 0.75, 0.45)
		BiomeType.TUNDRA:
			return Color(0.9, 0.9, 0.95)
		BiomeType.SWAMP:
			return Color(0.3, 0.4, 0.2)
		BiomeType.OCEAN:
			return Color(0.2, 0.4, 0.8)
		_:
			return Color(0.4, 0.6, 0.2)

## Check if biome should have trees
static func has_trees(biome: BiomeType) -> bool:
	return biome == BiomeType.FOREST or biome == BiomeType.PLAINS

## Get tree density for biome (0.0 to 1.0)
static func get_tree_density(biome: BiomeType) -> float:
	match biome:
		BiomeType.FOREST:
			return 0.3
		BiomeType.PLAINS:
			return 0.05
		BiomeType.SWAMP:
			return 0.15
		_:
			return 0.0
