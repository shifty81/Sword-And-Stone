extends RefCounted
class_name VoxelType

## Defines all voxel types available in the game

enum Type {
	AIR = 0,
	GRASS = 1,
	DIRT = 2,
	STONE = 3,
	BEDROCK = 4,
	WATER = 5,
	SAND = 6,
	WOOD = 7,
	LEAVES = 8,
	IRON_ORE = 9,
	COPPER_ORE = 10,
	TIN_ORE = 11,
	COAL = 12,
	CLAY = 13,
	# Medieval building materials
	COBBLESTONE = 14,
	WOOD_PLANKS = 15,
	THATCH = 16,
	BRICKS = 17,
	STONE_BRICKS = 18,
	# Additional ores
	GOLD_ORE = 19,
	SILVER_ORE = 20,
	# Special blocks
	SNOW = 21,
	ICE = 22,
	GRAVEL = 23
}

## Check if a voxel type is solid
static func is_solid(type: Type) -> bool:
	return type != Type.AIR and type != Type.WATER

## Check if a voxel type is transparent
static func is_transparent(type: Type) -> bool:
	return type == Type.AIR or type == Type.WATER or type == Type.LEAVES

## Get the color for a voxel type
static func get_voxel_color(type: Type) -> Color:
	match type:
		Type.GRASS:
			return Color(0.3, 0.6, 0.2)
		Type.DIRT:
			return Color(0.5, 0.3, 0.1)
		Type.STONE:
			return Color(0.5, 0.5, 0.5)
		Type.BEDROCK:
			return Color(0.2, 0.2, 0.2)
		Type.WATER:
			return Color(0.2, 0.4, 0.8, 0.7)
		Type.SAND:
			return Color(0.8, 0.7, 0.4)
		Type.WOOD:
			return Color(0.4, 0.25, 0.1)
		Type.LEAVES:
			return Color(0.2, 0.5, 0.1, 0.8)
		Type.IRON_ORE:
			return Color(0.6, 0.5, 0.5)
		Type.COPPER_ORE:
			return Color(0.7, 0.4, 0.2)
		Type.TIN_ORE:
			return Color(0.6, 0.6, 0.6)
		Type.COAL:
			return Color(0.1, 0.1, 0.1)
		Type.CLAY:
			return Color(0.6, 0.5, 0.4)
		# Medieval building materials
		Type.COBBLESTONE:
			return Color(0.4, 0.4, 0.45)
		Type.WOOD_PLANKS:
			return Color(0.5, 0.3, 0.15)
		Type.THATCH:
			return Color(0.7, 0.6, 0.3)
		Type.BRICKS:
			return Color(0.6, 0.3, 0.2)
		Type.STONE_BRICKS:
			return Color(0.55, 0.55, 0.55)
		# Additional ores
		Type.GOLD_ORE:
			return Color(0.8, 0.7, 0.2)
		Type.SILVER_ORE:
			return Color(0.75, 0.75, 0.8)
		# Special blocks
		Type.SNOW:
			return Color(0.95, 0.95, 1.0)
		Type.ICE:
			return Color(0.7, 0.85, 1.0, 0.8)
		Type.GRAVEL:
			return Color(0.45, 0.45, 0.5)
		_:
			return Color.MAGENTA

## Get the hardness of a voxel type (for mining/breaking)
static func get_hardness(type: Type) -> float:
	match type:
		Type.AIR:
			return 0.0
		Type.GRASS:
			return 0.5
		Type.DIRT:
			return 0.5
		Type.STONE:
			return 2.0
		Type.BEDROCK:
			return -1.0  # Unbreakable
		Type.WATER:
			return 0.0
		Type.SAND:
			return 0.5
		Type.WOOD:
			return 1.5
		Type.LEAVES:
			return 0.2
		Type.IRON_ORE:
			return 3.0
		Type.COPPER_ORE:
			return 2.5
		Type.TIN_ORE:
			return 2.5
		Type.COAL:
			return 2.0
		Type.CLAY:
			return 0.6
		# Medieval building materials
		Type.COBBLESTONE:
			return 2.5
		Type.WOOD_PLANKS:
			return 1.5
		Type.THATCH:
			return 0.3
		Type.BRICKS:
			return 2.8
		Type.STONE_BRICKS:
			return 3.0
		# Additional ores
		Type.GOLD_ORE:
			return 3.5
		Type.SILVER_ORE:
			return 3.2
		# Special blocks
		Type.SNOW:
			return 0.3
		Type.ICE:
			return 0.8
		Type.GRAVEL:
			return 0.7
		_:
			return 1.0
