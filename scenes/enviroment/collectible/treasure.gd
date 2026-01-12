extends Area3D

@export var float_speed: float = 2.0
@export var float_amplitude: float = 0.2
@export var rotation_speed: float = 0.02

var is_collected := false
var time_passed: float = 0.0
var initial_y: float

func _ready():
	initial_y = position.y

func _process(delta):
	# Rotate the treasure
	rotate_y(rotation_speed)
	
	# Float animation
	time_passed += delta
	position.y = initial_y + sin(time_passed * float_speed) * float_amplitude

func _on_body_entered(body: Node3D):
	if not is_collected and body is CharacterBody3D and body.is_in_group("player"):
		is_collected = true
		$AudioStreamPlayer.play()
		$TreasureCollisionShape.set_deferred("disabled", true)
		$TreasureModel.visible = false
		
		# Track treasure collection for high-score (bonus, not required to win)
		GameManager.record_treasure_collected()
		
		# Optional: Also count as regular collectible if you want
		# GameManager.collect_item()

func _on_sound_finish():
	queue_free()
