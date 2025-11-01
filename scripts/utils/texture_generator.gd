extends RefCounted
class_name TextureGenerator

## Generates procedural textures for medieval-themed game assets
## Creates tileable textures for voxels, items, and buildings

const TEXTURE_SIZE = 16  # 16x16 pixel textures for retro/pixelated look

## Generate a grass texture with blades of grass
static func generate_grass_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.35, 0.65, 0.25)
	var grass_color = Color(0.25, 0.55, 0.2)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			var noise = (sin(x * 0.7) + cos(y * 0.5)) * 0.1
			var color = base_color.lerp(grass_color, noise + 0.5)
			
			# Add random grass blades
			if (x + y * 7) % 13 < 2:
				color = grass_color.darkened(0.2)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate a dirt texture with earthy tones
static func generate_dirt_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.45, 0.28, 0.12)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			var noise = (sin(x * 1.2 + y * 0.8) + cos(x * 0.5 - y * 1.1)) * 0.15
			var color = base_color.lightened(noise)
			
			# Add small stones/pebbles
			if (x * 3 + y * 7) % 19 < 1:
				color = Color(0.5, 0.5, 0.5)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate a stone texture with cracks
static func generate_stone_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.5, 0.5, 0.52)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			var noise = (sin(x * 0.9 + y) + cos(x - y * 0.7)) * 0.1
			var color = base_color.lightened(noise)
			
			# Add cracks
			if abs(sin(x * 2.1) * cos(y * 1.7)) > 0.95:
				color = color.darkened(0.4)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate a sand texture
static func generate_sand_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.82, 0.72, 0.45)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			var noise = (sin(x * 1.3 + y * 0.7) + cos(x * 0.8 - y * 1.2)) * 0.08
			var color = base_color.lightened(noise)
			img.set_pixel(x, y, color)
	
	return img

## Generate snow texture
static func generate_snow_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.95, 0.95, 1.0)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			var noise = (sin(x * 0.9 + y * 1.1) + cos(x * 1.2 - y * 0.8)) * 0.05
			var color = base_color.lightened(noise)
			
			# Add sparkle effect
			if (x * 11 + y * 13) % 23 < 1:
				color = Color.WHITE
			
			img.set_pixel(x, y, color)
	
	return img

## Generate ice texture
static func generate_ice_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.7, 0.85, 1.0, 0.8)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			var noise = (sin(x * 1.5) + cos(y * 1.3)) * 0.1
			var color = base_color.lightened(noise)
			
			# Add crack lines
			if x == y or x + y == TEXTURE_SIZE - 1:
				color = color.lightened(0.2)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate leaves texture
static func generate_leaves_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.25, 0.5, 0.15, 0.9)
	var leaf_color = Color(0.2, 0.6, 0.1)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			var noise = (sin(x * 0.8 + y * 0.6) + cos(x * 0.5 - y * 0.9)) * 0.15
			var color = base_color.lerp(leaf_color, noise + 0.5)
			
			# Add gaps (transparency)
			if (x * 7 + y * 5) % 17 < 2:
				color.a = 0.3
			
			img.set_pixel(x, y, color)
	
	return img

## Generate gravel texture
static func generate_gravel_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.45, 0.45, 0.5)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			# Random pebbles
			var pebble_offset = (x * 7 + y * 11) % 13
			var color = base_color.lightened((pebble_offset - 6) * 0.03)
			
			# Darker gaps between pebbles
			if (x + y) % 3 == 0:
				color = color.darkened(0.2)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate a wood texture with grain
static func generate_wood_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.42, 0.27, 0.12)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			# Vertical wood grain
			var grain = sin(x * 0.5) * 0.15
			var color = base_color.lightened(grain)
			
			# Horizontal variations
			if y % 5 == 0:
				color = color.darkened(0.1)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate cobblestone texture
