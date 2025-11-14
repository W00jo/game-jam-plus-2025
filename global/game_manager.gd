extends Node

## Global game manager for managing game state, scores, and player data

signal objective_completed(objective_id: String)
signal item_collected(item_id: String)

var player1_score: int = 0
var player2_score: int = 0
var objectives_completed: Array[String] = []
var items_collected: Array[String] = []

func _ready() -> void:
	print("GameManager initialized")

func complete_objective(objective_id: String) -> void:
	if objective_id not in objectives_completed:
		objectives_completed.append(objective_id)
		player1_score += 100
		objective_completed.emit(objective_id)
		print("Objective completed: ", objective_id)

func collect_item(item_id: String) -> void:
	if item_id not in items_collected:
		items_collected.append(item_id)
		player1_score += 50
		item_collected.emit(item_id)
		print("Item collected: ", item_id)

func add_sniper_score(points: int) -> void:
	player2_score += points
	print("Sniper score: +", points)

func reset_game() -> void:
	player1_score = 0
	player2_score = 0
	objectives_completed.clear()
	items_collected.clear()
	print("Game reset")