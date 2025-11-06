#!/usr/bin/env python3
"""
Generate a cool pixel art player sprite for the Crimson Isles game.
Creates a medieval adventurer character with armor, cape, and sword.
"""

from PIL import Image, ImageDraw

def generate_player_sprite(width=32, height=32):
    """Generate a pixel art player sprite with transparent background"""
    
    # Create image with transparency
    img = Image.new('RGBA', (width, height), (0, 0, 0, 0))
    pixels = img.load()
    
    # Color palette - medieval adventurer
    skin_color = (242, 194, 165, 255)  # Light skin tone
    hair_color = (76, 51, 25, 255)  # Dark brown hair
    armor_primary = (102, 115, 127, 255)  # Steel armor
    armor_accent = (153, 127, 76, 255)  # Bronze/gold trim
    cape_color = (178, 25, 25, 255)  # Red cape
    weapon_color = (127, 127, 140, 255)  # Silver sword
    weapon_handle = (102, 63, 38, 255)  # Brown handle
    outline = (25, 25, 25, 255)  # Dark outline
    boot_color = (76, 63, 51, 255)  # Leather boots
    eye_color = (51, 76, 102, 255)  # Blue eyes
    shadow_color = (216, 168, 140, 255)  # Skin shadow
    
    def set_pixel(x, y, color):
        """Safely set a pixel if within bounds"""
        if 0 <= x < width and 0 <= y < height:
            pixels[x, y] = color
    
    # Draw from back to front (cape -> body -> head -> weapon)
    
    # === CAPE (back layer) ===
    cape_pixels = [
        (14, 18), (15, 18), (16, 18), (17, 18),
        (13, 19), (14, 19), (15, 19), (16, 19), (17, 19), (18, 19),
        (12, 20), (13, 20), (14, 20), (17, 20), (18, 20), (19, 20),
        (13, 21), (14, 21), (17, 21), (18, 21),
    ]
    for x, y in cape_pixels:
        set_pixel(x, y, cape_color)
    
    # === BODY - TORSO (armor) ===
    for x in range(13, 19):
        for y in range(15, 19):
            if (x == 13 or x == 18) and (y == 15 or y == 18):
                continue  # Round corners
            set_pixel(x, y, armor_primary)
    
    # Armor detail/trim (chest plate)
    armor_trim = [
        (14, 15), (15, 15), (16, 15), (17, 15),
        (15, 16), (16, 16),
    ]
    for x, y in armor_trim:
        set_pixel(x, y, armor_accent)
    
    # === ARMS ===
    # Left arm
    arm_left = [
        (11, 16), (12, 16), (12, 17), (11, 17), (10, 17),
    ]
    for i, (x, y) in enumerate(arm_left):
        color = armor_primary if i < 3 else skin_color
        set_pixel(x, y, color)
    
    # Right arm (holding weapon)
    arm_right = [
        (19, 16), (20, 16), (19, 17), (20, 17), (21, 17),
    ]
    for i, (x, y) in enumerate(arm_right):
        color = armor_primary if i < 3 else skin_color
        set_pixel(x, y, color)
    
    # === LEGS/FEET ===
    # Left leg
    set_pixel(14, 19, armor_primary)
    set_pixel(14, 20, armor_primary)
    set_pixel(13, 21, boot_color)
    set_pixel(14, 21, boot_color)
    set_pixel(13, 22, boot_color)
    set_pixel(14, 22, boot_color)
    
    # Right leg
    set_pixel(17, 19, armor_primary)
    set_pixel(17, 20, armor_primary)
    set_pixel(17, 21, boot_color)
    set_pixel(18, 21, boot_color)
    set_pixel(17, 22, boot_color)
    set_pixel(18, 22, boot_color)
    
    # === HEAD ===
    # Face/skin
    for x in range(14, 18):
        for y in range(11, 15):
            set_pixel(x, y, skin_color)
    
    # Hair
    hair_pixels = [
        (13, 10), (14, 10), (15, 10), (16, 10), (17, 10), (18, 10),
        (13, 11), (18, 11),
        (13, 12), (18, 12),
        (13, 13), (18, 13),
    ]
    for x, y in hair_pixels:
        set_pixel(x, y, hair_color)
    
    # Eyes
    set_pixel(14, 12, eye_color)
    set_pixel(17, 12, eye_color)
    
    # Nose/mouth detail (shadow)
    set_pixel(15, 13, shadow_color)
    set_pixel(16, 13, shadow_color)
    
    # Helmet/crown accent
    helmet_trim = [(14, 9), (15, 9), (16, 9), (17, 9)]
    for x, y in helmet_trim:
        set_pixel(x, y, armor_accent)
    
    # === WEAPON (sword) - held at angle ===
    # Blade (diagonal)
    blade_pixels = [
        (22, 15), (23, 14), (24, 13), (25, 12), (26, 11),
        (22, 16),  # Wider blade base
    ]
    for x, y in blade_pixels:
        set_pixel(x, y, weapon_color)
    
    # Handle/Guard
    set_pixel(21, 16, weapon_handle)
    set_pixel(21, 17, weapon_handle)
    set_pixel(22, 17, weapon_color)  # Cross guard
    
    # === ADD OUTLINES ===
    # Create a copy for outline detection
    temp_img = img.copy()
    temp_pixels = temp_img.load()
    
    for y in range(height):
        for x in range(width):
            if temp_pixels[x, y][3] > 128:  # If pixel is visible
                # Check 8 neighbors
                neighbors = [
                    (x-1, y), (x+1, y), (x, y-1), (x, y+1),
                    (x-1, y-1), (x+1, y-1), (x-1, y+1), (x+1, y+1)
                ]
                
                for nx, ny in neighbors:
                    if 0 <= nx < width and 0 <= ny < height:
                        if temp_pixels[nx, ny][3] < 10:  # If neighbor is transparent
                            # Darken this pixel for outline
                            current = temp_pixels[x, y]
                            darkened = tuple(max(0, int(c * 0.3)) for c in current[:3]) + (255,)
                            set_pixel(x, y, darkened)
                            break
    
    return img

def main():
    """Generate and save the player sprite"""
    import sys
    
    # Allow custom output path from command line
    output_base = "assets/sprites/player_character.png"
    if len(sys.argv) > 1:
        output_base = sys.argv[1]
    
    print("🎨 Generating cool player sprite...")
    
    # Generate the sprite
    sprite = generate_player_sprite(32, 32)
    
    # Save to assets folder
    sprite.save(output_base)
    print(f"✅ Player sprite saved to: {output_base}")
    
    # Also create a larger version for preview
    large_sprite = sprite.resize((128, 128), Image.NEAREST)
    preview_path = output_base.replace('.png', '_preview.png')
    large_sprite.save(preview_path)
    print(f"✅ Preview sprite saved to: {preview_path}")
    
    print("\n🎮 Player sprite generation complete!")
    print("📏 Size: 32x32 pixels")
    print("🎨 Style: Pixel art, medieval adventurer")
    print("⚔️  Features: Cape, armor, sword, helmet")
    
    # Usage information
    if len(sys.argv) == 1:
        print("\n💡 Tip: You can specify custom output path:")
        print(f"   python3 {sys.argv[0] if sys.argv else 'generate_player_sprite.py'} path/to/output.png")

if __name__ == "__main__":
    main()
