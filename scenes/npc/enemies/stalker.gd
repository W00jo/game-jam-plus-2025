extends CharacterBody3D

# Signals
signal enemy_hit

# Constants
const STUNNED_SPEED = 0.0
const STUN_DURATION = 3.0
const ATTACK_RANGE = 2.0
const ATTACK_COOLDOWN = 2.0
const SPEED_INCREASE_PER_KILL = 0.3

# Export variables
@export var player_path: NodePath
@export var speed = 1.5

# Regular variables
var player = null
var is_stunned = false
var can_attack = true
var material: StandardMaterial3D

# Onready variables
@onready var nav_agent = $NavigationAgent3D
@onready var stalker_model = $StalkerModel
@onready var stun_timer = Timer.new()

func _ready() -> void:
	# Pamiętać o ustawieniu odpowiedniego gracza w inspektorze!!
	player = get_node(player_path)
	
	# Stun timer setup
	add_child(stun_timer)
	stun_timer.one_shot = true
	stun_timer.timeout.connect(_on_stun_timeout)
	
	# Material reference for color changes during stun
	material = stalker_model.get_surface_override_material(0)

func _process(_delta: float) -> void:
	if player == null:
		return
	
	# Zatrzymanie podczas stunu
	if is_stunned:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	# Navigation AI - ściganie gracza
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * speed
	
	# Zawsze patrzy na gracza
	var look_target = Vector3(player.global_position.x, global_position.y, player.global_position.z)
	look_at(look_target, Vector3.UP)
	
	if _target_in_range() and can_attack:
		_attack_player()
	
	move_and_slide()

func _target_in_range() -> bool:
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _attack_player() -> void:
	if player == null or is_stunned:
		return
	
	_flash_attack()
	
	# Zadawanie obrażeń graczowi
	if player.has_method("hit"):
		player.hit()
	
	# Attack cooldown
	can_attack = false
	get_tree().create_timer(ATTACK_COOLDOWN).timeout.connect(func(): can_attack = true)
	
func _flash_attack() -> void:
	# Visual feedback przy ataku
	material.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
	await get_tree().create_timer(0.2).timeout
	material.albedo_color = Color(1.0, 0.45882353, 1.0, 1.0)  # Back to magenta

## Mechanika stunu - zatrzymuje przeciwnika na czas
func stun() -> void:
	if is_stunned:
		return
	
	is_stunned = true
	can_attack = false
	
	# Visual feedback - ciemniejszy kolor
	material.albedo_color = Color(0.5, 0.2, 0.5, 1.0)
	
	stun_timer.start(STUN_DURATION)
	print("Stun!")

## Wybudzenie ze stunu
func _on_stun_timeout() -> void:
	is_stunned = false
	can_attack = true
	
	# Powrót do normalnego koloru
	material.albedo_color = Color(1.0, 0.45882353, 1.0, 1.0)
	print("Gonitwa!")

## Called when enemy takes damage
func hit() -> void:
	emit_signal("enemy_hit")
	GameManager.emit_signal("enemy_hit")  # Trigger hitmarker immediately
	stun()

## Zwiększenie prędkości po zabiciu citizena
func increase_speed() -> void:
	speed += SPEED_INCREASE_PER_KILL
	print("Stalker speed increased to: ", speed)
	# Visual feedback - czerwonawy kolor
	material.albedo_color = Color(1.0, 0.3, 0.5, 1.0)
