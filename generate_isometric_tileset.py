#!/usr/bin/env python3
"""
Generate isometric tileset for Sword and Stone
Creates Minecraft-style isometric block tiles
"""

from PIL import Image, ImageDraw
import math

# Tile dimensions
TILE_WIDTH = 64
TILE_HEIGHT = 32
BLOCK_HEIGHT = 16

# Terrain colors matching the game's terrain types
TERRAIN_COLORS = {
    "water": (51, 102, 204),
    "sand": (230, 204, 128),
    "grass": (77, 179, 77),
    "dirt": (140, 102, 64),
    "stone": (128, 128, 128),
    "snow": (242, 242, 255),
    "wood": (153, 102, 51),
    "leaves": (51, 153, 51),
    "cobblestone": (102, 102, 102),
    "gravel": (153, 140, 128),
    "ice": (179, 217, 255),
    "coal_ore": (77, 77, 77),
    "iron_ore": (179, 153, 128),
    "gold_ore": (230, 204, 77),
    "copper_ore": (204, 128, 77),
}

def lighten_color(color, factor=0.3):
    """Lighten a color by a factor"""
    return tuple(min(255, int(c + (255 - c) * factor)) for c in color)

def darken_color(color, factor=0.2):
    """Darken a color by a factor"""
    return tuple(max(0, int(c * (1 - factor))) for c in color)

def draw_isometric_block(draw, x_offset, y_offset, color):
    """Draw an isometric block (cube) at given position"""
    # Calculate colors for different faces
    top_color = lighten_color(color, 0.3)
    left_color = darken_color(color, 0.2)
    right_color = darken_color(color, 0.1)
    outline_color = (0, 0, 0, 128)
    
    # Define points for each face
    # Top face (diamond)
    top_points = [
        (x_offset + TILE_WIDTH // 2, y_offset),  # Top
        (x_offset + TILE_WIDTH, y_offset + TILE_HEIGHT // 2),  # Right
        (x_offset + TILE_WIDTH // 2, y_offset + TILE_HEIGHT),  # Bottom
        (x_offset, y_offset + TILE_HEIGHT // 2),  # Left
    ]
    
    # Left face (parallelogram)
    left_points = [
        (x_offset, y_offset + TILE_HEIGHT // 2),  # Top left
        (x_offset + TILE_WIDTH // 2, y_offset + TILE_HEIGHT),  # Top right
        (x_offset + TILE_WIDTH // 2, y_offset + TILE_HEIGHT + BLOCK_HEIGHT),  # Bottom right
        (x_offset, y_offset + TILE_HEIGHT // 2 + BLOCK_HEIGHT),  # Bottom left
    ]
    
    # Right face (parallelogram)
    right_points = [
        (x_offset + TILE_WIDTH // 2, y_offset + TILE_HEIGHT),  # Top left
        (x_offset + TILE_WIDTH, y_offset + TILE_HEIGHT // 2),  # Top right
        (x_offset + TILE_WIDTH, y_offset + TILE_HEIGHT // 2 + BLOCK_HEIGHT),  # Bottom right
        (x_offset + TILE_WIDTH // 2, y_offset + TILE_HEIGHT + BLOCK_HEIGHT),  # Bottom left
    ]
    
    # Draw faces
    draw.polygon(top_points, fill=top_color)
    draw.polygon(left_points, fill=left_color)
    draw.polygon(right_points, fill=right_color)
    
    # Draw outlines
    draw.line(top_points + [top_points[0]], fill=outline_color, width=1)
    draw.line(left_points + [left_points[0]], fill=outline_color, width=1)
    draw.line(right_points + [right_points[0]], fill=outline_color, width=1)

def generate_isometric_tileset():
    """Generate complete isometric tileset"""
    terrain_types = list(TERRAIN_COLORS.keys())
    tiles_per_row = 4
    rows = math.ceil(len(terrain_types) / tiles_per_row)
    
    atlas_width = tiles_per_row * TILE_WIDTH
    atlas_height = rows * (TILE_HEIGHT + BLOCK_HEIGHT)
    
    # Create image with transparency
    atlas = Image.new('RGBA', (atlas_width, atlas_height), (0, 0, 0, 0))
    draw = ImageDraw.Draw(atlas)
    
    # Generate each tile
    for idx, terrain_name in enumerate(terrain_types):
        color = TERRAIN_COLORS[terrain_name]
        
        row = idx // tiles_per_row
        col = idx % tiles_per_row
        
        x_offset = col * TILE_WIDTH
        y_offset = row * (TILE_HEIGHT + BLOCK_HEIGHT)
        
        draw_isometric_block(draw, x_offset, y_offset, color)
        
        print(f"Generated {terrain_name} tile at ({col}, {row})")
    
    return atlas

def main():
    print("=== Isometric Tileset Generator ===")
    print(f"Tile size: {TILE_WIDTH}x{TILE_HEIGHT + BLOCK_HEIGHT}")
    print(f"Terrain types: {len(TERRAIN_COLORS)}")
    print()
    
    atlas = generate_isometric_tileset()
    
    output_path = "assets/textures/terrain/isometric_tileset.png"
    atlas.save(output_path)
    
    print()
    print(f"✓ Isometric tileset saved to: {output_path}")
    print(f"  Size: {atlas.width}x{atlas.height}")
    print(f"  Tiles: {len(TERRAIN_COLORS)}")

if __name__ == "__main__":
    main()
