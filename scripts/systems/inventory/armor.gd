extends Item
class_name Armor

## Armor item with protection and quality modifiers

enum ArmorType {
	HELMET,
	CHESTPLATE,
	LEGGINGS,
	BOOTS,
	GLOVES
}

enum ArmorMaterial {
	LEATHER,
	COPPER,
	BRONZE,
	IRON,
	STEEL
}

@export var armor_type: ArmorType = ArmorType.CHESTPLATE
@export var armor_material: ArmorMaterial = ArmorMaterial.IRON
@export var base_defense: float = 5.0
@export var weight: float = 10.0

## Get actual defense considering quality
func get_defense() -> float:
	return base_defense * Item.get_quality_multiplier(quality)

## Get display name with quality and material
func get_display_name() -> String:
	var material_name = ArmorMaterial.keys()[armor_material].capitalize()
	return "%s %s %s" % [Item.get_quality_name(quality), material_name, item_name]
