extends Item
class_name Weapon

## Weapon item with damage and quality modifiers

enum WeaponType {
	SWORD,
	AXE,
	MACE,
	SPEAR,
	DAGGER,
	HAMMER
}

@export var weapon_type: WeaponType = WeaponType.SWORD
@export var base_damage: float = 10.0
@export var attack_speed: float = 1.0
@export var reach_distance: float = 2.0

## Get actual damage considering quality
func get_damage() -> float:
	return base_damage * Item.get_quality_multiplier(quality)

## Get display name with quality
func get_display_name() -> String:
	return "%s %s" % [Item.get_quality_name(quality), item_name]
