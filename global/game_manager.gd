extends Node

@export var collectibles_to_win: int = 5

var collectibles_gathered: int = 0
var menu_music_player: AudioStreamPlayer
var menu_music_stream = preload("res://assets/audio/soundtrack/music_1_cut.mp3")

const SETTINGS_PATH = "user://settings.cfg"

signal collectible_gathered(count: int)
signal game_won

func _ready():
	# Set default language to English
	TranslationServer.set_locale("en")
	
	# Load settings
	load_settings()
	
	# Persistent music in main menu
	menu_music_player = AudioStreamPlayer.new()
	menu_music_player.stream = menu_music_stream
	menu_music_player.volume_db = -1.015
	menu_music_player.bus = "Master"
	add_child(menu_music_player)

func play_menu_music():
	if not menu_music_player.playing:
		menu_music_player.play()

func stop_menu_music():
	if menu_music_player.playing:
		menu_music_player.stop()

func collect_item():
	collectibles_gathered += 1
	emit_signal("collectible_gathered", collectibles_gathered)
	
	print("Zebrano: ", collectibles_gathered, "/", collectibles_to_win)
	
	if collectibles_gathered >= collectibles_to_win:
		emit_signal("game_won")
		win_game()

func win_game():
	print("GG")
	get_tree().change_scene_to_file("res://scenes/ui/misc/win.tscn")

func reset_collectibles():
	collectibles_gathered = 0

func save_settings():
	var config = ConfigFile.new()
	
	# Save master volume
	var master_volume = AudioServer.get_bus_volume_db(0)
	config.set_value("audio", "master_volume", master_volume)
	
	# Save SFX volume
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	var sfx_volume = AudioServer.get_bus_volume_db(sfx_bus_index)
	config.set_value("audio", "sfx_volume", sfx_volume)
	
	# Save Music volume
	var music_bus_index = AudioServer.get_bus_index("Music")
	if music_bus_index != -1:
		var music_volume = AudioServer.get_bus_volume_db(music_bus_index)
		config.set_value("audio", "music_volume", music_volume)
	
	# Save language
	config.set_value("game", "language", TranslationServer.get_locale())
	
	config.save(SETTINGS_PATH)

func load_settings():
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_PATH)
	
	if err != OK:
		return
	
	# Load master volume
	if config.has_section_key("audio", "master_volume"):
		var master_volume = config.get_value("audio", "master_volume")
		AudioServer.set_bus_volume_db(0, master_volume)
	
	# Load SFX volume
	if config.has_section_key("audio", "sfx_volume"):
		var sfx_bus_index = AudioServer.get_bus_index("SFX")
		var sfx_volume = config.get_value("audio", "sfx_volume")
		AudioServer.set_bus_volume_db(sfx_bus_index, sfx_volume)
	
	# Load Music volume
	if config.has_section_key("audio", "music_volume"):
		var music_bus_index = AudioServer.get_bus_index("Music")
		if music_bus_index != -1:
			var music_volume = config.get_value("audio", "music_volume")
			AudioServer.set_bus_volume_db(music_bus_index, music_volume)
	
	# Load language
	if config.has_section_key("game", "language"):
		var language = config.get_value("game", "language")
		TranslationServer.set_locale(language)
