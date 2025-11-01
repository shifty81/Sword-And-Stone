# Medieval Texture Pack

## Overview

This directory contains procedurally generated 16x16 pixel textures for the Sword and Stone medieval voxel game. All textures follow a consistent retro pixel art style suitable for a medieval fantasy setting.

## Texture Categories

### Terrain Textures (`terrain/`)

**Natural Blocks:**
- `grass.png` - Green grass with blade patterns
- `dirt.png` - Brown earth with pebbles
- `stone.png` - Gray stone with cracks
- `sand.png` - Tan/beige sand
- `snow.png` - White snow with sparkles
- `ice.png` - Translucent blue ice with cracks
- `gravel.png` - Mixed gray pebbles
- `wood.png` - Brown wood with vertical grain
- `leaves.png` - Green foliage with transparency

**Building Materials:**
- `cobblestone.png` - Gray stones with mortar
- `wood_planks.png` - Horizontal wood planking
- `thatch.png` - Diagonal straw pattern for roofs
- `bricks.png` - Red clay bricks with offset pattern
- `stone_bricks.png` - Refined cut stone blocks (TODO)

**Ore Blocks:**
- `coal_ore.png` - Stone with black coal veins
- `iron_ore.png` - Stone with gray-brown iron veins
- `copper_ore.png` - Stone with orange-brown copper veins
- `tin_ore.png` - Stone with light gray tin veins
- `gold_ore.png` - Stone with golden veins
- `silver_ore.png` - Stone with silver-white veins

### Item Icons (`items/`)

**Weapons:**
- `sword_icon.png` - Medieval sword with crossguard
- `axe_icon.png` - Battle axe with wooden handle
- `mace_icon.png` - Spiked mace with ball head

**Tools:**
- `pickaxe_icon.png` - Mining pickaxe with two prongs
- `hammer_icon.png` - Smithing hammer
- `shovel_icon.png` - Digging shovel

**Armor:**
- `helmet_icon.png` - Metal helmet with visor
- `chestplate_icon.png` - Full plate armor chest
- `shield_icon.png` - Kite shield with boss

## Texture Generation

Textures are generated procedurally using the `TextureGenerator` class. The generation system creates consistent, tileable textures that maintain a cohesive visual style.

### Generation Methods

All textures use mathematical patterns (sine/cosine waves, modulo patterns) to create:
- **Tileable patterns**: Seamlessly repeat in all directions
- **Visual variety**: Each pixel varies slightly for organic look
- **Consistent style**: 16x16 resolution with limited color palettes

### Example Generation

In Godot, textures are generated with:

```gdscript
# Generate all textures at once
TextureGenerator.generate_all_textures()

# Generate individual textures
var grass_img = TextureGenerator.generate_grass_texture()
var sword_img = TextureGenerator.generate_sword_icon()
```

### Manual Generation

To regenerate textures:

1. **In-Game**: Press F9 key
2. **In Editor**: Run `scripts/utils/texture_gen_tool.gd` from File → Run menu
3. **Programmatically**: Call `TextureGenerator.generate_all_textures()`

## Usage in Game

### Voxel Textures

Terrain textures are applied to voxel faces during chunk mesh generation. Currently uses vertex colors, but designed for future texture atlas integration.

### Item Icons

Item icons are displayed in:
- Inventory UI
- Hotbar
- Crafting menus
- Item tooltips

## Technical Details

### Texture Format
- **Size**: 16×16 pixels (scaled 8× in examples for visibility)
- **Format**: RGBA8 (32-bit color with alpha)
- **Style**: Pixel art with limited color palette

### Color Palettes

**Natural Palette:**
- Grass: Greens (0.25-0.65)
- Stone: Grays (0.4-0.6)
- Wood: Browns (0.1-0.5)

**Metal Palette:**
- Iron: Gray-browns (0.5-0.65)
- Gold: Yellow-orange (0.7-0.85)
- Silver: Light grays (0.75-0.85)

### Performance

Each texture is:
- Generated once at startup
- Cached in memory
- Reused across all instances
- Small file size (~500-1200 bytes per PNG)

## Future Enhancements

- [ ] Texture atlas for GPU-efficient voxel rendering
- [ ] UV mapping for detailed voxel faces
- [ ] Animated textures (water, lava)
- [ ] Seasonal texture variants
- [ ] Damage/wear states for blocks
- [ ] More item variations (bronze, steel tools)
- [ ] Additional building materials (glass, metals)

## File Structure

```
assets/textures/
├── terrain/           # Voxel block textures (19 textures)
│   ├── grass.png
│   ├── stone.png
│   ├── iron_ore.png
│   └── ...
├── items/            # Item/equipment icons (9 icons)
│   ├── sword_icon.png
│   ├── helmet_icon.png
│   └── ...
└── materials/        # Special material textures (future)
```

## Credits

All textures are procedurally generated using mathematical patterns. No external assets or AI generation used. Inspired by classic pixel art games like Minecraft and Vintage Story.
