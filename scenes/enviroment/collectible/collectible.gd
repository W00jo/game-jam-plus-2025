extends Area3D

@export var float_speed: float = 2.0
@export var float_amplitude: float = 0.1

var is_collected := false
var time_passed: float = 0.0
var initial_y: float

func _ready():
	initial_y = position.y

func _process(delta):
	rotate_y(0.01)
	
	time_passed += delta
	
	position.y = initial_y + sin(time_passed * float_speed) * float_amplitude

func _on_body_entered(body: Node3D):
	if not is_collected and body is CharacterBody3D:
		is_collected = true
		$CollectSound.play()
		$CollisionShape.set_deferred("disabled", true)
		$CollisionMesh.visible = false
		print("działa")

func _on_sound_finish(): queue_free()
