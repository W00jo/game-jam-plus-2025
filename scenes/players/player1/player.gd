extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005
# Częstotliwość skakania głowy
const BOB_FREQ = 2.0
# Wysokość skoku głowy
const BOB_AMP = 0.08
var t_bob = 0.0

# fov zmienne
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Camera
@onready var aim_ray = $CameraController/RayCast3D
@onready var camera_controller: Node3D = $CameraController
@onready var camera: Camera3D = $CameraController/Camera3D
# Model's root node references
@onready var model = $player_shooter
@onready var animation_player = $player_shooter/AnimationPlayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		camera_controller.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x =clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump_1") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#Sprint
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left_1", "move_right_1", "move_up_1", "move_down_1")
	var direction := (camera_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	model.rotation.y = camera_controller.rotation.y
	
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
	
	# Odpalanie się animacji
	if is_on_floor():
		if velocity.length() > 0.1:
			animation_player.play("Run") 
		else:
			animation_player.play("Idle")
	else:
		animation_player.play("Jump")
	
	# Shooting
	if Input.is_action_pressed("shoot"):
		if !gun_anim.is_playing():
			gun
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y =sin(time * BOB_FREQ) * BOB_AMP 
	pos.x =cos(time * BOB_FREQ/2) * BOB_AMP
	return pos

func _shoot_sniper():
	if aim_ray.is_colliding():
		if aim_ray.get_collider().is_in_group("enemy"):
			aim_ray.get_collider().hit()
