extends Node3D
class_name WorldGenerator

## Main world generation system that creates continents, rivers, and biomes
## Inspired by Vintage Story's world generation

@export_group("World Settings")
@export var world_seed: int = 12345
@export var chunk_size: int = 16
@export var world_height_in_chunks: int = 16
@export var render_distance: int = 8

@export_group("Continent Generation")
@export var continent_scale: float = 0.005
@export var continent_threshold: float = 0.3
@export var sea_level: int = 64

@export_group("Terrain Features")
@export var terrain_scale: float = 0.02
@export var terrain_height_multiplier: float = 50.0
@export var octaves: int = 4
@export var persistence: float = 0.5
@export var lacunarity: float = 2.0

@export_group("River Generation")
@export var river_attempts: int = 50
@export var river_width: float = 3.0
@export var min_river_length: int = 20  # Minimum successful river length to keep

var chunks: Dictionary = {}
var continent_noise: FastNoiseLite
var terrain_noise: FastNoiseLite
var rivers: Array[River] = []
var player: CharacterBody3D

func _ready():
	add_to_group("world_generator")
	initialize_noise()
	generate_continents()
	generate_rivers()

func initialize_noise():
	# Initialize continent noise for large-scale landmass generation
	continent_noise = FastNoiseLite.new()
	continent_noise.seed = world_seed
	continent_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	continent_noise.frequency = continent_scale
	
	# Initialize terrain noise for detailed height variations
	terrain_noise = FastNoiseLite.new()
	terrain_noise.seed = world_seed + 1
	terrain_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	terrain_noise.frequency = terrain_scale
	terrain_noise.fractal_octaves = octaves
	terrain_noise.fractal_lacunarity = lacunarity
	terrain_noise.fractal_gain = persistence

func generate_continents():
	print("Generating continents...")
	# Continent generation happens during chunk creation

func generate_rivers():
	print("Generating rivers...")
	var rng = RandomNumberGenerator.new()
	rng.seed = world_seed
	
	for i in range(river_attempts):
		var start_x = rng.randi_range(-render_distance * chunk_size, render_distance * chunk_size)
		var start_z = rng.randi_range(-render_distance * chunk_size, render_distance * chunk_size)
		
		var river = River.new()
		river.generate_river_path(start_x, start_z, self, min_river_length)
		
		if river.points.size() >= min_river_length:
			rivers.append(river)
	
	print("Generated %d rivers" % rivers.size())

func get_continent_value(x: float, z: float) -> float:
	return continent_noise.get_noise_2d(x, z)

func get_terrain_height(x: float, z: float) -> float:
	var continent_value = get_continent_value(x, z)
	
	# If below continent threshold, it's ocean
	if continent_value < continent_threshold:
		return sea_level - 10
	
	# Get base terrain height
	var terrain_value = terrain_noise.get_noise_2d(x, z)
	var height = sea_level + (terrain_value * terrain_height_multiplier)
	
	# Blend continent edges smoothly
	var continent_blend = clamp((continent_value - continent_threshold) / 0.2, 0.0, 1.0)
	height = lerp(float(sea_level - 5), height, continent_blend)
	
	# Check if this position is part of a river
	for river in rivers:
		var dist_to_river = river.get_distance_to_river(x, z)
		if dist_to_river < river_width:
			var river_depth = 5.0 * (1.0 - dist_to_river / river_width)
			height -= river_depth
			height = max(height, sea_level - 2)
	
	return height

func get_voxel_type(x: float, y: float, z: float) -> VoxelType.Type:
	var terrain_height = get_terrain_height(x, z)
	
	if y > terrain_height:
		return VoxelType.Type.WATER if y <= sea_level else VoxelType.Type.AIR
	
	if y > terrain_height - 1:
		return VoxelType.Type.SAND if terrain_height < sea_level else VoxelType.Type.GRASS
	
	if y > terrain_height - 4:
		return VoxelType.Type.DIRT
	
	if y > 10:
		return VoxelType.Type.STONE
	
	return VoxelType.Type.BEDROCK

func get_chunk(chunk_position: Vector3i) -> Chunk:
	if chunks.has(chunk_position):
		return chunks[chunk_position]
	return null

func generate_chunk(chunk_position: Vector3i):
	if chunks.has(chunk_position):
		return
	
	var chunk_node = Chunk.new()
	chunk_node.name = "Chunk_%d_%d_%d" % [chunk_position.x, chunk_position.y, chunk_position.z]
	add_child(chunk_node)
	
	chunk_node.initialize(self, chunk_position, chunk_size)
	chunk_node.generate_voxels()
	
	chunks[chunk_position] = chunk_node

func _process(_delta):
	# Generate chunks around player
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return
	
	var player_pos = player.global_position
	var player_chunk_pos = Vector3i(
		floor(player_pos.x / chunk_size),
		0,
		floor(player_pos.z / chunk_size)
	)
	
	# Generate chunks in render distance
	for x in range(-render_distance, render_distance + 1):
		for z in range(-render_distance, render_distance + 1):
			var chunk_pos = player_chunk_pos + Vector3i(x, 0, z)
			generate_chunk(chunk_pos)

## River class for generating flowing water features
class River:
	var points: Array[Vector2] = []
	
	func generate_river_path(start_x: int, start_z: int, world: WorldGenerator, min_length: int):
		var current = Vector2(start_x, start_z)
		points.append(current)
		
		for i in range(min_length * 2):
			var current_height = world.get_terrain_height(current.x, current.y)
			
			if current_height <= world.sea_level:
				break  # Reached water
			
			# Find lowest neighbor
			var lowest = current
			var lowest_height = current_height
			
			for dx in range(-1, 2):
				for dz in range(-1, 2):
					if dx == 0 and dz == 0:
						continue
					
					var neighbor = current + Vector2(dx, dz)
					var neighbor_height = world.get_terrain_height(neighbor.x, neighbor.y)
					
					if neighbor_height < lowest_height:
						lowest = neighbor
						lowest_height = neighbor_height
			
			if lowest == current:
				break  # Stuck in local minimum
			
			current = lowest
			points.append(current)
	
	func get_distance_to_river(x: float, z: float) -> float:
		var min_dist = INF
		var point = Vector2(x, z)
		
		for i in range(points.size() - 1):
			var dist = _distance_to_line_segment(point, points[i], points[i + 1])
			min_dist = min(min_dist, dist)
		
		return min_dist
	
	func _distance_to_line_segment(point: Vector2, line_start: Vector2, line_end: Vector2) -> float:
		var line = line_end - line_start
		var line_length = line.length()
		
		if line_length < 0.01:
			return (point - line_start).length()
		
		var t = clamp((point - line_start).dot(line) / (line_length * line_length), 0.0, 1.0)
		var projection = line_start + t * line
		
		return (point - projection).length()
