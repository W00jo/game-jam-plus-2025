extends CanvasLayer

@export var loot_collected = 0

func _ready():
	$LootIndicator.text = "Loot: " + str(loot_collected)

func _on_collectible_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		loot_collected += 1
		$LootIndicator.text = "Loot: " + str(loot_collected)
