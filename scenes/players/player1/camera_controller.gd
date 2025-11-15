extends Node3D

@export var sensitivity := 0.002
var yaw := 0.0
var pitch := 0.0

@onready var player := $".."   # CharacterBody3D

func _ready() -> void: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))
		# pivot (kamera) — pitch góra/dół
		rotation.x = pitch
		# postać — yaw prawo/lewo
		player.rotation.y = yaw
