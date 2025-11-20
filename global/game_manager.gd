extends Node

var collectibles_gathered: int = 0
const COLLECTIBLES_TO_WIN: int = 6

signal collectible_gathered(count: int)
signal game_won

func collect_item():
	collectibles_gathered += 1
	emit_signal("collectible_gathered", collectibles_gathered)
	
	print("Collected: ", collectibles_gathered, "/", COLLECTIBLES_TO_WIN)
	
	if collectibles_gathered >= COLLECTIBLES_TO_WIN:
		emit_signal("game_won")
		win_game()

func win_game():
	print("YOU WIN!")
	# You can add win logic here, like:
	# get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
	# or pause the game, show a win popup, etc.

func reset_collectibles():
	collectibles_gathered = 0
