extends StaticBody3D
class_name Chunk

## Represents a chunk of voxels in the world
## Uses mesh generation for efficient rendering

const TREE_PLACEMENT_INTERVAL: int = 4  # Check every Nth block for performance
const DEBUG_CHUNK_Y: int = 2  # Y position of chunks to debug (at player start height)
const DEBUG_RANGE_X: int = 1  # Range of X chunks to debug around origin
const DEBUG_RANGE_Z: int = 1  # Range of Z chunks to debug around origin

var world_generator: WorldGenerator
var chunk_position: Vector3i
var chunk_size: int

var voxels: Array = []
var mesh_instance: MeshInstance3D
var collision_shape: CollisionShape3D
var voxel_material: Material
var needs_mesh_update: bool = false

func initialize(generator: WorldGenerator, chunk_pos: Vector3i, size: int):
	world_generator = generator
	chunk_position = chunk_pos
	chunk_size = size
	
	# Set physics layer for chunks (world geometry)
	if PhysicsManager:
		PhysicsManager.set_collision_layer_and_mask(
			self,
			PhysicsManager.LAYER_WORLD,
			0  # Chunks don't need to detect collisions, only be collided with
		)
	
	# Initialize 3D voxel array
	voxels.resize(chunk_size)
	for x in range(chunk_size):
		voxels[x] = []
		voxels[x].resize(chunk_size)
		for y in range(chunk_size):
			voxels[x][y] = []
			voxels[x][y].resize(chunk_size)
	
	# Load voxel material with error handling
	voxel_material = load("res://resources/materials/cel_material.tres")
	if voxel_material == null:
		push_error("Failed to load cel_material.tres - voxels will render with default material")
	
	# Create mesh instance
	mesh_instance = MeshInstance3D.new()
	add_child(mesh_instance)
	
	# Create collision shape
	collision_shape = CollisionShape3D.new()
	add_child(collision_shape)
	
	# Set position
	global_position = Vector3(
		chunk_position.x * chunk_size,
		chunk_position.y * chunk_size,
		chunk_position.z * chunk_size
	)

func generate_voxels():
	var world_pos = global_position
	var surface_block_counts = {}
	
	for x in range(chunk_size):
		for z in range(chunk_size):
			for y in range(chunk_size):
				var world_x = world_pos.x + x
				var world_y = world_pos.y + y
				var world_z = world_pos.z + z
				
				voxels[x][y][z] = world_generator.get_voxel_type(world_x, world_y, world_z)
				
				# Track surface blocks for debugging
				if chunk_position.y == DEBUG_CHUNK_Y:  # Chunk at player start height (32-47 blocks high)
					if y == chunk_size - 1:  # Top of this chunk
						var voxel_type = voxels[x][y][z]
						if not surface_block_counts.has(voxel_type):
							surface_block_counts[voxel_type] = 0
						surface_block_counts[voxel_type] += 1
	
	# Log surface composition for chunks near player start
	if chunk_position.y == DEBUG_CHUNK_Y and abs(chunk_position.x) <= DEBUG_RANGE_X and abs(chunk_position.z) <= DEBUG_RANGE_Z:
		print("Chunk [%d,%d,%d] surface blocks:" % [chunk_position.x, chunk_position.y, chunk_position.z])
		for voxel_type in surface_block_counts:
			var type_name = "UNKNOWN"
			var type_keys = VoxelType.Type.keys()
			# type_keys contains all enum values in order, guaranteed by Godot
			if voxel_type >= 0 and voxel_type < type_keys.size():
				type_name = type_keys[voxel_type]
			print("  %s: %d" % [type_name, surface_block_counts[voxel_type]])
	
	# Generate trees on surface (only in chunks at or near surface level)
	if chunk_position.y >= -2 and chunk_position.y <= 4:
		generate_trees()
	
	generate_mesh()

func generate_trees():
	# Only try to place trees in this chunk
	for x in range(0, chunk_size, TREE_PLACEMENT_INTERVAL):
		for z in range(0, chunk_size, TREE_PLACEMENT_INTERVAL):
			var world_x = global_position.x + x
			var world_z = global_position.z + z
			
			# Find surface height
			var surface_y = find_surface_y(x, z)
			if surface_y == -1:
				continue
			
			var world_y = global_position.y + surface_y
			var terrain_height = world_generator.get_terrain_height(world_x, world_z)
			var biome = world_generator.biome_generator.get_biome(world_x, world_z, terrain_height, world_generator.sea_level)
			
			# Check if tree should spawn
			if world_generator.tree_generator.should_spawn_tree(world_x, world_z, biome):
				# Generate tree voxels
				var tree_voxels = world_generator.tree_generator.generate_tree_voxels(
					int(world_x), int(world_y + 1), int(world_z)
				)
				
				# Place tree voxels in this chunk (if they fit)
				for voxel_data in tree_voxels:
					var local_x = voxel_data["x"] - int(global_position.x)
					var local_y = voxel_data["y"] - int(global_position.y)
					var local_z = voxel_data["z"] - int(global_position.z)
					
					if local_x >= 0 and local_x < chunk_size and \
					   local_y >= 0 and local_y < chunk_size and \
					   local_z >= 0 and local_z < chunk_size:
						voxels[local_x][local_y][local_z] = voxel_data["type"]

func find_surface_y(x: int, z: int) -> int:
	# Find the topmost solid voxel in this column
	for y in range(chunk_size - 1, -1, -1):
		if voxels[x][y][z] != VoxelType.Type.AIR and voxels[x][y][z] != VoxelType.Type.WATER:
			return y
	return -1

