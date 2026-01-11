extends Control

@onready var godot_head = $GodotHead3D/SubViewport/Head
var time_passed = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	if godot_head:
		time_passed += delta
		godot_head.rotation.y += delta * 0.5
		godot_head.position.y = sin(time_passed * 2.0) * 0.3

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu/menu_lepsze.tscn")

func _on_send_feedback_pressed() -> void:
	OS.shell_open("https://wujo-dev.itch.io/shoot-bro-loot")

func _on_gg_pressed() -> void:
	get_tree().quit()
