extends Node2D
class_name IsometricDecorations

## Adds procedural decorations to make the world feel alive
## Includes rocks, flowers, grass tufts, mushrooms, etc.

var decoration_noise: FastNoiseLite
var world_seed: int = 42

# Decoration types (using existing tiles creatively)
enum DecorationType {
	ROCK_SMALL,
	ROCK_LARGE,
	GRASS_TUFT,
	FLOWER_RED,
	FLOWER_YELLOW,
	MUSHROOM,
	DEAD_TREE,
	BUSH,
}

# Decoration spawn chances per terrain type
var decoration_chances = {
	"grass": 0.12,  # 12% chance per grass tile
	"dirt": 0.08,
	"sand": 0.05,
	"stone": 0.15,  # More rocks on stone
	"snow": 0.06,
}

# Which decorations can spawn on which terrain
var terrain_decorations = {
	"grass": [DecorationType.GRASS_TUFT, DecorationType.FLOWER_RED, 
	          DecorationType.FLOWER_YELLOW, DecorationType.BUSH],
	"dirt": [DecorationType.ROCK_SMALL, DecorationType.GRASS_TUFT],
	"sand": [DecorationType.ROCK_SMALL],
	"stone": [DecorationType.ROCK_SMALL, DecorationType.ROCK_LARGE],
	"snow": [DecorationType.ROCK_SMALL],
}

func _init(seed_value: int = 42):
	world_seed = seed_value
	initialize_noise()

func initialize_noise():
	decoration_noise = FastNoiseLite.new()
	decoration_noise.seed = world_seed + 5000
	decoration_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	decoration_noise.frequency = 0.1

func should_place_decoration(x: int, y: int, terrain_name: String) -> bool:
	if not decoration_chances.has(terrain_name):
		return false
	
	var chance = decoration_chances[terrain_name]
	var noise_val = decoration_noise.get_noise_2d(x, y)
	
	# Normalize noise to 0-1
	noise_val = (noise_val + 1.0) / 2.0
	
	return noise_val < chance

func get_decoration_type(terrain_name: String) -> DecorationType:
	if not terrain_decorations.has(terrain_name):
		return DecorationType.ROCK_SMALL
	
	var available = terrain_decorations[terrain_name]
	return available[randi() % available.size()]

func get_decoration_atlas_coords(decoration_type: DecorationType) -> Vector2i:
	# Map decorations to atlas coords (reusing existing tiles)
	match decoration_type:
		DecorationType.ROCK_SMALL:
			return Vector2i(1, 2)  # Gravel
		DecorationType.ROCK_LARGE:
			return Vector2i(0, 1)  # Stone
		DecorationType.GRASS_TUFT:
			return Vector2i(2, 0)  # Grass (small variant)
		DecorationType.FLOWER_RED:
			return Vector2i(3, 1)  # Leaves (red flowers)
		DecorationType.FLOWER_YELLOW:
			return Vector2i(1, 3)  # Gold ore (yellow flowers)
		DecorationType.MUSHROOM:
			return Vector2i(3, 2)  # Coal ore (dark mushroom)
		DecorationType.DEAD_TREE:
			return Vector2i(2, 1)  # Wood
		DecorationType.BUSH:
			return Vector2i(3, 1)  # Leaves
		_:
			return Vector2i(1, 2)  # Default to gravel
