extends Control

@onready var godot_head = $GodotHead3D/SubViewport/Head
@onready var sub_label = $MainContainer/ContentVBox/SubLabel
var time_passed = 0.0
var score_data: Dictionary

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ButtonSoundManager.connect_buttons_in_tree(self)
	
	# Calculate and display high-score
	score_data = GameManager.calculate_high_score()
	_display_score()

func _display_score() -> void:
	var time_minutes = int(score_data["time_taken"]) / 60
	var time_seconds = int(score_data["time_taken"]) % 60
	
	var score_text = "HIGH-SCORE: %d\n" % score_data["final_score"]
	score_text += "Time: %d:%02d | Enemies: %d | Treasures: %d\n" % [
		time_minutes,
		time_seconds,
		score_data["enemies_killed"],
		score_data["treasures_collected"]
	]
	
	# Show penalties if any
	if score_data["citizens_shot"] > 0 or score_data["player_hits_taken"] > 0:
		score_text += "Citizens Shot: %d | Damage Taken: %d" % [
			score_data["citizens_shot"],
			score_data["player_hits_taken"]
		]
	
	sub_label.text = score_text

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
