extends Area3D

@export var damage := 1

signal body_part_hit

func hit():
	# Emit signal for gostek to handle via signal connection
	emit_signal("body_part_hit", damage)
	
	# Also trigger hitmarker directly
	GameManager.emit_signal("enemy_hit")
	
	# Handle damage directly here since signal connections aren't working
	if owner:
		# Try to access health directly
		if "health" in owner:
			owner.health -= damage
			if owner.health <= 0:
				GameManager.record_enemy_kill()
				owner.queue_free()
		else:
			# Try calling the method anyway
			owner._on_area_3d_body_part_hit(damage)