static func generate_cobblestone_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var stone_color = Color(0.42, 0.42, 0.45)
	var mortar_color = Color(0.3, 0.3, 0.32)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			var color = stone_color
			
			# Create cobblestone pattern
			var cell_x = int(x / 4)
			var cell_y = int(y / 4)
			var in_x = x % 4
			var in_y = y % 4
			
			# Mortar lines
			if in_x == 0 or in_y == 0:
				color = mortar_color
			else:
				# Vary stone colors
				var offset = (cell_x * 7 + cell_y * 11) % 10
				color = stone_color.lightened(offset * 0.02 - 0.1)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate wood planks texture
static func generate_wood_planks_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var wood_color = Color(0.52, 0.32, 0.16)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			var color = wood_color
			
			# Horizontal planks
			var plank = int(y / 5)
			
			# Plank gaps
			if y % 5 == 0:
				color = color.darkened(0.4)
			else:
				# Wood grain
				var grain = sin(x * 0.8 + plank * 2) * 0.1
				color = color.lightened(grain)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate thatch texture (for roofs)
static func generate_thatch_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var thatch_color = Color(0.72, 0.62, 0.32)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			# Diagonal straw pattern
			var straw = sin(x * 0.7 + y * 0.7) * 0.15
			var color = thatch_color.lightened(straw)
			
			# Add texture with random darker straws
			if (x * 5 + y * 3) % 11 < 2:
				color = color.darkened(0.2)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate brick texture
static func generate_brick_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var brick_color = Color(0.62, 0.32, 0.22)
	var mortar_color = Color(0.4, 0.4, 0.4)
	
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			var color = brick_color
			
			# Brick pattern (offset every other row)
			var row = int(y / 4)
			var x_offset = (row % 2) * 4
			var brick_x = (x + x_offset) % 8
			var brick_y = y % 4
			
			# Mortar lines
			if brick_y == 0 or brick_x == 0:
				color = mortar_color
			
			img.set_pixel(x, y, color)
	
	return img

## Generate copper ore texture
static func generate_copper_ore_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var stone_color = Color(0.5, 0.5, 0.52)
	var copper_color = Color(0.72, 0.42, 0.22)
	
	# Start with stone
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, stone_color)
	
	# Add copper veins
	for i in range(18):
		var cx = (i * 6) % TEXTURE_SIZE
		var cy = (i * 14) % TEXTURE_SIZE
		for dy in range(-1, 2):
			for dx in range(-1, 2):
				var px = (cx + dx + TEXTURE_SIZE) % TEXTURE_SIZE
				var py = (cy + dy + TEXTURE_SIZE) % TEXTURE_SIZE
				img.set_pixel(px, py, copper_color)
	
	return img

## Generate silver ore texture
static func generate_silver_ore_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var stone_color = Color(0.5, 0.5, 0.52)
	var silver_color = Color(0.8, 0.8, 0.85)
	
	# Start with stone
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, stone_color)
	
	# Add silver veins
	for i in range(12):
		var cx = (i * 8) % TEXTURE_SIZE
		var cy = (i * 15) % TEXTURE_SIZE
		for dy in range(-1, 2):
			for dx in range(-1, 2):
				if dx == 0 or dy == 0:
					var px = (cx + dx + TEXTURE_SIZE) % TEXTURE_SIZE
					var py = (cy + dy + TEXTURE_SIZE) % TEXTURE_SIZE
					img.set_pixel(px, py, silver_color)
	
	return img

## Generate tin ore texture
static func generate_tin_ore_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var stone_color = Color(0.5, 0.5, 0.52)
	var tin_color = Color(0.65, 0.65, 0.68)
	
	# Start with stone
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, stone_color)
	
	# Add tin veins
	for i in range(16):
		var cx = (i * 7) % TEXTURE_SIZE
		var cy = (i * 12) % TEXTURE_SIZE
		for dy in range(-1, 2):
			for dx in range(-1, 2):
				var px = (cx + dx + TEXTURE_SIZE) % TEXTURE_SIZE
				var py = (cy + dy + TEXTURE_SIZE) % TEXTURE_SIZE
				img.set_pixel(px, py, tin_color)
	
	return img

