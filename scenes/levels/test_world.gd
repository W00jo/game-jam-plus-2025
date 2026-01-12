extends Node3D

## Level controller - handles connections between NPCs

func _ready() -> void:
	# Start game session for high-score tracking
	GameManager.start_game_session()
	GameManager.reset_collectibles()
	
	# Connect all citizens to stalker speed increase
	var stalker = $NavigationRegion3D/Stalker
	var citizen = $NavigationRegion3D/Citizen
	
	if stalker and citizen:
		citizen.citizen_killed.connect(stalker.increase_speed)
		print("Citizen-Stalker connection established")
