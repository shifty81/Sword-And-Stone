extends Node3D
class_name CraftingStation

## Base class for crafting stations

enum StationType {
	WORKBENCH,
	ANVIL,
	FORGE,
	FURNACE
}

@export var station_type: StationType = StationType.WORKBENCH
@export var available_recipes: Array[CraftingRecipe] = []

signal crafting_started(recipe: CraftingRecipe)
signal crafting_completed(result: Item)
signal crafting_failed()

func can_craft(recipe: CraftingRecipe, inventory: Inventory) -> bool:
	# Check if player has required materials
	for ingredient in recipe.required_materials:
		if not inventory.has_item(ingredient["item"], ingredient["amount"]):
			return false
	return true

func start_crafting(recipe: CraftingRecipe, inventory: Inventory):
	if not can_craft(recipe, inventory):
		crafting_failed.emit()
		return
	
	# Remove materials from inventory
	for ingredient in recipe.required_materials:
		inventory.remove_item(ingredient["item"], ingredient["amount"])
	
	crafting_started.emit(recipe)
	
	# For now, craft instantly. Can add timer later
	complete_crafting(recipe)

func complete_crafting(recipe: CraftingRecipe):
	var result = recipe.result_item.duplicate()
	
	# Calculate quality based on crafting skill and randomness
	# This would be expanded with actual skill system
	var quality_roll = randf()
	if quality_roll > 0.95:
		result.quality = Item.Quality.MASTERWORK
	elif quality_roll > 0.8:
		result.quality = Item.Quality.EXCELLENT
	elif quality_roll > 0.5:
		result.quality = Item.Quality.GOOD
	else:
		result.quality = Item.Quality.COMMON
	
	crafting_completed.emit(result)
	
	# Print crafted item name
	var display_name = result.item_name
	if result.has_method("get_display_name"):
		display_name = result.get_display_name()
	print("Crafted: %s" % display_name)

## Crafting recipe data structure
class CraftingRecipe extends Resource:
	@export var recipe_name: String
	@export var required_materials: Array[Dictionary] = []
	@export var result_item: Item
	@export var crafting_time: float = 1.0
	@export var required_station: StationType
	@export var required_skill_level: int = 0
