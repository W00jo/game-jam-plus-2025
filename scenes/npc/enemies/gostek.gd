extends CharacterBody3D

# Signals
signal enemy_hit

# Constants
const SPEED = 4.0
const ATTACK_RANGE = 1.25

# Export variables
@export var player_path: NodePath

# Regular variables
var player = null
var state_machine
var health = 1
var is_active = false
var can_attack = true

# Onready variables
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

func _ready() -> void:
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	anim_tree.active = true

func _process(_delta: float) -> void:
	anim_tree.set("parameters/conditions/walk", is_active)
	
	if not is_active:
		return
	
	velocity = Vector3.ZERO
	
	if player == null:
		return
	
	# Animation state machine control
	match state_machine.get_current_node():
		"Walk":
			# Navigation AI - ściganie gracza
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			look_at(Vector3(global_position.x + velocity.x, global_position.y,
							global_position.z + velocity.z), Vector3.UP)
		"Scream":
			# Patrzy na gracza podczas ataku
			look_at(Vector3(player.global_position.x, global_position.y,
							player.global_position.z), Vector3.UP)
	
	# Warunki odpalania się animacji
	anim_tree.set("parameters/conditions/scream", _target_in_range())
	
	if _target_in_range() and can_attack:
		_hit_finished()
		can_attack = false
		get_tree().create_timer(1.5).timeout.connect(func(): can_attack = true)
	
	move_and_slide()

func _on_detection_zone_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not is_active:
		print("Player detected!")
		is_active = true

func _target_in_range() -> bool:
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _hit_finished() -> void:
	# Zadawanie obrażeń graczowi po animacji ataku
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		player.hit()

## Called when enemy takes damage
func _on_area_3d_body_part_hit(dam: int) -> void:
	health -= dam
	emit_signal("enemy_hit")
	if health <= 0:
		queue_free()
