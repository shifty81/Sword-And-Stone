extends Node

## WorldStateManager - Manages the global state of the Crimson Isles
## Handles day/night cycles, seasons, weather, and world progression

signal time_changed(hour: int, minute: int)
signal day_changed(day: int)
signal season_changed(season: Season)
signal weather_changed(weather: Weather)
signal entered_safe_zone
signal left_safe_zone

enum Season {
	SPRING,
	SUMMER,
	FALL,
	WINTER
}

enum Weather {
	CLEAR,
	LIGHT_RAIN,
	HEAVY_RAIN,
	THUNDERSTORM,
	SNOW,
	BLIZZARD,
	FOG
}

# Time settings
@export var time_scale: float = 1.0  # 1.0 = real-time, higher = faster
@export var minutes_per_day: float = 24.0  # Real minutes for a full day
@export var days_per_season: int = 7

# Current state
var current_hour: int = 8  # Start at 8 AM
var current_minute: int = 0
var current_day: int = 1
var current_season: Season = Season.SPRING
var current_weather: Weather = Weather.CLEAR

var is_daytime: bool = true
var is_in_safe_zone: bool = false

# Time tracking
var elapsed_time: float = 0.0
var seconds_per_minute: float = 1.0

func _ready():
	_calculate_time_scale()
	_determine_initial_weather()

func _calculate_time_scale():
	# Calculate how many real seconds = 1 game minute
	var minutes_in_day = 24.0 * 60.0  # 1440 game minutes
	seconds_per_minute = (minutes_per_day * 60.0) / minutes_in_day
	seconds_per_minute *= time_scale

func _process(delta):
	elapsed_time += delta
	
	# Update time
	if elapsed_time >= seconds_per_minute:
		elapsed_time -= seconds_per_minute
		_advance_time(1)

func _advance_time(minutes: int):
	current_minute += minutes
	
	if current_minute >= 60:
		current_hour += 1
		current_minute = 0
		
	if current_hour >= 24:
		current_hour = 0
		current_day += 1
		day_changed.emit(current_day)
		_check_season_change()
		_update_weather()
	
	var was_daytime = is_daytime
	is_daytime = current_hour >= 6 and current_hour < 20
	
	time_changed.emit(current_hour, current_minute)

func _check_season_change():
	var total_days = current_day - 1
	var season_index = int(total_days / days_per_season) % 4
	var new_season = season_index as Season
	
	if new_season != current_season:
		current_season = new_season
		season_changed.emit(current_season)
		_update_weather()

func _determine_initial_weather():
	_update_weather()

func _update_weather():
	# Weather chances based on season
	var weather_chances = _get_season_weather_chances()
	var roll = randf()
	var cumulative = 0.0
	
	for weather in weather_chances:
		cumulative += weather_chances[weather]
		if roll <= cumulative:
			if current_weather != weather:
				current_weather = weather
				weather_changed.emit(current_weather)
			return

func _get_season_weather_chances() -> Dictionary:
	match current_season:
		Season.SPRING:
			return {
				Weather.CLEAR: 0.5,
				Weather.LIGHT_RAIN: 0.3,
				Weather.HEAVY_RAIN: 0.15,
				Weather.FOG: 0.05
			}
		Season.SUMMER:
			return {
				Weather.CLEAR: 0.6,
				Weather.LIGHT_RAIN: 0.2,
				Weather.THUNDERSTORM: 0.15,
				Weather.FOG: 0.05
			}
		Season.FALL:
			return {
				Weather.CLEAR: 0.4,
				Weather.LIGHT_RAIN: 0.3,
				Weather.HEAVY_RAIN: 0.2,
				Weather.FOG: 0.1
			}
		Season.WINTER:
			return {
				Weather.CLEAR: 0.3,
				Weather.SNOW: 0.4,
				Weather.BLIZZARD: 0.2,
				Weather.FOG: 0.1
			}
	
	return {Weather.CLEAR: 1.0}

func get_time_string() -> String:
	return "%02d:%02d" % [current_hour, current_minute]

func get_season_name() -> String:
	match current_season:
		Season.SPRING: return "Spring"
		Season.SUMMER: return "Summer"
		Season.FALL: return "Fall"
		Season.WINTER: return "Winter"
	return "Unknown"

func get_weather_name() -> String:
	match current_weather:
		Weather.CLEAR: return "Clear"
		Weather.LIGHT_RAIN: return "Light Rain"
		Weather.HEAVY_RAIN: return "Heavy Rain"
		Weather.THUNDERSTORM: return "Thunderstorm"
		Weather.SNOW: return "Snow"
		Weather.BLIZZARD: return "Blizzard"
		Weather.FOG: return "Fog"
	return "Unknown"

func get_movement_modifier() -> float:
	# Weather affects movement speed
	match current_weather:
		Weather.BLIZZARD: return 0.5
		Weather.HEAVY_RAIN: return 0.8
		Weather.SNOW: return 0.7
		Weather.THUNDERSTORM: return 0.9
	return 1.0

func enter_safe_zone():
	if not is_in_safe_zone:
		is_in_safe_zone = true
		entered_safe_zone.emit()

func leave_safe_zone():
	if is_in_safe_zone:
		is_in_safe_zone = false
		left_safe_zone.emit()

func is_dangerous_time() -> bool:
	# Night time outside safe zones is dangerous
	return not is_daytime and not is_in_safe_zone
