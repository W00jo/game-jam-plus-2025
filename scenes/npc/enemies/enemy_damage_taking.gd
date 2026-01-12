extends Area3D

@export var damage := 1

signal body_part_hit

func hit():
	# Emit signal for gostek to handle via signal connection
	emit_signal("body_part_hit", damage)
	
	# Also trigger hitmarker directly
	GameManager.emit_signal("enemy_hit")
	
	# Handle damage directly here since signal connections aren't working
	print("DEBUG: Calling owner (", owner.name, ")._on_area_3d_body_part_hit(", damage, ")")
	if owner:
		# Try to access health directly
		if "health" in owner:
			print("DEBUG: Owner health before = ", owner.health)
			owner.health -= damage
			print("DEBUG: Owner health after = ", owner.health)
			if owner.health <= 0:
				print("DEBUG: Owner health <= 0, recording kill")
				GameManager.record_enemy_kill()
				owner.queue_free()
		else:
			print("ERROR: Owner doesn't have health property!")
			# Try calling the method anyway
			owner._on_area_3d_body_part_hit(damage)
		print("DEBUG: Call completed")
	else:
		print("ERROR: No owner!")
