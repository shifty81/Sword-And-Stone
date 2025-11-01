extends Resource
class_name Item

## Base class for all items in the game

enum ItemType {
	RESOURCE,
	TOOL,
	WEAPON,
	ARMOR,
	CONSUMABLE
}

enum Quality {
	POOR = 0,
	COMMON = 1,
	GOOD = 2,
	EXCELLENT = 3,
	MASTERWORK = 4,
	LEGENDARY = 5
}

@export var item_name: String = "Item"
@export var item_type: ItemType = ItemType.RESOURCE
@export var quality: Quality = Quality.COMMON
@export var description: String = ""
@export var icon: Texture2D
@export var max_stack_size: int = 64
@export var durability: int = 100
@export var max_durability: int = 100

## Get quality multiplier for stats
static func get_quality_multiplier(quality_level: Quality) -> float:
	match quality_level:
		Quality.POOR:
			return 0.7
		Quality.COMMON:
			return 1.0
		Quality.GOOD:
			return 1.3
		Quality.EXCELLENT:
			return 1.6
		Quality.MASTERWORK:
			return 2.0
		Quality.LEGENDARY:
			return 2.5
		_:
			return 1.0

## Get quality name as string
static func get_quality_name(quality_level: Quality) -> String:
	match quality_level:
		Quality.POOR:
			return "Poor"
		Quality.COMMON:
			return "Common"
		Quality.GOOD:
			return "Good"
		Quality.EXCELLENT:
			return "Excellent"
		Quality.MASTERWORK:
			return "Masterwork"
		Quality.LEGENDARY:
			return "Legendary"
		_:
			return "Unknown"

## Get quality color
static func get_quality_color(quality_level: Quality) -> Color:
	match quality_level:
		Quality.POOR:
			return Color(0.6, 0.6, 0.6)
		Quality.COMMON:
			return Color(1.0, 1.0, 1.0)
		Quality.GOOD:
			return Color(0.3, 1.0, 0.3)
		Quality.EXCELLENT:
			return Color(0.3, 0.5, 1.0)
		Quality.MASTERWORK:
			return Color(0.8, 0.3, 1.0)
		Quality.LEGENDARY:
			return Color(1.0, 0.6, 0.1)
		_:
			return Color.WHITE
