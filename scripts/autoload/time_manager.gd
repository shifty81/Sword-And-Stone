extends Node

## Time management singleton
## Converted from C++ TimeManager - provides frame timing and performance tracking
## Note: Godot has built-in Time and Engine classes, this adds convenience methods

signal fps_updated(fps: float)
signal performance_warning(metric: String, value: float)

# Time tracking
var delta_time: float = 0.0
var total_time: float = 0.0
var frame_count: int = 0

# FPS tracking
var current_fps: float = 0.0
var fps_timer: float = 0.0
var fps_counter: int = 0

# Performance thresholds
const TARGET_FPS: float = 60.0
const LOW_FPS_THRESHOLD: float = 30.0
const HIGH_FRAME_TIME_MS: float = 33.33  # ~30 FPS

# Statistics
var min_fps: float = INF
var max_fps: float = 0.0
var min_frame_time: float = INF
var max_frame_time: float = 0.0

func _ready() -> void:
	add_to_group("time_manager")
	process_mode = Node.PROCESS_MODE_ALWAYS
	initialize()
	print("TimeManager initialized")

## Initialize the time manager (converted from C++ TimeManager::Initialize)
func initialize() -> void:
	total_time = 0.0
	frame_count = 0
	current_fps = 0.0
	fps_timer = 0.0
	fps_counter = 0
	min_fps = INF
	max_fps = 0.0
	min_frame_time = INF
	max_frame_time = 0.0

## Main update function (converted from C++ TimeManager::Update)
func _process(delta: float) -> void:
	# Update delta time
	delta_time = delta
	total_time += delta
	frame_count += 1
	
	# Track frame time statistics
	var frame_time_ms = delta * 1000.0
	if frame_time_ms < min_frame_time:
		min_frame_time = frame_time_ms
	if frame_time_ms > max_frame_time:
		max_frame_time = frame_time_ms
	
	# Update FPS counter
	fps_timer += delta
	fps_counter += 1
	
	if fps_timer >= 1.0:
		current_fps = float(fps_counter) / fps_timer
		
		# Track FPS statistics
		if current_fps < min_fps:
			min_fps = current_fps
		if current_fps > max_fps:
			max_fps = current_fps
		
		# Emit FPS update
		fps_updated.emit(current_fps)
		
		# Check for performance issues
		if current_fps < LOW_FPS_THRESHOLD:
			performance_warning.emit("low_fps", current_fps)
		
		# Reset counters
		fps_timer = 0.0
		fps_counter = 0

## Get delta time (time since last frame)
func get_delta_time() -> float:
	return delta_time

## Get total elapsed time since initialization
func get_time() -> float:
	return total_time

## Get current frame count
func get_frame_count() -> int:
	return frame_count

## Get current FPS
func get_fps() -> float:
	return current_fps

## Get precise FPS from engine
func get_precise_fps() -> float:
	return Engine.get_frames_per_second()

## Get time since engine started (in seconds)
func get_time_since_start() -> float:
	return Time.get_ticks_msec() / 1000.0

## Get time since engine started (in milliseconds)
func get_time_since_start_msec() -> int:
	return Time.get_ticks_msec()

## Get high resolution time for precise measurements (in microseconds)
func get_high_resolution_time() -> int:
	return Time.get_ticks_usec()

## Get minimum FPS recorded
func get_min_fps() -> float:
	return min_fps if min_fps != INF else 0.0

## Get maximum FPS recorded
func get_max_fps() -> float:
	return max_fps

## Get minimum frame time in milliseconds
func get_min_frame_time_ms() -> float:
	return min_frame_time if min_frame_time != INF else 0.0

## Get maximum frame time in milliseconds
func get_max_frame_time_ms() -> float:
	return max_frame_time

## Get average frame time over last second (in milliseconds)
func get_average_frame_time_ms() -> float:
	if current_fps <= 0:
		return 0.0
	return 1000.0 / current_fps

## Check if frame rate is below target
func is_fps_below_target() -> bool:
	return current_fps < TARGET_FPS

## Check if frame rate is critically low
func is_fps_critical() -> bool:
	return current_fps < LOW_FPS_THRESHOLD

## Get performance grade (A, B, C, D, F)
func get_performance_grade() -> String:
	if current_fps >= TARGET_FPS:
		return "A"
	elif current_fps >= 45.0:
		return "B"
	elif current_fps >= 30.0:
		return "C"
	elif current_fps >= 20.0:
		return "D"
	else:
		return "F"

## Get formatted statistics string
func get_statistics_string() -> String:
	return """
TimeManager Statistics:
  Frame Count: %d
  Total Time: %.2f s
  Current FPS: %.1f
  Min FPS: %.1f
  Max FPS: %.1f
  Avg Frame Time: %.2f ms
  Min Frame Time: %.2f ms
  Max Frame Time: %.2f ms
  Performance Grade: %s
""" % [
		frame_count,
		total_time,
		current_fps,
		get_min_fps(),
		max_fps,
		get_average_frame_time_ms(),
		get_min_frame_time_ms(),
		max_frame_time,
		get_performance_grade()
	]

## Print performance statistics to console
func print_statistics() -> void:
	print(get_statistics_string())

## Reset statistics
func reset_statistics() -> void:
	min_fps = INF
	max_fps = 0.0
	min_frame_time = INF
	max_frame_time = 0.0
	print("TimeManager statistics reset")
