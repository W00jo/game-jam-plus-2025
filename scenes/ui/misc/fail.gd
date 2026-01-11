extends Control

func _ready():
	# Connect button signals
	$VBoxContainer/Retry.pressed.connect(_on_retry_pressed)
	$VBoxContainer/MainMenu.pressed.connect(_on_main_menu_pressed)
	$VBoxContainer/ImDone.pressed.connect(_on_im_done_pressed)
	
	# Show mouse cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_retry_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/menu/menu_lepsze.tscn")

func _on_im_done_pressed():
	get_tree().quit()
