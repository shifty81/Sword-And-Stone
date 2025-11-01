extends Weapon

## Iron Sword - A standard medieval sword

func _init():
	item_name = "Iron Sword"
	item_type = ItemType.WEAPON
	weapon_type = WeaponType.SWORD
	quality = Quality.COMMON
	
	description = "A well-balanced sword forged from iron. Good for combat and self-defense."
	
	base_damage = 15.0
	attack_speed = 1.2
	reach_distance = 2.5
	
	max_durability = 200
	durability = 200
	max_stack_size = 1
