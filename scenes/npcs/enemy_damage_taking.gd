extends Area3D

@export var damage := 1

signal body_part_hit

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	pass

func hit():
	emit_signal("body_part_hit", damage)
