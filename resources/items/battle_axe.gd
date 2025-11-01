extends Weapon

## Battle Axe - Heavy damage but slow

func _init():
	item_name = "Battle Axe"
	item_type = ItemType.WEAPON
	weapon_type = WeaponType.AXE
	quality = Quality.COMMON
	
	description = "A heavy axe designed for combat. High damage but slower attack speed."
	
	base_damage = 22.0
	attack_speed = 0.8
	reach_distance = 2.3
	
	max_durability = 250
	durability = 250
	max_stack_size = 1
