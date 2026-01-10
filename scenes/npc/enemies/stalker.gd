extends CharacterBody3D

signal enemy_hit

const STUNNED_SPEED = 0.0
const STUN_DURATION = 3.0
const ATTACK_RANGE = 2.0
const ATTACK_COOLDOWN = 2.0

@export var player_path : NodePath
@export var speed = 1.5

var player = null
var is_stunned = false
var can_attack = true
var material : StandardMaterial3D

@onready var nav_agent = $NavigationAgent3D
@onready var stalker_model = $StalkerModel
@onready var stun_timer = Timer.new()

func _ready() -> void:
	# Pamiętać o ustawieniu odpowiedniego gracza w inspektorze!!
	player = get_node(player_path)
	
	# Stun timer
	add_child(stun_timer)
	stun_timer.one_shot = true
	stun_timer.timeout.connect(_on_stun_timeout)
	
	# Potrzebne do zmiany koloru na stuna
	material = stalker_model.get_surface_override_material(0)
	
func _process(_delta: float) -> void:
	if player == null:
		return
	
	# Stun = stun
	if is_stunned:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * speed
	
	var look_target = Vector3(player.global_position.x, global_position.y, player.global_position.z)
	look_at(look_target, Vector3.UP)
	
	# Check if in attack range
	if _target_in_range() and can_attack:
		_attack_player()
	
	move_and_slide()
	
func _target_in_range() -> bool:
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func _attack_player():
	if player == null or is_stunned:
		return
	
	# Visual feedback
	_flash_attack()
	
	# Deal damage to player
	if player.has_method("hit"):
		player.hit()
	
	# Set attack cooldown
	can_attack = false
	get_tree().create_timer(ATTACK_COOLDOWN).timeout.connect(func(): can_attack = true)
	
func _flash_attack():
	# Attakc visual feedback
	material.albedo_color = Color(1.0, 1.0, 1.0, 1.0)
	await get_tree().create_timer(0.2).timeout
	material.albedo_color = Color(1.0, 0.45882353, 1.0, 1.0)  # Back to original magenta
	
## Stun mechanic
func stun():
	# Stun visual feedback
	if is_stunned:
		return
	
	is_stunned = true
	can_attack = false
	
	material.albedo_color = Color(0.5, 0.2, 0.5, 1.0)
	
	stun_timer.start(STUN_DURATION)
	
	print("Stun!")
	
## Stun timeout
func _on_stun_timeout():
	is_stunned = false
	can_attack = true
	
	material.albedo_color = Color(1.0, 0.45882353, 1.0, 1.0)
	
	print("Gonitwa!")
	
func hit():
	emit_signal("enemy_hit")
	stun()
