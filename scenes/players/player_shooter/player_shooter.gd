extends CharacterBody3D

# Signals
signal player_hit
signal update_ammo

# Constants
const SENSITIVITY = 0.005
const BOB_FREQ = 2.0
const BOB_AMP = 0.02
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5
const AIM_FOV = 50.0

# Export variables
@export var MAX_HP = 3
@export var WALK_SPEED = 5.0
@export var SPRINT_SPEED = 8.0
@export var JUMP_VELOCITY = 4.5
@export var HIT_STAGGER = 8.0
@export var MAX_AMMO = 4
@export var RELOAD_TIME = 2.0

# Regular variables
var current_hp = MAX_HP
var speed: float
var current_ammo = MAX_AMMO
var is_reloading = false
var t_bob = 0.0
var bullet_trail = load("res://scenes/ui/hud/bullet_trail.tscn")
var instance
var laser_sounds = [
	preload("res://assets/audio/sfx/laser_0.ogg"),
	preload("res://assets/audio/sfx/laser_1.ogg"),
	preload("res://assets/audio/sfx/laser_2.ogg"),
	preload("res://assets/audio/sfx/laser_3.ogg"),
	preload("res://assets/audio/sfx/laser_4.ogg")
]
var current_laser_index = 0

# Onready variables
@onready var camera_controller: Node3D = $ShooterHead
@onready var camera: Camera3D = $ShooterHead/Camera3D
@onready var aim_ray = $ShooterHead/Camera3D/AimRay
@onready var aim_ray_end = $ShooterHead/Camera3D/AimRayEnd
@onready var gun_anim = $ShooterHead/Gun/ShootingAnimation
@onready var gun_barrel = $ShooterHead/Gun/Meshes/Barrel
@onready var shoot_sound = $ShootSound
@onready var model = $player_shooter/Armature
@onready var animation_player = $player_shooter/AnimationPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	current_ammo = MAX_AMMO
	current_hp = MAX_HP
	speed = WALK_SPEED
	emit_signal("update_ammo", current_ammo, MAX_AMMO)

## Mouse input for camera control
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_controller.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump_1") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Sprint handling
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Ruch gracza w przestrzeni 3D relatywny do kamery
	var input_dir := Input.get_vector("move_left_1", "move_right_1", "move_up_1", "move_down_1")
	var direction := (camera_controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Model obraca się wraz z kamerą
	model.rotation.y = camera_controller.rotation.y
	
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
	
	# Dynamiczny FOV z celowaniem
	var is_aiming = Input.is_action_pressed("aim")
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	
	if is_aiming:
		target_fov = AIM_FOV
	
	camera.fov = lerp(camera.fov, target_fov, delta * 8)
	
	# Animation state machine
	if is_on_floor():
		if velocity.length() > 0.1:
			animation_player.play("Running") 
		else:
			animation_player.play("Idle")
	else:
		animation_player.play("Jump")
	
	if Input.is_action_pressed("shoot") and !is_reloading:
		_shooting()
	
	if Input.is_action_just_pressed("reload") and current_ammo < MAX_AMMO and !is_reloading:
		_reload()
	
	move_and_slide()

## Called when player takes damage
func hit() -> void:
	current_hp -= 1
	print("Green got hit! HP: ", current_hp, "/", MAX_HP)
	emit_signal("player_hit")
	
	if current_hp <= 0:
		_show_fail_screen()

## Symulacja ruchu głowy podczas chodzenia
func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

## Mechanika strzelania z cyklicznymi dźwiękami
func _shooting() -> void:
	if !gun_anim.is_playing() and current_ammo > 0:
		gun_anim.play("shoot")
		
		# Cycling laser sounds for variety
		shoot_sound.stream = laser_sounds[current_laser_index]
		shoot_sound.play()
		current_laser_index = (current_laser_index + 1) % laser_sounds.size()
		
		current_ammo -= 1
		print("Ammo: ", current_ammo, "/", MAX_AMMO)
		emit_signal("update_ammo", current_ammo, MAX_AMMO)
		
		# Raycast detection i spawning bullet trail
		instance = bullet_trail.instantiate()
		if aim_ray.is_colliding():
			var collider = aim_ray.get_collider()
			if collider and collider.is_in_group("enemy"):
				print("Zabity")
				aim_ray.get_collider().hit()
			else:
				instance.init(gun_barrel.global_position, aim_ray_end.global_position)
			get_parent().add_child(instance)
		
		if current_ammo == 0:
			_reload()

## Async reload system
func _reload() -> void:
	if is_reloading:
		return
	
	is_reloading = true
	print("Reload... (" + str(RELOAD_TIME) + " seconds)")
	await get_tree().create_timer(RELOAD_TIME).timeout
	current_ammo = MAX_AMMO
	is_reloading = false
	print("Ammo: ", current_ammo, "/", MAX_AMMO)
	emit_signal("update_ammo", current_ammo, MAX_AMMO)

func _show_fail_screen() -> void:
	print("Green died!")
	get_tree().paused = true
	var fail_screen = load("res://scenes/ui/misc/fail.tscn").instantiate()
	get_tree().root.add_child(fail_screen)
