extends Node

# Signals
signal collectible_gathered(count: int)
signal game_won
signal enemy_hit
signal citizen_shot

# Constants
const SETTINGS_PATH = "user://settings.cfg"

# Export variables
@export var collectibles_to_win: int = 1

# Regular variables
var collectibles_gathered: int = 0
var menu_music_player: AudioStreamPlayer
var menu_music_stream = preload("res://assets/audio/soundtrack/music_1_cut.mp3")

# High-score tracking variables
var game_start_time: float = 0.0
var game_end_time: float = 0.0
var enemies_killed: int = 0
var citizens_shot: int = 0
var player_hits_taken: int = 0
var treasures_collected: int = 0
var is_game_active: bool = false

# Volume settings (0.0 to 1.0)
var music_volume: float = 0.5
var sfx_volume: float = 1.0

# Track previous scene for options menu navigation
var previous_scene: String = ""

func _ready() -> void:
	# Domyślny język = English
	TranslationServer.set_locale("en")
	
	load_settings()
	
	# Persistent music player for main menu
	menu_music_player = AudioStreamPlayer.new()
	menu_music_player.stream = menu_music_stream
	menu_music_player.bus = "Master"
	menu_music_player.finished.connect(_on_menu_music_finished)
	add_child(menu_music_player)

func play_menu_music():
	if not menu_music_player.playing:
		menu_music_player.volume_db = linear_to_db(music_volume)
		menu_music_player.play()

func stop_menu_music() -> void:
	if menu_music_player.playing:
		menu_music_player.stop()

func _on_menu_music_finished() -> void:
	# Loop od ~29 sekundy dla płynności
	menu_music_player.play(28.80)

## Zbieranie = główna mechanika gry
func collect_item() -> void:
	collectibles_gathered += 1
	emit_signal("collectible_gathered", collectibles_gathered)
	
	print("Zebrano: ", collectibles_gathered, "/", collectibles_to_win)
	
	# Win con check
	if collectibles_gathered >= collectibles_to_win:
		emit_signal("game_won")
		win_game()

func win_game() -> void:
	print("GG")
	get_tree().call_deferred("change_scene_to_file", "res://scenes/ui/misc/win.tscn")

func reset_collectibles() -> void:
	collectibles_gathered = 0

## Start tracking game session for high-score
func start_game_session() -> void:
	game_start_time = Time.get_ticks_msec() / 1000.0
	is_game_active = true
	enemies_killed = 0
	citizens_shot = 0
	player_hits_taken = 0
	treasures_collected = 0

## Record enemy kill
func record_enemy_kill() -> void:
	if is_game_active:
		enemies_killed += 1
		emit_signal("enemy_hit")
	else:
		print("Game session not active")

## Record citizen shot (penalty)
func record_citizen_shot() -> void:
	if is_game_active:
		citizens_shot += 1
		emit_signal("citizen_shot")

## Record player damage (penalty)
func record_player_hit() -> void:
	if is_game_active:
		player_hits_taken += 1

## Record treasure collected (bonus)
func record_treasure_collected() -> void:
	if is_game_active:
		treasures_collected += 1
	else:
		print("Game session not active!")

## Calculate final high-score
func calculate_high_score() -> Dictionary:
	game_end_time = Time.get_ticks_msec() / 1000.0
	var time_taken = game_end_time - game_start_time
	is_game_active = false
	
	# Base score: 10000 points
	var base_score = 10000
	
	# Time penalty: lose 10 points per second (faster is better)
	var time_penalty = int(time_taken * 10)
	
	# Enemy kill bonus: 100 points per enemy
	var enemy_bonus = enemies_killed * 100
	
	# Treasure bonus: 500 points per treasure
	var treasure_bonus = treasures_collected * 500
	
	# Citizen penalty: -300 points per citizen shot
	var citizen_penalty = citizens_shot * 300
	
	# Player damage penalty: -150 points per hit taken
	var damage_penalty = player_hits_taken * 150
	
	# Calculate final score
	var final_score = base_score - time_penalty + enemy_bonus + treasure_bonus - citizen_penalty - damage_penalty
	final_score = max(0, final_score)  # Never go below 0
	
	# Return detailed breakdown
	return {
		"final_score": final_score,
		"time_taken": time_taken,
		"enemies_killed": enemies_killed,
		"treasures_collected": treasures_collected,
		"citizens_shot": citizens_shot,
		"player_hits_taken": player_hits_taken,
		"base_score": base_score,
		"time_penalty": time_penalty,
		"enemy_bonus": enemy_bonus,
		"treasure_bonus": treasure_bonus,
		"citizen_penalty": citizen_penalty,
		"damage_penalty": damage_penalty
	}

## Zapis ustawień do pliku konfiguracyjnego
func save_settings() -> void:
	var config = ConfigFile.new()
	
	# Save music and SFX volumes as 0-1 values
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	
	# Save language preference
	config.set_value("game", "language", TranslationServer.get_locale())
	
	config.save(SETTINGS_PATH)

## Wczytywanie ustawień z pliku konfiguracyjnego
func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	
	if err != OK:
		# Defaults already set in variable declarations
		return
	
	# Load music volume
	if config.has_section_key("audio", "music_volume"):
		music_volume = config.get_value("audio", "music_volume")
	
	# Load SFX volume
	if config.has_section_key("audio", "sfx_volume"):
		sfx_volume = config.get_value("audio", "sfx_volume")
	
	# Load language preference
	if config.has_section_key("game", "language"):
		var language = config.get_value("game", "language")
		TranslationServer.set_locale(language)
