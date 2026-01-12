extends Node

var click_sounds = [
	preload("res://assets/audio/sfx/click_0.ogg"),
	preload("res://assets/audio/sfx/click_1.ogg"),
	preload("res://assets/audio/sfx/click_2.mp3")
]

var return_sound = preload("res://assets/audio/sfx/return.ogg")

@onready var audio_player = $AudioPlayer

func play_click_sound():
	var random_click = click_sounds[randi() % click_sounds.size()]
	audio_player.stream = random_click
	audio_player.volume_db = linear_to_db(GameManager.sfx_volume)
	audio_player.play()

func play_return_sound():
	audio_player.stream = return_sound
	audio_player.volume_db = linear_to_db(GameManager.sfx_volume)
	audio_player.play()

func connect_buttons_in_tree(node: Node):
	if node is Button:
		if node.text == "x" or node.name.to_lower().contains("return") or node.name == "Return":
			if not node.pressed.is_connected(_on_return_button_pressed):
				node.pressed.connect(_on_return_button_pressed)
		else:
			if not node.pressed.is_connected(_on_button_pressed):
				node.pressed.connect(_on_button_pressed)
	
	for child in node.get_children():
		connect_buttons_in_tree(child)
	
func _on_button_pressed():
	play_click_sound()
	
func _on_return_button_pressed():
	play_return_sound()
