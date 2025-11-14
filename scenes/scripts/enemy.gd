extends CharacterBody3D

## Simple enemy that can be shot by the sniper

@export var max_health: int = 100
@export var move_speed: float = 2.0
@export var patrol_radius: float = 5.0

var current_health: int = 100
var initial_position: Vector3
var patrol_time: float = 0.0

func _ready() -> void:
	current_health = max_health
	initial_position = global_position
	collision_layer = 8  # Enemies layer
	collision_mask = 1  # World layer

func _physics_process(delta: float) -> void:
	# Simple patrol behavior
	patrol_time += delta
	var offset := Vector3(
		sin(patrol_time) * patrol_radius,
		0,
		cos(patrol_time) * patrol_radius
	)
	
	var target_position := initial_position + offset
	var direction := (target_position - global_position).normalized()
	
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	velocity.y -= 9.8 * delta  # Gravity
	
	move_and_slide()

func take_damage(amount: int) -> void:
	current_health -= amount
	print("Enemy took ", amount, " damage. Health: ", current_health, "/", max_health)
	
	if current_health <= 0:
		die()

func die() -> void:
	print("Enemy defeated!")
	queue_free()
