extends Node
class_name IsometricTileGenerator

## Generates isometric tile textures from flat terrain textures
## Creates 2.5D isometric blocks similar to Minecraft's isometric view

const TILE_WIDTH = 64
const TILE_HEIGHT = 32
const BLOCK_HEIGHT = 16  # Height of the vertical face in pixels

# Terrain colors - these match our existing terrain types
const TERRAIN_COLORS = {
	"water": Color(0.2, 0.4, 0.8),
	"sand": Color(0.9, 0.8, 0.5),
	"grass": Color(0.3, 0.7, 0.3),
	"dirt": Color(0.55, 0.4, 0.25),
	"stone": Color(0.5, 0.5, 0.5),
	"snow": Color(0.95, 0.95, 1.0),
	"wood": Color(0.6, 0.4, 0.2),
	"leaves": Color(0.2, 0.6, 0.2),
	"cobblestone": Color(0.4, 0.4, 0.4),
	"gravel": Color(0.6, 0.55, 0.5),
	"ice": Color(0.7, 0.85, 1.0),
	"coal_ore": Color(0.3, 0.3, 0.3),
	"iron_ore": Color(0.7, 0.6, 0.5),
	"gold_ore": Color(0.9, 0.8, 0.3),
	"copper_ore": Color(0.8, 0.5, 0.3),
}

## Generate a single isometric tile for a terrain type
static func generate_isometric_tile(terrain_name: String, base_color: Color = Color.WHITE) -> Image:
	# Use provided color or lookup from terrain colors
	var color = base_color if base_color != Color.WHITE else TERRAIN_COLORS.get(terrain_name, Color.GRAY)
	
	# Create image for isometric tile
	var img = Image.create(TILE_WIDTH, TILE_HEIGHT + BLOCK_HEIGHT, false, Image.FORMAT_RGBA8)
	
	# Draw the isometric block
	draw_isometric_block(img, color)
	
	return img

## Draw an isometric block (cube) on the image
static func draw_isometric_block(img: Image, color: Color):
	# Top face color (brightest)
	var top_color = color.lightened(0.3)
	# Left face color (darker)
	var left_color = color.darkened(0.2)
	# Right face color (medium)
	var right_color = color.darkened(0.1)
	
	# Draw top face (diamond/rhombus shape)
	draw_isometric_top(img, top_color)
	
	# Draw left face (parallelogram)
	draw_isometric_left(img, left_color)
	
	# Draw right face (parallelogram)
	draw_isometric_right(img, right_color)
	
	# Add outline for clarity
	draw_isometric_outline(img)

## Draw the top face of isometric block
static func draw_isometric_top(img: Image, color: Color):
	var half_w = TILE_WIDTH / 2
	var top_y = 0
	
	# Draw diamond shape for top face
	for y in range(TILE_HEIGHT / 2):
		var width = y * 2
		var start_x = half_w - y
		for x in range(width):
			if start_x + x >= 0 and start_x + x < TILE_WIDTH:
				img.set_pixel(start_x + x, top_y + y, color)
	
	for y in range(TILE_HEIGHT / 2):
		var width = (TILE_HEIGHT / 2 - y) * 2
		var start_x = half_w - (TILE_HEIGHT / 2 - y)
		for x in range(width):
			if start_x + x >= 0 and start_x + x < TILE_WIDTH:
				img.set_pixel(start_x + x, top_y + TILE_HEIGHT / 2 + y, color)

## Draw the left face of isometric block
static func draw_isometric_left(img: Image, color: Color):
	var half_w = TILE_WIDTH / 2
	var start_y = TILE_HEIGHT / 2
	
	# Draw left parallelogram
	for y in range(BLOCK_HEIGHT):
		var width = half_w
		var start_x = 0
		for x in range(width):
			if start_x + x < TILE_WIDTH:
				img.set_pixel(start_x + x, start_y + y, color)

