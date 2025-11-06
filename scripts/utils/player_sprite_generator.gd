extends Node
class_name PlayerSpriteGenerator

## Generates a cool-looking pixel art player sprite for top-down view
## Creates a medieval adventurer character with armor and a weapon

static func generate_player_sprite() -> Image:
	var width = 32
	var height = 32
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	# Color palette - medieval adventurer
	var skin_color = Color(0.95, 0.76, 0.65)  # Light skin tone
	var hair_color = Color(0.3, 0.2, 0.1)  # Dark brown hair
	var armor_primary = Color(0.4, 0.45, 0.5)  # Steel armor
	var armor_accent = Color(0.6, 0.5, 0.3)  # Bronze/gold trim
	var cape_color = Color(0.7, 0.1, 0.1)  # Red cape
	var weapon_color = Color(0.5, 0.5, 0.55)  # Silver sword
	var weapon_handle = Color(0.4, 0.25, 0.15)  # Brown handle
	var outline = Color(0.1, 0.1, 0.1)  # Dark outline
	
	# Draw from back to front (cape -> body -> head -> weapon)
	
	# Cape (back layer)
	_draw_pixel(image, 14, 18, cape_color)
	_draw_pixel(image, 15, 18, cape_color)
	_draw_pixel(image, 16, 18, cape_color)
	_draw_pixel(image, 17, 18, cape_color)
	_draw_pixel(image, 13, 19, cape_color)
	_draw_pixel(image, 14, 19, cape_color)
	_draw_pixel(image, 15, 19, cape_color)
	_draw_pixel(image, 16, 19, cape_color)
	_draw_pixel(image, 17, 19, cape_color)
	_draw_pixel(image, 18, 19, cape_color)
	_draw_pixel(image, 12, 20, cape_color)
	_draw_pixel(image, 13, 20, cape_color)
	_draw_pixel(image, 14, 20, cape_color)
	_draw_pixel(image, 17, 20, cape_color)
	_draw_pixel(image, 18, 20, cape_color)
	_draw_pixel(image, 19, 20, cape_color)
	
	# Body - torso (armor)
	for x in range(13, 19):
		for y in range(15, 19):
			if (x == 13 or x == 18) and (y == 15 or y == 18):
				continue  # Round corners
			_draw_pixel(image, x, y, armor_primary)
	
	# Armor detail/trim
	_draw_pixel(image, 14, 15, armor_accent)
	_draw_pixel(image, 15, 15, armor_accent)
	_draw_pixel(image, 16, 15, armor_accent)
	_draw_pixel(image, 17, 15, armor_accent)
	_draw_pixel(image, 15, 16, armor_accent)
	_draw_pixel(image, 16, 16, armor_accent)
	
	# Arms
	# Left arm
	_draw_pixel(image, 11, 16, armor_primary)
	_draw_pixel(image, 12, 16, armor_primary)
	_draw_pixel(image, 12, 17, armor_primary)
	_draw_pixel(image, 11, 17, skin_color)
	_draw_pixel(image, 10, 17, skin_color)
	
	# Right arm (holding weapon)
	_draw_pixel(image, 19, 16, armor_primary)
	_draw_pixel(image, 20, 16, armor_primary)
	_draw_pixel(image, 19, 17, armor_primary)
	_draw_pixel(image, 20, 17, skin_color)
	_draw_pixel(image, 21, 17, skin_color)
	
	# Legs/feet
	# Left leg
	_draw_pixel(image, 14, 19, armor_primary)
	_draw_pixel(image, 14, 20, armor_primary)
	_draw_pixel(image, 13, 21, Color(0.3, 0.25, 0.2))  # Boot
	_draw_pixel(image, 14, 21, Color(0.3, 0.25, 0.2))
	
	# Right leg
	_draw_pixel(image, 17, 19, armor_primary)
	_draw_pixel(image, 17, 20, armor_primary)
	_draw_pixel(image, 17, 21, Color(0.3, 0.25, 0.2))
	_draw_pixel(image, 18, 21, Color(0.3, 0.25, 0.2))
	
	# Head
	# Face/skin
	for x in range(14, 18):
		for y in range(11, 15):
			_draw_pixel(image, x, y, skin_color)
	
	# Hair
	_draw_pixel(image, 13, 10, hair_color)
	_draw_pixel(image, 14, 10, hair_color)
	_draw_pixel(image, 15, 10, hair_color)
	_draw_pixel(image, 16, 10, hair_color)
	_draw_pixel(image, 17, 10, hair_color)
	_draw_pixel(image, 18, 10, hair_color)
	_draw_pixel(image, 13, 11, hair_color)
	_draw_pixel(image, 18, 11, hair_color)
	_draw_pixel(image, 13, 12, hair_color)
	_draw_pixel(image, 18, 12, hair_color)
	
	# Eyes
	_draw_pixel(image, 14, 12, Color(0.2, 0.3, 0.4))  # Left eye
	_draw_pixel(image, 17, 12, Color(0.2, 0.3, 0.4))  # Right eye
	
	# Nose/mouth detail
	_draw_pixel(image, 15, 13, Color(0.85, 0.66, 0.55))
	_draw_pixel(image, 16, 13, Color(0.85, 0.66, 0.55))
	
	# Helmet/crown detail
	_draw_pixel(image, 14, 9, armor_accent)
	_draw_pixel(image, 15, 9, armor_accent)
	_draw_pixel(image, 16, 9, armor_accent)
	_draw_pixel(image, 17, 9, armor_accent)
	
	# Weapon (sword) - held at angle
	# Blade
	_draw_pixel(image, 22, 15, weapon_color)
	_draw_pixel(image, 23, 14, weapon_color)
	_draw_pixel(image, 24, 13, weapon_color)
	_draw_pixel(image, 25, 12, weapon_color)
	_draw_pixel(image, 26, 11, weapon_color)
	
	# Handle/Guard
	_draw_pixel(image, 21, 16, weapon_handle)
	_draw_pixel(image, 22, 16, weapon_color)  # Cross guard
	_draw_pixel(image, 22, 17, weapon_color)
	
	# Add outline to important features for that cel-shaded look
	_add_outlines(image, outline)
	
	return image

