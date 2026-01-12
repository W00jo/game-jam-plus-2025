extends Area3D

# Ambient sounds to play when near enemies
var ambient_sounds = [
	preload("res://assets/audio/sfx/ambient_1.mp3"),
	preload("res://assets/audio/sfx/ambient_2.mp3")
]

var has_played_sound = false

@onready var sound_player = $AudioStreamPlayer

func _ready() -> void:
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and not has_played_sound:
		has_played_sound = true
		
		# Pick random ambient sound
		var random_ambient = ambient_sounds[randi() % ambient_sounds.size()]
		sound_player.stream = random_ambient
		sound_player.volume_db = -8.0 + linear_to_db(GameManager.sfx_volume)
		sound_player.play()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		# Check if there are still enemies nearby
		var enemies_nearby = false
		for overlapping_body in get_overlapping_bodies():
			if overlapping_body.is_in_group("enemy"):
				enemies_nearby = true
				break
		
		# Reset the flag when all enemies leave
		if not enemies_nearby:
			has_played_sound = false