## Draw the right face of isometric block
static func draw_isometric_right(img: Image, color: Color):
	var half_w = TILE_WIDTH / 2
	var start_y = TILE_HEIGHT / 2
	
	# Draw right parallelogram
	for y in range(BLOCK_HEIGHT):
		var width = half_w
		var start_x = half_w
		for x in range(width):
			if start_x + x < TILE_WIDTH:
				img.set_pixel(start_x + x, start_y + y, color)

## Draw outline for the isometric block
static func draw_isometric_outline(img: Image):
	var outline_color = Color(0, 0, 0, 0.5)
	var half_w = TILE_WIDTH / 2
	
	# Top diamond outline
	for y in range(TILE_HEIGHT / 2):
		var left_x = half_w - y
		var right_x = half_w + y
		if left_x >= 0:
			img.set_pixel(left_x, y, outline_color)
		if right_x < TILE_WIDTH:
			img.set_pixel(right_x, y, outline_color)
	
	for y in range(TILE_HEIGHT / 2):
		var left_x = y
		var right_x = TILE_WIDTH - y - 1
		if left_x >= 0:
			img.set_pixel(left_x, TILE_HEIGHT / 2 + y, outline_color)
		if right_x < TILE_WIDTH:
			img.set_pixel(right_x, TILE_HEIGHT / 2 + y, outline_color)
	
	# Left face outline
	for y in range(BLOCK_HEIGHT + 1):
		img.set_pixel(0, TILE_HEIGHT / 2 + y, outline_color)
		img.set_pixel(half_w - 1, TILE_HEIGHT / 2 + y, outline_color)
	
	# Right face outline  
	for y in range(BLOCK_HEIGHT + 1):
		img.set_pixel(half_w, TILE_HEIGHT / 2 + y, outline_color)
		if TILE_WIDTH - 1 < img.get_width():
			img.set_pixel(TILE_WIDTH - 1, TILE_HEIGHT / 2 + y, outline_color)
	
	# Bottom edges
	for x in range(half_w):
		img.set_pixel(x, TILE_HEIGHT / 2 + BLOCK_HEIGHT, outline_color)
		img.set_pixel(half_w + x, TILE_HEIGHT / 2 + BLOCK_HEIGHT, outline_color)

## Generate all terrain tiles and save as tileset atlas
static func generate_isometric_tileset() -> Image:
	var terrain_types = TERRAIN_COLORS.keys()
	var tiles_per_row = 4
	var rows = ceil(terrain_types.size() / float(tiles_per_row))
	
	var atlas_width = tiles_per_row * TILE_WIDTH
	var atlas_height = int(rows) * (TILE_HEIGHT + BLOCK_HEIGHT)
	
	var atlas = Image.create(atlas_width, atlas_height, false, Image.FORMAT_RGBA8)
	atlas.fill(Color(0, 0, 0, 0))  # Transparent background
	
	# Generate each tile
	var idx = 0
	for terrain_name in terrain_types:
		var color = TERRAIN_COLORS[terrain_name]
		var tile_img = generate_isometric_tile(terrain_name, color)
		
		var row = idx / tiles_per_row
		var col = idx % tiles_per_row
		
		var x_offset = col * TILE_WIDTH
		var y_offset = row * (TILE_HEIGHT + BLOCK_HEIGHT)
		
		# Blit tile onto atlas
		atlas.blit_rect(tile_img, Rect2i(0, 0, TILE_WIDTH, TILE_HEIGHT + BLOCK_HEIGHT), Vector2i(x_offset, y_offset))
		
		idx += 1
	
	return atlas

## Save the generated tileset to disk
static func save_isometric_tileset(path: String = "res://assets/textures/terrain/isometric_tileset.png") -> bool:
	var atlas = generate_isometric_tileset()
	var err = atlas.save_png(path)
	if err == OK:
		print("Isometric tileset saved to: ", path)
		return true
	else:
		push_error("Failed to save isometric tileset: ", err)
		return false
