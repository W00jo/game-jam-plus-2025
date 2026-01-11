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

func _ready() -> void:
	# Domyślny język - English
	TranslationServer.set_locale("en")
	
	load_settings()
	
	# Persistent music player for main menu
	menu_music_player = AudioStreamPlayer.new()
	menu_music_player.stream = menu_music_stream
	menu_music_player.volume_db = -1.015
	menu_music_player.bus = "Master"
	menu_music_player.finished.connect(_on_menu_music_finished)
	add_child(menu_music_player)

func play_menu_music() -> void:
	if not menu_music_player.playing:
		menu_music_player.play()

func stop_menu_music() -> void:
	if menu_music_player.playing:
		menu_music_player.stop()

func _on_menu_music_finished() -> void:
	# Loop od ~29 sekundy dla płynności
	menu_music_player.play(28.80)

## Zbieranie collectibles - główna mechanika gry
func collect_item() -> void:
	collectibles_gathered += 1
	emit_signal("collectible_gathered", collectibles_gathered)
	
	print("Zebrano: ", collectibles_gathered, "/", collectibles_to_win)
	
	# Win condition check
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
	
	# Save SFX volume
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	var sfx_volume = AudioServer.get_bus_volume_db(sfx_bus_index)
	config.set_value("audio", "sfx_volume", sfx_volume)
	
	# Save music volume
	var music_bus_index = AudioServer.get_bus_index("Music")
	if music_bus_index != -1:
		var music_volume = AudioServer.get_bus_volume_db(music_bus_index)
		config.set_value("audio", "music_volume", music_volume)
	
	# Save language preference
	config.set_value("game", "language", TranslationServer.get_locale())
	
	config.save(SETTINGS_PATH)

## Wczytywanie ustawień z pliku konfiguracyjnego
func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	
	if err != OK:
		return
	
	# Load SFX volume
	if config.has_section_key("audio", "sfx_volume"):
		var sfx_bus_index = AudioServer.get_bus_index("SFX")
		var sfx_volume = config.get_value("audio", "sfx_volume")
		AudioServer.set_bus_volume_db(sfx_bus_index, sfx_volume)
	
	# Load music volume
	if config.has_section_key("audio", "music_volume"):
		var music_bus_index = AudioServer.get_bus_index("Music")
		if music_bus_index != -1:
			var music_volume = config.get_value("audio", "music_volume")
			AudioServer.set_bus_volume_db(music_bus_index, music_volume)
	
	# Load language preference
	if config.has_section_key("game", "language"):
		var language = config.get_value("game", "language")
		TranslationServer.set_locale(language)
