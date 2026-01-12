extends Control

var pause_toggle = false

func _ready() -> void:
	self.visible = false
	ButtonSoundManager.connect_buttons_in_tree(self)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		print("dziala")
		pause_and_unpause()

func pause_and_unpause():
	pause_toggle = !pause_toggle
	get_tree().paused = pause_toggle
	self.visible = pause_toggle
	
	if pause_toggle:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_pressed() -> void:
	get_tree().paused = false
	self.visible = false
	pause_toggle = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_restart_pressed() -> void:
	get_tree().paused = false
	pause_toggle = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/ui/menu/menu_lepsze.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