func generate_mesh():
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	var has_geometry = false
	for x in range(chunk_size):
		for y in range(chunk_size):
			for z in range(chunk_size):
				var voxel = voxels[x][y][z]
				
				if voxel == VoxelType.Type.AIR:
					continue
				
				# Check each face
				if should_draw_face(x, y, z, 0, 1, 0):  # Top
					add_face(surface_tool, x, y, z, 0, voxel)
					has_geometry = true
				if should_draw_face(x, y, z, 0, -1, 0):  # Bottom
					add_face(surface_tool, x, y, z, 1, voxel)
					has_geometry = true
				if should_draw_face(x, y, z, -1, 0, 0):  # Left
					add_face(surface_tool, x, y, z, 2, voxel)
					has_geometry = true
				if should_draw_face(x, y, z, 1, 0, 0):  # Right
					add_face(surface_tool, x, y, z, 3, voxel)
					has_geometry = true
				if should_draw_face(x, y, z, 0, 0, 1):  # Front
					add_face(surface_tool, x, y, z, 4, voxel)
					has_geometry = true
				if should_draw_face(x, y, z, 0, 0, -1):  # Back
					add_face(surface_tool, x, y, z, 5, voxel)
					has_geometry = true
	
	# Only commit if there's actual geometry
	if not has_geometry:
		mesh_instance.mesh = null
		collision_shape.shape = null
		return
	
	surface_tool.generate_normals()
	var mesh = surface_tool.commit()
	mesh_instance.mesh = mesh
	
	# Apply material to the mesh with verification
	if voxel_material and mesh:
		mesh_instance.set_surface_override_material(0, voxel_material)
	elif not voxel_material:
		push_warning("Chunk at %s: No material loaded, using default" % [chunk_position])
	
	# Create collision shape from mesh
	if mesh:
		var shape = mesh.create_trimesh_shape()
		collision_shape.shape = shape
	else:
		push_error("Failed to create mesh for chunk at %s" % [chunk_position])

func should_draw_face(x: int, y: int, z: int, dx: int, dy: int, dz: int) -> bool:
	var nx = x + dx
	var ny = y + dy
	var nz = z + dz
	
	# If neighbor is outside chunk, check adjacent chunk
	# For now, we draw the face (simpler approach)
	# TODO: Query adjacent chunks to prevent gaps at chunk boundaries
	if nx < 0 or nx >= chunk_size or ny < 0 or ny >= chunk_size or nz < 0 or nz >= chunk_size:
		return true
	
	var neighbor = voxels[nx][ny][nz]
	return not VoxelType.is_solid(neighbor) or VoxelType.is_transparent(neighbor)

func add_face(surface_tool: SurfaceTool, x: int, y: int, z: int, face: int, voxel_type: VoxelType.Type):
	var color = VoxelType.get_voxel_color(voxel_type)
	var vertices = get_face_vertices(x, y, z, face)
	
	# Set color for all vertices of this face
	surface_tool.set_color(color)
	
	# Add vertices in correct winding order
	surface_tool.add_vertex(vertices[0])
	surface_tool.add_vertex(vertices[1])
	surface_tool.add_vertex(vertices[2])
	
	surface_tool.add_vertex(vertices[2])
	surface_tool.add_vertex(vertices[3])
	surface_tool.add_vertex(vertices[0])

func get_face_vertices(x: int, y: int, z: int, face: int) -> Array:
	var pos = Vector3(x, y, z)
	var vertices = []
	
	match face:
		0:  # Top
			vertices = [
				pos + Vector3(0, 1, 0),
				pos + Vector3(0, 1, 1),
				pos + Vector3(1, 1, 1),
				pos + Vector3(1, 1, 0)
			]
		1:  # Bottom
			vertices = [
				pos + Vector3(0, 0, 0),
				pos + Vector3(1, 0, 0),
				pos + Vector3(1, 0, 1),
				pos + Vector3(0, 0, 1)
			]
		2:  # Left
			vertices = [
				pos + Vector3(0, 0, 0),
				pos + Vector3(0, 0, 1),
				pos + Vector3(0, 1, 1),
				pos + Vector3(0, 1, 0)
			]
		3:  # Right
			vertices = [
				pos + Vector3(1, 0, 0),
				pos + Vector3(1, 1, 0),
				pos + Vector3(1, 1, 1),
				pos + Vector3(1, 0, 1)
			]
		4:  # Front
			vertices = [
				pos + Vector3(0, 0, 1),
				pos + Vector3(1, 0, 1),
				pos + Vector3(1, 1, 1),
				pos + Vector3(0, 1, 1)
			]
		5:  # Back
			vertices = [
				pos + Vector3(0, 0, 0),
				pos + Vector3(0, 1, 0),
				pos + Vector3(1, 1, 0),
				pos + Vector3(1, 0, 0)
			]
	
	return vertices

func get_voxel(x: int, y: int, z: int) -> VoxelType.Type:
	if x < 0 or x >= chunk_size or y < 0 or y >= chunk_size or z < 0 or z >= chunk_size:
		return VoxelType.Type.AIR
	
	return voxels[x][y][z]

func _process(_delta):
	# Update mesh on next frame if needed (prevents freezing)
	if needs_mesh_update:
		needs_mesh_update = false
		generate_mesh()

func set_voxel(x: int, y: int, z: int, type: VoxelType.Type):
	if x < 0 or x >= chunk_size or y < 0 or y >= chunk_size or z < 0 or z >= chunk_size:
		return
	
	voxels[x][y][z] = type
	# Defer mesh regeneration to prevent freezing
	needs_mesh_update = true
