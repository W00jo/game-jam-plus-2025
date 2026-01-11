extends CharacterBody3D

# Signals
signal player_hit

# Constants
const SENSITIVITY = 0.1
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Export variables
@export var MAX_HP = 3
@export var WALK_SPEED = 5.0
@export var SPRINT_SPEED = 8.0
@export var JUMP_VELOCITY = 4.5

# Regular variables
var current_hp = MAX_HP
var speed: float
var t_bob = 0.0

# Onready variables
@onready var camera_controller: Node3D = $LooterHead
@onready var camera: Camera3D = $LooterHead/Camera3D
@onready var model = $Model
@onready var animation_player = $Model/AnimationPlayer

func _ready() -> void:
	speed = WALK_SPEED

func _physics_process(delta: float) -> void:
	# Controller right stick dla kamery
	var look_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var look_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	
	# Deadzone for controller drift
	if abs(look_x) < 0.15:
		look_x = 0
	if abs(look_y) < 0.15:
		look_y = 0
	
	camera_controller.rotate_y(-look_x * SENSITIVITY * 50.0 * delta)
	camera.rotate_x(-look_y * SENSITIVITY * 50.0 * delta)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump_2") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Sprint handling
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Ruch gracza w przestrzeni 3D relatywny do kamery
	var input_dir := Input.get_vector("move_left_2", "move_right_2", "move_up_2", "move_down_2")
	var direction := (camera_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Różne interpolacje dla ruchu na ziemi i w powietrzu
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
	
	# Head bobbing effect
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# Dynamiczny FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8)
	
	# Animation state machine
	if is_on_floor():
		if velocity.length() > 0.1:
			animation_player.play("Running") 
		else:
			animation_player.play("Idle")
	else:
		animation_player.play("Jump")
	
	move_and_slide()

## Called when player takes damage
func hit() -> void:
	current_hp -= 1
	print("Red got hit! HP: ", current_hp, "/", MAX_HP)
	emit_signal("player_hit")
	
	if current_hp <= 0:
		_show_fail_screen()

## Symulacja ruchu głowy podczas chodzenia
func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func _show_fail_screen() -> void:
	print("Red died!")
	get_tree().paused = true
	var fail_screen = load("res://scenes/ui/misc/fail.tscn").instantiate()
	get_tree().root.add_child(fail_screen)