static func _draw_pixel(image: Image, x: int, y: int, color: Color):
	if x >= 0 and x < image.get_width() and y >= 0 and y < image.get_height():
		image.set_pixel(x, y, color)

static func _add_outlines(image: Image, outline_color: Color):
	var temp_image = image.duplicate()
	var width = image.get_width()
	var height = image.get_height()
	
	for y in range(height):
		for x in range(width):
			var pixel = temp_image.get_pixel(x, y)
			
			# If pixel has alpha and is visible
			if pixel.a > 0.5:
				# Check neighbors for transparent pixels
				var neighbors = [
					Vector2i(x-1, y), Vector2i(x+1, y),
					Vector2i(x, y-1), Vector2i(x, y+1),
					Vector2i(x-1, y-1), Vector2i(x+1, y-1),
					Vector2i(x-1, y+1), Vector2i(x+1, y+1)
				]
				
				for neighbor in neighbors:
					if neighbor.x >= 0 and neighbor.x < width and neighbor.y >= 0 and neighbor.y < height:
						var neighbor_pixel = temp_image.get_pixel(neighbor.x, neighbor.y)
						# If neighbor is transparent, add outline to current pixel
						if neighbor_pixel.a < 0.1:
							# Darken the edge slightly for outline effect
							var outlined = pixel.darkened(0.4)
							image.set_pixel(x, y, outlined)
							break

static func save_player_sprite(path: String) -> bool:
	var image = generate_player_sprite()
	var error = image.save_png(path)
	if error == OK:
		print("Player sprite saved to: ", path)
		return true
	else:
		push_error("Failed to save player sprite: " + str(error))
		return false
