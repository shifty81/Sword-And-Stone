extends RefCounted
class_name TreeGenerator

## Generates trees in the world for forest biomes

const LEAF_CROWN_RADIUS: float = 2.5
const MIN_TREE_HEIGHT: int = 5
const TREE_HEIGHT_VARIANCE: int = 3

var world_seed: int
var tree_noise: FastNoiseLite

func _init(seed_value: int):
	world_seed = seed_value
	initialize_noise()

func initialize_noise():
	tree_noise = FastNoiseLite.new()
	tree_noise.seed = world_seed + 300
	tree_noise.noise_type = FastNoiseLite.TYPE_CELLULAR
	tree_noise.frequency = 0.1
	tree_noise.cellular_return_type = FastNoiseLite.RETURN_CELL_VALUE

## Check if a tree should spawn at this position
func should_spawn_tree(x: float, z: float, biome: BiomeGenerator.BiomeType) -> bool:
	if not BiomeGenerator.has_trees(biome):
		return false
	
	var density = BiomeGenerator.get_tree_density(biome)
	var noise_value = tree_noise.get_noise_2d(x, z)
	
	# Threshold based on tree density
	var threshold = 1.0 - (density * 2.0)  # Higher density = lower threshold
	return noise_value > threshold

## Generate a simple tree at the given position in the chunk
## Returns an array of voxel positions to set as wood/leaves
func generate_tree_voxels(base_x: int, base_y: int, base_z: int) -> Array:
	var voxels = []
	var tree_height = MIN_TREE_HEIGHT + (abs(base_x + base_z) % TREE_HEIGHT_VARIANCE)
	
	# Tree trunk
	for y in range(tree_height):
		voxels.append({
			"x": base_x,
			"y": base_y + y,
			"z": base_z,
			"type": VoxelType.Type.WOOD
		})
	
	# Leaves crown (simple sphere)
	var crown_y = base_y + tree_height - 2
	for dy in range(-2, 3):
		for dx in range(-2, 3):
			for dz in range(-2, 3):
				# Create rough sphere shape
				var dist = sqrt(dx * dx + dy * dy + dz * dz)
				if dist <= LEAF_CROWN_RADIUS and not (dx == 0 and dy < 0 and dz == 0):
					voxels.append({
						"x": base_x + dx,
						"y": crown_y + dy,
						"z": base_z + dz,
						"type": VoxelType.Type.LEAVES
					})
	
	return voxels
