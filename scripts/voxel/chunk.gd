extends StaticBody3D
class_name Chunk

## Represents a chunk of voxels in the world
## Uses mesh generation for efficient rendering

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
	
	# Initialize 3D voxel array
	voxels.resize(chunk_size)
	for x in range(chunk_size):
		voxels[x] = []
		voxels[x].resize(chunk_size)
		for y in range(chunk_size):
			voxels[x][y] = []
			voxels[x][y].resize(chunk_size)
	
	# Load voxel material with error handling
	voxel_material = load("res://materials/cel_material.tres")
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
	
	for x in range(chunk_size):
		for z in range(chunk_size):
			for y in range(chunk_size):
				var world_x = world_pos.x + x
				var world_y = world_pos.y + y
				var world_z = world_pos.z + z
				
				voxels[x][y][z] = world_generator.get_voxel_type(world_x, world_y, world_z)
	
	generate_mesh()

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
	
	# Set color once for all vertices of this face (performance optimization)
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
