#!/usr/bin/env python3
"""
Generate 2D tileset texture for Crimson Isles
Creates a PNG file with 8 terrain types in a horizontal atlas
"""

import math
import os
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("PIL/Pillow not installed. Attempting to generate placeholder...")
    print("Install with: pip install Pillow")
    exit(1)

TILE_SIZE = 32
NUM_TILES = 8

def generate_deep_water_tile():
    """Generate deep water tile"""
    img = Image.new('RGB', (TILE_SIZE, TILE_SIZE))
    pixels = img.load()
    
    for y in range(TILE_SIZE):
        for x in range(TILE_SIZE):
            wave = math.sin(x * 0.3 + y * 0.2) * 0.5 + 0.5
            r = int(25 + wave * 13)
            g = int(51 + wave * 13)
            b = int(115 + wave * 13)
            pixels[x, y] = (r, g, b)
    
    return img

def generate_shallow_water_tile():
    """Generate shallow water tile"""
    img = Image.new('RGB', (TILE_SIZE, TILE_SIZE))
    pixels = img.load()
    
    for y in range(TILE_SIZE):
        for x in range(TILE_SIZE):
            wave = math.sin(x * 0.4 + y * 0.3) * 0.5 + 0.5
            r = int(51 + wave * 13)
            g = int(102 + wave * 13)
            b = int(153 + wave * 13)
            pixels[x, y] = (r, g, b)
    
    return img

def generate_sand_tile():
    """Generate sand tile"""
    img = Image.new('RGB', (TILE_SIZE, TILE_SIZE))
    pixels = img.load()
    
    for y in range(TILE_SIZE):
        for x in range(TILE_SIZE):
            noise = math.sin(x * 0.7 + y * 0.5) * math.cos(x * 0.3 - y * 0.8)
            r = int(217 + noise * 17)
            g = int(199 + noise * 17)
            b = int(140 + noise * 17)
            pixels[x, y] = (r, g, b)
    
    return img

def generate_grass_tile():
    """Generate grass tile"""
    img = Image.new('RGB', (TILE_SIZE, TILE_SIZE))
    pixels = img.load()
    
    for y in range(TILE_SIZE):
        for x in range(TILE_SIZE):
            noise = math.sin(x * 0.4 + y * 0.6) * math.cos(x * 0.5 - y * 0.4)
            r = int(76 + noise * 25)
            g = int(153 + noise * 25)
            b = int(64 + noise * 25)
            
            # Add some grass blade variation
            if (x * 7 + y * 5) % 17 < 3:
                r, g, b = 64, 128, 51
            
            pixels[x, y] = (r, g, b)
    
    return img

def generate_dirt_tile():
    """Generate dirt tile"""
    img = Image.new('RGB', (TILE_SIZE, TILE_SIZE))
    pixels = img.load()
    
    for y in range(TILE_SIZE):
        for x in range(TILE_SIZE):
            noise = math.sin(x * 0.8 + y * 0.7) * math.cos(x * 0.6 - y * 0.9)
            r = int(102 + noise * 38)
            g = int(64 + noise * 38)
            b = int(38 + noise * 38)
            pixels[x, y] = (r, g, b)
    
    return img

def generate_stone_tile():
    """Generate stone tile"""
    img = Image.new('RGB', (TILE_SIZE, TILE_SIZE))
    pixels = img.load()
    
    for y in range(TILE_SIZE):
        for x in range(TILE_SIZE):
            noise = math.sin(x * 0.5 + y * 0.6) * math.cos(x * 0.4 - y * 0.7)
            base = 127
            r = int(base + noise * 25)
            g = int(base + noise * 25)
            b = int(base + noise * 26)
            pixels[x, y] = (r, g, b)
    
    return img

def generate_snow_tile():
    """Generate snow tile"""
    img = Image.new('RGB', (TILE_SIZE, TILE_SIZE))
    pixels = img.load()
    
    for y in range(TILE_SIZE):
        for x in range(TILE_SIZE):
            noise = math.sin(x * 0.6 + y * 0.8) * math.cos(x * 0.7 - y * 0.5)
            r = int(242 + noise * 7)
            g = int(242 + noise * 7)
            b = int(255)
            pixels[x, y] = (r, g, b)
    
    return img

def generate_forest_tile():
    """Generate forest/dense grass tile"""
    img = Image.new('RGB', (TILE_SIZE, TILE_SIZE))
    pixels = img.load()
    
    for y in range(TILE_SIZE):
        for x in range(TILE_SIZE):
            noise = math.sin(x * 0.5 + y * 0.6) * math.cos(x * 0.4 - y * 0.7)
            r = int(51 + noise * 20)
            g = int(127 + noise * 20)
            b = int(38 + noise * 20)
            
            # Add darker patches (tree shadows)
            if (x * 3 + y * 5) % 13 < 5:
                r = int(r * 0.6)
                g = int(g * 0.6)
                b = int(b * 0.6)
            
            pixels[x, y] = (r, g, b)
    
    return img

def generate_tileset_atlas():
    """Generate complete tileset atlas"""
    atlas = Image.new('RGB', (TILE_SIZE * NUM_TILES, TILE_SIZE))
    
    tiles = [
        generate_deep_water_tile(),
        generate_shallow_water_tile(),
        generate_sand_tile(),
        generate_grass_tile(),
        generate_dirt_tile(),
        generate_stone_tile(),
        generate_snow_tile(),
        generate_forest_tile()
    ]
    
    for i, tile in enumerate(tiles):
        atlas.paste(tile, (i * TILE_SIZE, 0))
    
    return atlas

def main():
    print("=== Generating 2D Tileset Texture ===")
    
    # Create output directory
    output_dir = Path(__file__).parent / "assets" / "textures" / "terrain"
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Generate and save
    output_path = output_dir / "tileset_2d.png"
    atlas = generate_tileset_atlas()
    atlas.save(output_path)
    
    print(f"✓ Tileset generated successfully!")
    print(f"✓ Saved to: {output_path}")
    print(f"✓ Size: {atlas.width}x{atlas.height} pixels")
    print(f"✓ Tiles: {NUM_TILES} types")
    print("=== Generation Complete ===")

if __name__ == "__main__":
    main()
