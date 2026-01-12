extends AudioStreamPlayer

@export var fade_in_duration: float = 3.0
@export var start_volume_db: float = -40.0

func _ready():
	volume_db = start_volume_db
	play()
	
	# Fade to music volume setting
	var target_volume_db = linear_to_db(GameManager.music_volume)
	var tween = create_tween()
	tween.tween_property(self, "volume_db", target_volume_db, fade_in_duration)
