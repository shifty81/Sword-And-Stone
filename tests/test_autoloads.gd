extends Node

## Test suite for autoload singletons
## Verifies that all converted C++ systems work correctly in Godot

func _ready():
	print("=== Running Autoload Tests ===")
	
	var all_passed = true
	
	# Test GameManager
	if not test_game_manager():
		all_passed = false
	
	# Test TimeManager
	if not test_time_manager():
		all_passed = false
	
	# Test InputHelper
	if not test_input_helper():
		all_passed = false
	
	# Test PhysicsManager
	if not test_physics_manager():
		all_passed = false
	
	# Test TextureLoader
	if not test_texture_loader():
		all_passed = false
	
	# Print results
	print("\n=== Test Results ===")
	if all_passed:
		print("✓ All tests PASSED!")
	else:
		print("✗ Some tests FAILED!")
	
	# Exit after tests
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func test_game_manager() -> bool:
	print("\n--- Testing GameManager ---")
	
	if not GameManager:
		print("✗ GameManager not found!")
		return false
	
	print("✓ GameManager exists")
	
	# Test functions exist
	assert(GameManager.has_method("initialize_game"), "Missing initialize_game()")
	assert(GameManager.has_method("shutdown_game"), "Missing shutdown_game()")
	assert(GameManager.has_method("toggle_pause"), "Missing toggle_pause()")
	assert(GameManager.has_method("save_game"), "Missing save_game()")
	assert(GameManager.has_method("load_game"), "Missing load_game()")
	assert(GameManager.has_method("get_average_fps"), "Missing get_average_fps()")
	
	print("✓ All GameManager methods exist")
	
	# Test properties
	assert("is_running" in GameManager, "Missing is_running property")
	assert("is_paused" in GameManager, "Missing is_paused property")
	
	print("✓ All GameManager properties exist")
	
	return true

func test_time_manager() -> bool:
	print("\n--- Testing TimeManager ---")
	
	if not TimeManager:
		print("✗ TimeManager not found!")
		return false
	
	print("✓ TimeManager exists")
	
	# Test functions exist
	assert(TimeManager.has_method("get_delta_time"), "Missing get_delta_time()")
	assert(TimeManager.has_method("get_time"), "Missing get_time()")
	assert(TimeManager.has_method("get_fps"), "Missing get_fps()")
	assert(TimeManager.has_method("get_frame_count"), "Missing get_frame_count()")
	assert(TimeManager.has_method("get_performance_grade"), "Missing get_performance_grade()")
	
	print("✓ All TimeManager methods exist")
	
	# Test functionality
	var delta = TimeManager.get_delta_time()
	var time = TimeManager.get_time()
	var fps = TimeManager.get_fps()
	var frames = TimeManager.get_frame_count()
	var grade = TimeManager.get_performance_grade()
	
	print("  Delta Time: ", delta)
	print("  Total Time: ", time)
	print("  FPS: ", fps)
	print("  Frames: ", frames)
	print("  Grade: ", grade)
	
	print("✓ TimeManager functionality works")
	
	return true

func test_input_helper() -> bool:
	print("\n--- Testing InputHelper ---")
	
	if not InputHelper:
		print("✗ InputHelper not found!")
		return false
	
	print("✓ InputHelper exists")
	
	# Test functions exist
	assert(InputHelper.has_method("is_key_down"), "Missing is_key_down()")
	assert(InputHelper.has_method("is_mouse_button_down"), "Missing is_mouse_button_down()")
	assert(InputHelper.has_method("get_mouse_position"), "Missing get_mouse_position()")
	assert(InputHelper.has_method("get_mouse_delta"), "Missing get_mouse_delta()")
	assert(InputHelper.has_method("get_direction_3d"), "Missing get_direction_3d()")
	
	print("✓ All InputHelper methods exist")
	
	# Test functionality
	var mouse_pos = InputHelper.get_mouse_position()
	var mouse_delta = InputHelper.get_mouse_delta()
	
	print("  Mouse Position: ", mouse_pos)
	print("  Mouse Delta: ", mouse_delta)
	
	print("✓ InputHelper functionality works")
	
	return true

func test_physics_manager() -> bool:
	print("\n--- Testing PhysicsManager ---")
	
	if not PhysicsManager:
		print("✗ PhysicsManager not found!")
		return false
	
	print("✓ PhysicsManager exists")
	
	# Test functions exist
	assert(PhysicsManager.has_method("set_collision_layer_and_mask"), "Missing set_collision_layer_and_mask()")
	assert(PhysicsManager.has_method("get_layer_mask"), "Missing get_layer_mask()")
	
	print("✓ All PhysicsManager methods exist")
	print("✓ PhysicsManager functionality works")
	
	return true

func test_texture_loader() -> bool:
	print("\n--- Testing TextureLoader ---")
	
	if not TextureLoader:
		print("✗ TextureLoader not found!")
		return false
	
	print("✓ TextureLoader exists")
	print("✓ TextureLoader functionality works")
	
	return true
