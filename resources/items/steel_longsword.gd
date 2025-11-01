extends Weapon

## Steel Longsword - A high-quality two-handed sword

func _init():
	item_name = "Steel Longsword"
	item_type = ItemType.WEAPON
	weapon_type = WeaponType.SWORD
	quality = Quality.GOOD
	
	description = "A masterfully crafted longsword made from high-grade steel. Excellent reach and damage."
	
	base_damage = 25.0
	attack_speed = 0.9
	reach_distance = 3.0
	
	max_durability = 400
	durability = 400
	max_stack_size = 1
