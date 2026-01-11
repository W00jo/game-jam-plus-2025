extends Node

@export var collectibles_to_win: int = 5

var collectibles_gathered: int = 0

signal collectible_gathered(count: int)
signal game_won

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
