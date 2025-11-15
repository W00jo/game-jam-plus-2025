extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		print("Wysadziło Cię!")
		# Nie można reload używać, bezpośrednio, tylko `call_deffered`.
		get_tree().call_deferred("reload_current_scene")
