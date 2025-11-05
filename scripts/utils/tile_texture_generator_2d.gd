extends RefCounted
class_name TileTextureGenerator2D

## Generates procedural 2D tile textures for terrain
## Creates tileable textures optimized for top-down view
##
## Note: The magic numbers used in texture generation (e.g., 7, 11, 37, 23, etc.)
## are intentionally varied to create unique procedural patterns for each terrain type.
## These create pseudo-random variation without requiring random number generators.
## Adjusting these values will change the visual appearance of the textures.

const TILE_SIZE = 32  # 32x32 pixel tiles for better detail in 2D

## Generate deep water texture with waves
static func generate_deep_water_tile() -> Image:
	var img = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.1, 0.2, 0.45)  # Deep blue
	var wave_color = Color(0.15, 0.25, 0.5)
	
	for y in range(TILE_SIZE):
		for x in range(TILE_SIZE):
			var wave = sin(x * 0.3 + y * 0.2) * 0.5 + 0.5
			var color = base_color.lerp(wave_color, wave * 0.3)
			
			# Add foam details
			if (x * 7 + y * 11) % 37 < 2:
				color = color.lightened(0.1)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate shallow water texture
static func generate_shallow_water_tile() -> Image:
	var img = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.2, 0.4, 0.6)  # Lighter blue
	var highlight_color = Color(0.25, 0.45, 0.65)
	
	for y in range(TILE_SIZE):
		for x in range(TILE_SIZE):
			var wave = sin(x * 0.4 + y * 0.3) * 0.5 + 0.5
			var color = base_color.lerp(highlight_color, wave * 0.4)
			
			# Sandy bottom showing through
			if (x * 5 + y * 7) % 23 < 3:
				color = color.lerp(Color(0.8, 0.75, 0.5), 0.2)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate sand texture
static func generate_sand_tile() -> Image:
	var img = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.85, 0.78, 0.55)
	
	for y in range(TILE_SIZE):
		for x in range(TILE_SIZE):
			var noise = sin(x * 0.7 + y * 0.5) * cos(x * 0.3 - y * 0.8)
			var color = base_color.lightened(noise * 0.08)
			
			# Add small stones
			if (x * 11 + y * 13) % 41 < 2:
				color = Color(0.6, 0.6, 0.55)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate grass texture
static func generate_grass_tile() -> Image:
	var img = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.3, 0.6, 0.25)
	var dark_grass = Color(0.25, 0.5, 0.2)
	var light_grass = Color(0.35, 0.65, 0.3)
	
	for y in range(TILE_SIZE):
		for x in range(TILE_SIZE):
			var noise = sin(x * 0.4 + y * 0.6) * cos(x * 0.5 - y * 0.4)
			var color = base_color.lerp(light_grass, (noise + 1.0) * 0.25)
			
			# Add grass blade details
			if (x * 7 + y * 5) % 17 < 3:
				color = dark_grass
			
			# Add small flowers randomly
			if (x * 13 + y * 17) % 71 < 1:
				color = Color(0.9, 0.85, 0.3)  # Yellow flowers
			
			img.set_pixel(x, y, color)
	
	return img

## Generate dirt texture
static func generate_dirt_tile() -> Image:
	var img = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.4, 0.25, 0.15)
	
	for y in range(TILE_SIZE):
		for x in range(TILE_SIZE):
			var noise = sin(x * 0.8 + y * 0.7) * cos(x * 0.6 - y * 0.9)
			var color = base_color.lightened(noise * 0.15)
			
			# Add pebbles
			if (x * 9 + y * 11) % 29 < 2:
				color = Color(0.5, 0.45, 0.4)
			
			# Add cracks
			if abs(sin(x * 2.1) * cos(y * 1.8)) > 0.95:
				color = color.darkened(0.3)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate stone texture
static func generate_stone_tile() -> Image:
	var img = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.5, 0.5, 0.52)
	var dark_stone = Color(0.4, 0.4, 0.42)
	
	for y in range(TILE_SIZE):
		for x in range(TILE_SIZE):
			var noise = sin(x * 0.5 + y * 0.6) * cos(x * 0.4 - y * 0.7)
			var color = base_color.lerp(dark_stone, (noise + 1.0) * 0.3)
			
			# Add cracks
			if abs(sin(x * 2.5) * cos(y * 2.2)) > 0.92:
				color = color.darkened(0.4)
			
			# Add lichen spots
			if (x * 17 + y * 19) % 53 < 2:
				color = color.lerp(Color(0.4, 0.6, 0.3), 0.3)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate snow texture
static func generate_snow_tile() -> Image:
	var img = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.95, 0.95, 1.0)
	
	for y in range(TILE_SIZE):
		for x in range(TILE_SIZE):
			var noise = sin(x * 0.6 + y * 0.8) * cos(x * 0.7 - y * 0.5)
			var color = base_color.lightened(noise * 0.03)
			
			# Add sparkle effect
			if (x * 11 + y * 13) % 31 < 1:
				color = Color.WHITE
			
			# Slight blue tint in shadows
			if (x + y) % 7 == 0:
				color = color.lerp(Color(0.9, 0.9, 1.0), 0.1)
			
			img.set_pixel(x, y, color)
	
	return img

## Generate forest/dense grass texture
static func generate_forest_tile() -> Image:
	var img = Image.create(TILE_SIZE, TILE_SIZE, false, Image.FORMAT_RGBA8)
	var base_color = Color(0.2, 0.5, 0.15)
	var dark_green = Color(0.15, 0.4, 0.1)
	var bright_green = Color(0.3, 0.6, 0.2)
	
	for y in range(TILE_SIZE):
		for x in range(TILE_SIZE):
			var noise = sin(x * 0.5 + y * 0.6) * cos(x * 0.4 - y * 0.7)
			var color = base_color.lerp(bright_green, (noise + 1.0) * 0.2)
			
			# Add darker patches (tree shadows)
			if (x * 3 + y * 5) % 13 < 5:
				color = color.lerp(dark_green, 0.4)
			
			# Add lighter grass
			if (x * 7 + y * 11) % 19 < 2:
				color = bright_green
			
			img.set_pixel(x, y, color)
	
	return img

## Generate all tiles and create a tileset atlas
static func generate_tileset_atlas() -> Image:
	# Create an atlas with all terrain types in a row
	var atlas_width = TILE_SIZE * 8  # 8 terrain types
	var atlas_height = TILE_SIZE
	var atlas = Image.create(atlas_width, atlas_height, false, Image.FORMAT_RGBA8)
	
	var tiles = [
		generate_deep_water_tile(),      # 0
		generate_shallow_water_tile(),   # 1
		generate_sand_tile(),            # 2
		generate_grass_tile(),           # 3
		generate_dirt_tile(),            # 4
		generate_stone_tile(),           # 5
		generate_snow_tile(),            # 6
		generate_forest_tile()           # 7
	]
	
	# Blit each tile into the atlas
	for i in range(tiles.size()):
		var tile = tiles[i]
		var x_offset = i * TILE_SIZE
		atlas.blit_rect(tile, Rect2i(0, 0, TILE_SIZE, TILE_SIZE), Vector2i(x_offset, 0))
	
	return atlas

## Save the tileset atlas to a file
static func save_tileset_atlas(path: String = "res://assets/textures/terrain/tileset_2d.png") -> bool:
	var atlas = generate_tileset_atlas()
	var err = atlas.save_png(path)
	
	if err == OK:
		print("Generated 2D tileset atlas: ", path)
		return true
	else:
		push_error("Failed to save 2D tileset atlas: " + path)
		return false
