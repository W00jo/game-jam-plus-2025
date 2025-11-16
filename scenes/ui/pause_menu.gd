extends Control

var pause_toogle = false

func _ready() -> void:
	self.visible = false
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		print("dziala")
		pause_and_unpause()
		
func pause_and_unpause():
	pause_toogle = !pause_toogle
	get_tree().paused = pause_toogle
	self.visible = pause_toogle



func _on_exit_pressed() -> void:
	get_tree().quit()