## Generate coal ore texture
static func generate_coal_ore_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var stone_color = Color(0.5, 0.5, 0.52)
	var coal_color = Color(0.1, 0.1, 0.12)
	
	# Start with stone
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, stone_color)
	
	# Add coal veins
	for i in range(20):
		var cx = (i * 7) % TEXTURE_SIZE
		var cy = (i * 11) % TEXTURE_SIZE
		for dy in range(-1, 2):
			for dx in range(-1, 2):
				var px = (cx + dx + TEXTURE_SIZE) % TEXTURE_SIZE
				var py = (cy + dy + TEXTURE_SIZE) % TEXTURE_SIZE
				img.set_pixel(px, py, coal_color)
	
	return img

## Generate iron ore texture
static func generate_iron_ore_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var stone_color = Color(0.5, 0.5, 0.52)
	var iron_color = Color(0.65, 0.52, 0.48)
	
	# Start with stone
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, stone_color)
	
	# Add iron veins
	for i in range(15):
		var cx = (i * 5) % TEXTURE_SIZE
		var cy = (i * 13) % TEXTURE_SIZE
		for dy in range(-1, 2):
			for dx in range(-1, 2):
				var px = (cx + dx + TEXTURE_SIZE) % TEXTURE_SIZE
				var py = (cy + dy + TEXTURE_SIZE) % TEXTURE_SIZE
				img.set_pixel(px, py, iron_color)
	
	return img

## Generate gold ore texture
static func generate_gold_ore_texture() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var stone_color = Color(0.5, 0.5, 0.52)
	var gold_color = Color(0.82, 0.72, 0.25)
	
	# Start with stone
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, stone_color)
	
	# Add gold veins (smaller, rarer)
	for i in range(10):
		var cx = (i * 9) % TEXTURE_SIZE
		var cy = (i * 17) % TEXTURE_SIZE
		for dy in range(-1, 2):
			for dx in range(-1, 2):
				if dx == 0 or dy == 0:  # Smaller veins
					var px = (cx + dx + TEXTURE_SIZE) % TEXTURE_SIZE
					var py = (cy + dy + TEXTURE_SIZE) % TEXTURE_SIZE
					img.set_pixel(px, py, gold_color)
	
	return img

## Generate a medieval sword icon
static func generate_sword_icon() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0, 0, 0, 0)  # Transparent
	var blade_color = Color(0.7, 0.7, 0.75)
	var hilt_color = Color(0.5, 0.3, 0.1)
	var pommel_color = Color(0.6, 0.5, 0.2)
	
	# Fill with transparent background
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, bg_color)
	
	# Draw blade (vertical, centered)
	for y in range(2, 11):
		img.set_pixel(7, y, blade_color)
		img.set_pixel(8, y, blade_color)
	
	# Draw point
	img.set_pixel(7, 1, blade_color)
	img.set_pixel(8, 1, blade_color)
	
	# Draw crossguard
	for x in range(5, 11):
		img.set_pixel(x, 11, hilt_color)
	
	# Draw grip
	for y in range(12, 15):
		img.set_pixel(7, y, hilt_color)
		img.set_pixel(8, y, hilt_color)
	
	# Draw pommel
	img.set_pixel(7, 15, pommel_color)
	img.set_pixel(8, 15, pommel_color)
	
	return img

## Generate a medieval axe icon
static func generate_axe_icon() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0, 0, 0, 0)
	var blade_color = Color(0.6, 0.6, 0.65)
	var handle_color = Color(0.4, 0.25, 0.1)
	
	# Fill with transparent background
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, bg_color)
	
	# Draw handle (diagonal)
	for i in range(8):
		var x = 6 + i
		var y = 8 + i
		if x < TEXTURE_SIZE and y < TEXTURE_SIZE:
			img.set_pixel(x, y, handle_color)
	
	# Draw blade head
	for y in range(3, 8):
		for x in range(8, 13):
			if x + y < 18:
				img.set_pixel(x, y, blade_color)
	
	return img

