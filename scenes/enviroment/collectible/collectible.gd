extends Area3D

var is_collected := false

func _process(_delta):
	rotate_y(0.01)

func _on_body_entered(body: Node3D):
	if not is_collected and body is CharacterBody3D:
		is_collected = true
		$CollectSound.play()
		$CollisionShape.set_deferred("disabled", true)
		$CollisionMesh.visible = false
		print("działa")

func _on_sound_finish(): queue_free()
