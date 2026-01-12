extends Node

# Signals
signal collectible_gathered(count: int)
signal game_won

# Constants
const SETTINGS_PATH = "user://settings.cfg"

# Export variables
@export var collectibles_to_win: int = 5

# Regular variables
var collectibles_gathered: int = 0
var menu_music_player: AudioStreamPlayer
var menu_music_stream = preload("res://assets/audio/soundtrack/music_1_cut.mp3")

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
	get_tree().change_scene_to_file("res://scenes/ui/misc/win.tscn")

func reset_collectibles() -> void:
	collectibles_gathered = 0

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
