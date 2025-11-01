extends RefCounted
class_name StructureGenerator

## Generates medieval structures in the world
## Includes: Villages, Castles, Towers, Forges, Mines

enum StructureType {
	VILLAGE_HOUSE = 0,
	WATCHTOWER = 1,
	FORGE = 2,
	MINE_ENTRANCE = 3,
	CASTLE_RUIN = 4,
	STONE_CIRCLE = 5
}

var world_seed: int
var structure_noise: FastNoiseLite

func _init(seed_value: int):
	world_seed = seed_value
	initialize_noise()

func initialize_noise():
	structure_noise = FastNoiseLite.new()
	structure_noise.seed = world_seed + 500
	structure_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	structure_noise.frequency = 0.002
	structure_noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE

## Check if a structure should spawn at this location
func should_spawn_structure(x: float, z: float, biome: BiomeGenerator.BiomeType) -> bool:
	# Don't spawn in water
	if biome == BiomeGenerator.BiomeType.OCEAN:
		return false
	
	# Use noise to determine spawn points
	var noise_value = structure_noise.get_noise_2d(x, z)
	
	# Very rare spawn rate (about 0.1% of chunks)
	return noise_value > 0.98

## Get structure type for biome
func get_structure_type(biome: BiomeGenerator.BiomeType, rng: RandomNumberGenerator) -> StructureType:
	match biome:
		BiomeGenerator.BiomeType.PLAINS:
			return StructureType.VILLAGE_HOUSE if rng.randf() < 0.6 else StructureType.WATCHTOWER
		BiomeGenerator.BiomeType.FOREST:
			return StructureType.WATCHTOWER if rng.randf() < 0.5 else StructureType.STONE_CIRCLE
		BiomeGenerator.BiomeType.MOUNTAINS:
			return StructureType.MINE_ENTRANCE if rng.randf() < 0.7 else StructureType.CASTLE_RUIN
		BiomeGenerator.BiomeType.DESERT:
			return StructureType.CASTLE_RUIN
		BiomeGenerator.BiomeType.TUNDRA:
			return StructureType.STONE_CIRCLE
		_:
			return StructureType.VILLAGE_HOUSE

## Get structure name
static func get_structure_name(type: StructureType) -> String:
	match type:
		StructureType.VILLAGE_HOUSE:
			return "Village House"
		StructureType.WATCHTOWER:
			return "Watchtower"
		StructureType.FORGE:
			return "Forge"
		StructureType.MINE_ENTRANCE:
			return "Mine Entrance"
		StructureType.CASTLE_RUIN:
			return "Castle Ruin"
		StructureType.STONE_CIRCLE:
			return "Stone Circle"
		_:
			return "Unknown Structure"
