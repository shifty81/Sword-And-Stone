extends Node
## Validation script to check if the Zylann.Voxel addon is properly set up
## Run this script to verify the addon integration

func _ready():
	print("\n=== Zylann.Voxel Addon Integration Check ===\n")
	
	var checks_passed = 0
	var checks_total = 0
	
	# Check 1: Plugin enabled in project settings
	checks_total += 1
	if check_plugin_enabled():
		print("✅ Plugin enabled in project.godot")
		checks_passed += 1
	else:
		print("❌ Plugin NOT enabled in project.godot")
	
	# Check 2: GDExtension file exists
	checks_total += 1
	if FileAccess.file_exists("res://addons/zylann.voxel/voxel.gdextension"):
		print("✅ GDExtension definition file found")
		checks_passed += 1
	else:
		print("❌ GDExtension definition file missing")
	
	# Check 3: Platform binaries exist
	checks_total += 1
	var platform = get_platform_name()
	var binary_path = get_platform_binary_path(platform)
	if binary_path and FileAccess.file_exists(binary_path):
		print("✅ Platform binaries found for: %s" % platform)
		checks_passed += 1
	elif binary_path:
		print("⚠️  Platform binaries NOT found for: %s" % platform)
		print("   Expected at: %s" % binary_path)
		print("   See addons/zylann.voxel/PLATFORM_BINARIES.md for installation")
	else:
		print("⚠️  Unknown platform or binary path")
	
	# Check 4: VoxelTerrainGenerator script exists
	checks_total += 1
	if FileAccess.file_exists("res://scripts/systems/world_generation/voxel_terrain_generator.gd"):
		print("✅ VoxelTerrainGenerator script found")
		checks_passed += 1
	else:
		print("❌ VoxelTerrainGenerator script missing")
	
	# Check 5: Test scene exists
	checks_total += 1
	if FileAccess.file_exists("res://scenes/test/voxel_terrain_test.tscn"):
		print("✅ Test scene found")
		checks_passed += 1
	else:
		print("❌ Test scene missing")
	
	# Check 6: Try to check if classes are available (will only work if binaries are present)
	checks_total += 1
	if check_voxel_classes_available():
		print("✅ Voxel classes are available (binaries loaded)")
		checks_passed += 1
	else:
		print("⚠️  Voxel classes NOT available (binaries not loaded or wrong platform)")
		print("   This is expected if platform binaries are missing")
	
	# Summary
	print("\n=== Summary ===")
	print("Checks passed: %d / %d" % [checks_passed, checks_total])
	
	if checks_passed == checks_total:
		print("\n🎉 SUCCESS! The addon is fully configured and ready to use!")
		print("   Open scenes/test/voxel_terrain_test.tscn to test it")
	elif checks_passed >= checks_total - 1:
		print("\n⚠️  MOSTLY READY: The addon is configured but may need platform binaries")
		print("   See addons/zylann.voxel/PLATFORM_BINARIES.md for details")
	else:
		print("\n❌ SETUP INCOMPLETE: Several components are missing")
		print("   Review the failed checks above")
	
	print("\n===========================================\n")
	
	# Auto-quit after 5 seconds if running in headless mode
	if DisplayServer.get_name() == "headless":
		await get_tree().create_timer(5.0).timeout
		get_tree().quit()

func check_plugin_enabled() -> bool:
	# Check if the plugin is listed in project settings
	var config = ConfigFile.new()
	var err = config.load("res://project.godot")
	if err != OK:
		return false
	
	var enabled_plugins = config.get_value("editor_plugins", "enabled", PackedStringArray())
	return "res://addons/zylann.voxel/" in enabled_plugins

func get_platform_name() -> String:
	# Note: BSD variants may or may not be compatible with Linux binaries
	# If you're on BSD, try using Linux binaries but they may not work
	match OS.get_name():
		"Linux":
			return "linux"
		"FreeBSD", "NetBSD", "OpenBSD", "BSD":
			# BSD systems may work with Linux binaries (not guaranteed)
			return "linux"
		"Windows":
			return "windows"
		"macOS":
			return "macos"
		"iOS":
			return "ios"
		"Android":
			return "android"
		_:
			return "unknown"

func get_platform_binary_path(platform: String) -> String:
	match platform:
		"linux":
			return "res://addons/zylann.voxel/bin/libvoxel.linux.editor.x86_64.so"
		"windows":
			return "res://addons/zylann.voxel/bin/libvoxel.windows.editor.x86_64.dll"
		"macos":
			return "res://addons/zylann.voxel/bin/libvoxel.macos.editor.universal.framework/libvoxel.macos.editor.universal"
		"ios":
			return "res://addons/zylann.voxel/bin/libvoxel.ios.editor.arm64.dylib"
		"android":
			return "res://addons/zylann.voxel/bin/libvoxel.android.editor.x86_64.so"
		_:
			return ""

func check_voxel_classes_available() -> bool:
	# Try to check if the VoxelBuffer class exists
	# This will only work if the GDExtension is properly loaded
	return ClassDB.class_exists("VoxelBuffer")
