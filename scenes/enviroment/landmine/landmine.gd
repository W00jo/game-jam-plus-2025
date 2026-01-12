extends Area3D

@onready var explosion_sound = $ExplosionSound

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		print("Wysadziło Cię!")
		explosion_sound.play()
		# Wait for sound to finish before reloading
		await explosion_sound.finished
		# Nie można używać reload sceny bezpośrednio, tylko `call_deffered`.
		get_tree().call_deferred("reload_current_scene")
