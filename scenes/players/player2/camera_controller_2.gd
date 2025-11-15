extends Node3D

@onready var player_2: CharacterBody3D = $".."

@export var sensitivity := 1.5
var yaw := 0.0
var pitch := 0.0

func _process(delta):
	var look_x = Input.get_action_strength("look_right_2") - Input.get_action_strength("look_left_2")
	var look_y = Input.get_action_strength("look_down_2") - Input.get_action_strength("look_up_2")

	yaw -= look_x * sensitivity * delta
	pitch -= look_y * sensitivity * delta
	pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))

	# Kamera pivot obraca się tylko góra/dół
	rotation.x = pitch

	# Postać obraca się lewo/prawo
	player_2.rotation.y = yaw
