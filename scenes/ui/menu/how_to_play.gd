extends Control

func _ready():
	GameManager.play_menu_music()

func _on_x_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu/menu_lepsze.tscn")
