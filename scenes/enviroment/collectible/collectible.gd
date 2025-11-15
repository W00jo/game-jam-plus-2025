extends Area3D

func _process(_delta):
	rotate_y(0.01)
	#rotate_z(0.01)

func _on_body_entered(_CharacterBody3D):
	$CollectSound.play()
	$CollisionMesh.queue_free()
	print("działa")

func _on_sound_finish(): queue_free()
