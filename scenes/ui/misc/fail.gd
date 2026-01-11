extends Control

@onready var death_sound = $DeathSound

func _ready():
	$MainContainer/VBoxContainer/Retry.pressed.connect(_on_retry_pressed)
	$MainContainer/VBoxContainer/MainMenu.pressed.connect(_on_main_menu_pressed)
	$MainContainer/VBoxContainer/ImDone.pressed.connect(_on_im_done_pressed)
	
	ButtonSoundManager.connect_buttons_in_tree(self)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Play death sound on loop
	death_sound.play()

func _on_retry_pressed():
	death_sound.stop()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	death_sound.stop()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/menu/menu_lepsze.tscn")

func _on_im_done_pressed():
	get_tree().quit()
