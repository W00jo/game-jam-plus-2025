extends Control

func _ready():
	GameManager.play_menu_music()
	ButtonSoundManager.connect_buttons_in_tree(self)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/world.tscn")

func _on_how_to_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu/how_to_play.tscn")

func _on_opcje_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu/options.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu/credits.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_send_feedback_pressed() -> void:
	OS.shell_open("https://wujo-dev.itch.io/shoot-bro-loot")
