extends Area3D

@export var damage := 1

signal body_part_hit

func hit():
	# Emit signal for gostek to handle via signal connection
	emit_signal("body_part_hit", damage)
	
	# Also trigger hitmarker and tracking directly since player_shooter calls this
	GameManager.emit_signal("enemy_hit")
