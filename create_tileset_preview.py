#!/usr/bin/env python3
"""
Create a preview image showing each tile type with labels
"""

import math
from pathlib import Path

try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("PIL/Pillow not installed. Install with: pip install Pillow")
    exit(1)

TILE_SIZE = 32
PREVIEW_SCALE = 4  # Scale up tiles for better visibility
SPACING = 10

terrain_names = [
    "Deep Water",
    "Shallow Water",
    "Sand",
    "Grass",
    "Dirt",
    "Stone",
    "Snow",
    "Forest"
]

def create_preview():
    # Load the tileset
    tileset_path = Path(__file__).parent / "assets" / "textures" / "terrain" / "tileset_2d.png"
    tileset = Image.open(tileset_path)
    
    # Calculate preview dimensions
    scaled_tile = TILE_SIZE * PREVIEW_SCALE
    label_height = 30
    preview_width = scaled_tile + SPACING * 2
    preview_height = (scaled_tile + label_height + SPACING) * 8 + SPACING
    
    # Create preview image
    preview = Image.new('RGB', (preview_width, preview_height), (40, 40, 40))
    draw = ImageDraw.Draw(preview)
    
    # Try to use a nice font, fall back to default if not available
    try:
        font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 14)
    except:
        font = ImageFont.load_default()
    
    # Extract and display each tile
    for i in range(8):
        # Extract tile from atlas
        tile = tileset.crop((i * TILE_SIZE, 0, (i + 1) * TILE_SIZE, TILE_SIZE))
        
        # Scale up for preview
        tile_scaled = tile.resize((scaled_tile, scaled_tile), Image.NEAREST)
        
        # Calculate position
        y_pos = SPACING + i * (scaled_tile + label_height + SPACING)
        
        # Paste tile
        preview.paste(tile_scaled, (SPACING, y_pos))
        
        # Draw label
        text = terrain_names[i]
        # Get text bounding box for centering
        bbox = draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_x = SPACING + (scaled_tile - text_width) // 2
        text_y = y_pos + scaled_tile + 5
        
        draw.text((text_x, text_y), text, fill=(255, 255, 255), font=font)
    
    # Save preview
    output_path = Path(__file__).parent / "docs" / "tileset_preview.png"
    preview.save(output_path)
    print(f"✓ Preview saved to: {output_path}")
    
    # Also create a side-by-side comparison
    comparison_width = scaled_tile * 4 + SPACING * 5
    comparison_height = scaled_tile * 2 + SPACING * 3 + label_height * 2
    comparison = Image.new('RGB', (comparison_width, comparison_height), (40, 40, 40))
    comp_draw = ImageDraw.Draw(comparison)
    
    for i in range(8):
        tile = tileset.crop((i * TILE_SIZE, 0, (i + 1) * TILE_SIZE, TILE_SIZE))
        tile_scaled = tile.resize((scaled_tile, scaled_tile), Image.NEAREST)
        
        col = i % 4
        row = i // 4
        
        x_pos = SPACING + col * (scaled_tile + SPACING)
        y_pos = SPACING + row * (scaled_tile + label_height + SPACING)
        
        comparison.paste(tile_scaled, (x_pos, y_pos))
        
        text = terrain_names[i]
        bbox = comp_draw.textbbox((0, 0), text, font=font)
        text_width = bbox[2] - bbox[0]
        text_x = x_pos + (scaled_tile - text_width) // 2
        text_y = y_pos + scaled_tile + 5
        
        comp_draw.text((text_x, text_y), text, fill=(255, 255, 255), font=font)
    
    output_path2 = Path(__file__).parent / "docs" / "tileset_grid_preview.png"
    comparison.save(output_path2)
    print(f"✓ Grid preview saved to: {output_path2}")

if __name__ == "__main__":
    create_preview()
