extends StaticBody3D

## Interactable objective or item for the ground player to collect

@export var objective_id: String = "objective_1"
@export var is_objective: bool = true  # true for objectives, false for items

func _ready() -> void:
	# Set collision layer
	collision_layer = 4  # Objectives layer
	collision_mask = 0

func interact() -> void:
	if is_objective:
		GameManager.complete_objective(objective_id)
	else:
		GameManager.collect_item(objective_id)
	
	# Visual feedback
	print("Interacted with: ", objective_id)
	
	# Remove the object after collection
	queue_free()