## Generate a medieval pickaxe icon
static func generate_pickaxe_icon() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0, 0, 0, 0)
	var blade_color = Color(0.6, 0.6, 0.65)
	var handle_color = Color(0.4, 0.25, 0.1)
	
	# Fill with transparent background
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, bg_color)
	
	# Draw handle (diagonal)
	for i in range(8):
		var x = 7 + i
		var y = 8 + i
		if x < TEXTURE_SIZE and y < TEXTURE_SIZE:
			img.set_pixel(x, y, handle_color)
			img.set_pixel(x-1, y, handle_color)
	
	# Draw pickaxe heads (two prongs)
	for x in range(4, 9):
		img.set_pixel(x, 7, blade_color)
		img.set_pixel(x, 8, blade_color)
	
	# Left prong
	for y in range(4, 8):
		img.set_pixel(4, y, blade_color)
	
	# Right prong
	for y in range(4, 8):
		img.set_pixel(8, y, blade_color)
	
	return img

## Generate a medieval hammer icon
static func generate_hammer_icon() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0, 0, 0, 0)
	var head_color = Color(0.5, 0.5, 0.55)
	var handle_color = Color(0.4, 0.25, 0.1)
	
	# Fill with transparent background
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, bg_color)
	
	# Draw handle (vertical)
	for y in range(8, TEXTURE_SIZE):
		img.set_pixel(7, y, handle_color)
		img.set_pixel(8, y, handle_color)
	
	# Draw hammer head (horizontal block)
	for y in range(4, 8):
		for x in range(5, 11):
			img.set_pixel(x, y, head_color)
	
	return img

## Generate a shovel icon
static func generate_shovel_icon() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0, 0, 0, 0)
	var blade_color = Color(0.5, 0.5, 0.55)
	var handle_color = Color(0.4, 0.25, 0.1)
	
	# Fill with transparent background
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, bg_color)
	
	# Draw handle (diagonal)
	for i in range(9):
		var x = 6 + i
		var y = 7 + i
		if x < TEXTURE_SIZE and y < TEXTURE_SIZE:
			img.set_pixel(x, y, handle_color)
	
	# Draw shovel blade
	for y in range(3, 7):
		for x in range(7, 10):
			img.set_pixel(x, y, blade_color)
	
	# Blade point
	img.set_pixel(8, 2, blade_color)
	
	return img

## Generate a mace icon
static func generate_mace_icon() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0, 0, 0, 0)
	var head_color = Color(0.5, 0.5, 0.5)
	var spike_color = Color(0.6, 0.6, 0.65)
	var handle_color = Color(0.4, 0.25, 0.1)
	
	# Fill with transparent background
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, bg_color)
	
	# Draw handle
	for y in range(7, TEXTURE_SIZE):
		img.set_pixel(7, y, handle_color)
		img.set_pixel(8, y, handle_color)
	
	# Draw mace head (ball)
	for dy in range(-2, 3):
		for dx in range(-2, 3):
			if dx * dx + dy * dy <= 4:
				img.set_pixel(7 + dx, 4 + dy, head_color)
	
	# Add spikes
	img.set_pixel(7, 2, spike_color)
	img.set_pixel(7, 6, spike_color)
	img.set_pixel(5, 4, spike_color)
	img.set_pixel(9, 4, spike_color)
	
	return img

## Generate a helmet icon
static func generate_helmet_icon() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0, 0, 0, 0)
	var metal_color = Color(0.6, 0.6, 0.65)
	
	# Fill with transparent background
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, bg_color)
	
	# Draw helmet dome
	for y in range(4, 9):
		var width = 5 - abs(y - 6)
		var start_x = 8 - width
		var end_x = 8 + width
		for x in range(start_x, end_x):
			img.set_pixel(x, y, metal_color)
	
	# Draw visor/eye slit
	for x in range(6, 10):
		img.set_pixel(x, 7, Color(0.1, 0.1, 0.1))
	
	# Draw bottom rim
	for x in range(5, 11):
		img.set_pixel(x, 9, metal_color)
	
	return img

