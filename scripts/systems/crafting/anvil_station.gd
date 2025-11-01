extends CraftingStation
class_name AnvilStation

## Anvil for smithing weapons and armor
## Uses voxel-based smithing where player moves voxels to shape items

@export var smithing_canvas_size: Vector3i = Vector3i(16, 16, 16)
@export var hammer_strength: float = 1.0

var smithing_voxels: Array = []
var current_recipe: CraftingRecipe
var is_smithing: bool = false

signal smithing_quality_updated(quality: Item.Quality)
signal voxel_shaped(position: Vector3i)

func _ready():
	station_type = StationType.ANVIL
	initialize_smithing_canvas()

func initialize_smithing_canvas():
	# Initialize 3D voxel array for smithing
	smithing_voxels.resize(smithing_canvas_size.x)
	for x in range(smithing_canvas_size.x):
		smithing_voxels[x] = []
		smithing_voxels[x].resize(smithing_canvas_size.y)
		for y in range(smithing_canvas_size.y):
			smithing_voxels[x][y] = []
			smithing_voxels[x][y].resize(smithing_canvas_size.z)
			for z in range(smithing_canvas_size.z):
				smithing_voxels[x][y][z] = VoxelType.Type.AIR

func start_smithing(recipe: CraftingRecipe, inventory):
	if not can_craft(recipe, inventory):
		crafting_failed.emit()
		return
	
	current_recipe = recipe
	is_smithing = true
	
	# Store materials for potential refund if cancelled
	# Note: Remove materials only after successful completion
	# For now, we remove them at start as specified in original design
	# Future: Add material storage for cancel/refund functionality
	for ingredient in recipe.required_materials:
		inventory.remove_item(ingredient["item"], ingredient["amount"])
	
	# Load template or start with heated metal block
	load_smithing_template(recipe)
	
	print("Started smithing: %s" % recipe.recipe_name)

func load_smithing_template(recipe: CraftingRecipe):
	# Create a basic ingot shape in the center
	var center_x = smithing_canvas_size.x / 2
	var center_y = smithing_canvas_size.y / 2
	var center_z = smithing_canvas_size.z / 2
	
	# Create a hot metal ingot
	for x in range(center_x - 2, center_x + 2):
		for y in range(center_y - 1, center_y + 1):
			for z in range(center_z - 4, center_z + 4):
				if is_valid_position(x, y, z):
					smithing_voxels[x][y][z] = VoxelType.Type.IRON_ORE  # Represents hot metal

func is_valid_position(x: int, y: int, z: int) -> bool:
	return x >= 0 and x < smithing_canvas_size.x and \
		   y >= 0 and y < smithing_canvas_size.y and \
		   z >= 0 and z < smithing_canvas_size.z

func hammer_voxel(position: Vector3i, direction: Vector3i):
	if not is_smithing:
		return
	
	if not is_valid_position(position.x, position.y, position.z):
		return
	
	# Move voxel material in the hammer direction
	var current_voxel = smithing_voxels[position.x][position.y][position.z]
	
	if current_voxel != VoxelType.Type.AIR:
		# Push material to adjacent voxel
		var target_pos = position + direction
		
		if is_valid_position(target_pos.x, target_pos.y, target_pos.z):
			smithing_voxels[target_pos.x][target_pos.y][target_pos.z] = current_voxel
			smithing_voxels[position.x][position.y][position.z] = VoxelType.Type.AIR
			voxel_shaped.emit(position)
			
			# Update quality based on how well shape matches recipe
			update_smithing_quality()

func update_smithing_quality():
	if not current_recipe:
		return
	
	# Calculate how well the current shape matches the target
	var match_score = calculate_shape_match()
	
	# Determine quality based on match score
	var quality: Item.Quality
	if match_score > 0.95:
		quality = Item.Quality.MASTERWORK
	elif match_score > 0.85:
		quality = Item.Quality.EXCELLENT
	elif match_score > 0.7:
		quality = Item.Quality.GOOD
	elif match_score > 0.5:
		quality = Item.Quality.COMMON
	else:
		quality = Item.Quality.POOR
	
	smithing_quality_updated.emit(quality)

func calculate_shape_match() -> float:
	# TODO: Implement actual shape matching against recipe template
	# This would:
	# 1. Load expected voxel pattern for the recipe
	# 2. Compare current smithing_voxels to expected pattern
	# 3. Calculate percentage of voxels in correct positions
	# 4. Return match score (0.0 to 1.0)
	#
	# For now, we use a placeholder that simulates gradual improvement
	# In a real implementation, this would be based on actual voxel positions
	
	# Count non-air voxels (basic complexity measure)
	var filled_voxels = 0
	for x in range(smithing_canvas_size.x):
		for y in range(smithing_canvas_size.y):
			for z in range(smithing_canvas_size.z):
				if smithing_voxels[x][y][z] != VoxelType.Type.AIR:
					filled_voxels += 1
	
	# Placeholder: base score on number of modifications
	# Real implementation would compare to target pattern
	var base_score = 0.7 + randf() * 0.25
	return clamp(base_score, 0.0, 1.0)

func finish_smithing() -> Item:
	if not is_smithing or not current_recipe:
		return null
	
	is_smithing = false
	
	var result = current_recipe.result_item.duplicate()
	var match_score = calculate_shape_match()
	
	# Set final quality
	if match_score > 0.95:
		result.quality = Item.Quality.MASTERWORK
	elif match_score > 0.85:
		result.quality = Item.Quality.EXCELLENT
	elif match_score > 0.7:
		result.quality = Item.Quality.GOOD
	elif match_score > 0.5:
		result.quality = Item.Quality.COMMON
	else:
		result.quality = Item.Quality.POOR
	
	crafting_completed.emit(result)
	clear_smithing_canvas()
	
	return result

func clear_smithing_canvas():
	for x in range(smithing_canvas_size.x):
		for y in range(smithing_canvas_size.y):
			for z in range(smithing_canvas_size.z):
				smithing_voxels[x][y][z] = VoxelType.Type.AIR

func cancel_smithing():
	is_smithing = false
	current_recipe = null
	clear_smithing_canvas()
