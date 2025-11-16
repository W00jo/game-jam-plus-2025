extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.1
#const HIT_STAGGER = 8.0

# Ruch głową... w ruchu i skoku
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

# FOV
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Signal
signal player_hit

# Camera
@onready var camera_controller: Node3D = $CameraController
@onready var camera: Camera3D = $CameraController/Camera3D

func _physics_process(delta: float) -> void:
	# Right stick look
	var look_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var look_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	# Deadzone
	if abs(look_x) < 0.15:
		look_x = 0
	if abs(look_y) < 0.15:
		look_y = 0
	camera_controller.rotate_y(-look_x * SENSITIVITY * 50.0 * delta)
	camera.rotate_x(-look_y * SENSITIVITY * 50.0 * delta)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump_2") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#Sprint
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left_2", "move_right_2", "move_up_2", "move_down_2")
	var direction := (camera_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x,direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z,direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x,direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z,direction.z * speed, delta * 2.0)
	#Skakanie głowy
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED *2)
	var target_fov = BASE_FOV + FOV_CHANGE *velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8)
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y =sin(time * BOB_FREQ) * BOB_AMP 
	pos.x =cos(time * BOB_FREQ/2) * BOB_AMP
	return pos

func hit():
	emit_signal("player_hit")
	#velocity += dir * HIT_STAGGER
