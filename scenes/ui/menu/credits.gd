extends Control

func _ready() -> void:
	GameManager.play_menu_music()
	ButtonSoundManager.connect_buttons_in_tree(self)

func _on_x_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu/menu_lepsze.tscn")
