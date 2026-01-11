extends Node

@export var collectibles_to_win: int = 5

var collectibles_gathered: int = 0
var menu_music_player: AudioStreamPlayer
var menu_music_stream = preload("res://assets/audio/sfx/music_1_cut.mp3")

signal collectible_gathered(count: int)
signal game_won

func _ready():
	# Set default language to English
	TranslationServer.set_locale("en")
	
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
