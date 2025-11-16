extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 10.0
const SENSITIVITY = 0.005
const HIT_STAGGER = 8.0

# Ruch głową... w ruchu i skoku
const BOB_FREQ = 2.0
const BOB_AMP = 0.02
var t_bob = 0.0

# zmienne FOV
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

signal player_hit

# Bullets
var bullet_trail = load("res://scenes/ui/hud/bullet_trail.tscn")
var instance

# Camera
@onready var camera_controller: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var aim_ray = $Head/Camera3D/AimRay
@onready var aim_ray_end = $Head/Camera3D/AimRayEnd

# Gun
@onready var rifle_anim = $Head/Gun/ShootingAnimation
@onready var rifle_barrel = $Head/Gun/Meshes/Barrel

# Model's root node references
@onready var model = $player_shooter/Armature
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
			animation_player.play("Running") 
		else:
			animation_player.play("Idle")
	else:
		animation_player.play("Jump")
	
	# Shooting
	if Input.is_action_pressed("shoot"):
		_shooting()
		if !rifle_anim.is_playing():
			rifle_anim.play("shoot")
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y =sin(time * BOB_FREQ) * BOB_AMP 
	pos.x =cos(time * BOB_FREQ/2) * BOB_AMP
	return pos

func hit():
	emit_signal("player_hit")

func _shooting():
	if !rifle_anim.is_playing():
		rifle_anim.play("shoot")
		instance = bullet_trail.instantiate()
		if aim_ray.is_colliding():
			var collider = aim_ray.get_collider()
			if collider and collider.is_in_group("enemy"):
				print("zabity")
				aim_ray.get_collider().hit()
			else:
				instance.init(rifle_barrel.global_position, aim_ray_end.global_position)
			get_parent().add_child(instance)