## Generate a chestplate icon
static func generate_chestplate_icon() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0, 0, 0, 0)
	var metal_color = Color(0.6, 0.6, 0.65)
	var dark_metal = Color(0.4, 0.4, 0.45)
	
	# Fill with transparent background
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, bg_color)
	
	# Draw chest armor body
	for y in range(5, 13):
		for x in range(5, 11):
			img.set_pixel(x, y, metal_color)
	
	# Add center line detail
	for y in range(5, 13):
		img.set_pixel(8, y, dark_metal)
	
	# Shoulder guards
	for x in range(4, 7):
		img.set_pixel(x, 5, metal_color)
	for x in range(9, 12):
		img.set_pixel(x, 5, metal_color)
	
	return img

## Generate a shield icon
static func generate_shield_icon() -> Image:
	var img = Image.create(TEXTURE_SIZE, TEXTURE_SIZE, false, Image.FORMAT_RGBA8)
	var bg_color = Color(0, 0, 0, 0)
	var shield_color = Color(0.7, 0.2, 0.2)
	var metal_color = Color(0.6, 0.6, 0.65)
	
	# Fill with transparent background
	for y in range(TEXTURE_SIZE):
		for x in range(TEXTURE_SIZE):
			img.set_pixel(x, y, bg_color)
	
	# Draw shield body (kite shape)
	for y in range(3, 13):
		var width = 4 if y < 10 else 3 - (y - 10)
		width = max(width, 1)
		var start_x = 8 - width
		var end_x = 8 + width
		for x in range(start_x, end_x):
			img.set_pixel(x, y, shield_color)
	
	# Add metal boss (center)
	for dy in range(-1, 2):
		for dx in range(-1, 2):
			if abs(dx) + abs(dy) <= 1:
				img.set_pixel(8 + dx, 7 + dy, metal_color)
	
	return img

## Generate all textures and save them
static func generate_all_textures(base_path: String = "res://assets/textures/"):
	var terrain_path = base_path + "terrain/"
	var items_path = base_path + "items/"
	
	# Generate terrain textures
	var textures = {
		"grass.png": generate_grass_texture(),
		"dirt.png": generate_dirt_texture(),
		"stone.png": generate_stone_texture(),
		"sand.png": generate_sand_texture(),
		"snow.png": generate_snow_texture(),
		"ice.png": generate_ice_texture(),
		"gravel.png": generate_gravel_texture(),
		"wood.png": generate_wood_texture(),
		"leaves.png": generate_leaves_texture(),
		"cobblestone.png": generate_cobblestone_texture(),
		"wood_planks.png": generate_wood_planks_texture(),
		"thatch.png": generate_thatch_texture(),
		"bricks.png": generate_brick_texture(),
		"coal_ore.png": generate_coal_ore_texture(),
		"iron_ore.png": generate_iron_ore_texture(),
		"copper_ore.png": generate_copper_ore_texture(),
		"tin_ore.png": generate_tin_ore_texture(),
		"gold_ore.png": generate_gold_ore_texture(),
		"silver_ore.png": generate_silver_ore_texture()
	}
	
	# Save terrain textures
	for filename in textures:
		var img = textures[filename]
		var path = terrain_path + filename
		var err = img.save_png(path)
		if err == OK:
			print("Generated texture: ", path)
		else:
			push_error("Failed to save texture: " + path)
	
	# Generate item icons
	var item_textures = {
		"sword_icon.png": generate_sword_icon(),
		"axe_icon.png": generate_axe_icon(),
		"pickaxe_icon.png": generate_pickaxe_icon(),
		"hammer_icon.png": generate_hammer_icon(),
		"shovel_icon.png": generate_shovel_icon(),
		"mace_icon.png": generate_mace_icon(),
		"helmet_icon.png": generate_helmet_icon(),
		"chestplate_icon.png": generate_chestplate_icon(),
		"shield_icon.png": generate_shield_icon()
	}
	
	# Save item textures
	for filename in item_textures:
		var img = item_textures[filename]
		var path = items_path + filename
		var err = img.save_png(path)
		if err == OK:
			print("Generated item texture: ", path)
		else:
			push_error("Failed to save item texture: " + path)
	
	print("Texture generation complete!")
