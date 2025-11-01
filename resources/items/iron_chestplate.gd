extends Armor

## Iron Chestplate - Heavy armor protection

func _init():
	item_name = "Chestplate"
	item_type = ItemType.ARMOR
	armor_type = ArmorType.CHESTPLATE
	armor_material = ArmorMaterial.IRON
	quality = Quality.COMMON
	
	description = "Sturdy iron chestplate that provides good protection against physical attacks."
	
	base_defense = 12.0
	weight = 15.0
	
	max_durability = 300
	durability = 300
	max_stack_size = 1
