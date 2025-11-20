extends CharacterBody3D

var player = null
var state_machine
var health = 1
var is_active = false

signal enemy_hit

const SPEED = 4.0
const ATTACK_RANGE = 1.25
var can_attack = true

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	anim_tree.active = true

func _process(_delta):
	anim_tree.set("parameters/conditions/walk", is_active)
	
	if not is_active:
		return
	
	velocity = Vector3.ZERO
	
	if player == null:
		return
	
	match state_machine.get_current_node():
		# Walking animation
		"Walk":
			# Navigation towards player
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			look_at(Vector3(global_position.x + velocity.x, global_position.y,
							global_position.z + velocity.z), Vector3.UP)
		# Attacking player animation
		"Scream":
			look_at(Vector3(player.global_position.x, global_position.y,
							player.global_position.z), Vector3.UP)
	
	# Warunki odpalania się animacji
	anim_tree.set("parameters/conditions/scream", _target_in_range())
	#anim_tree.set("parameters/conditions/walk", !_target_in_range())
	
	if _target_in_range() and can_attack:
		_hit_finished()
		can_attack = false
		get_tree().create_timer(1.5).timeout.connect(func(): can_attack = true)
	
	move_and_slide()

func _on_detection_zone_body_entered(body: Node3D):
	if body.is_in_group("player") and not is_active:
		print("Player detected!")
		is_active = true

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		player.hit()

func _on_area_3d_body_part_hit(dam):
	health -= dam
	emit_signal("enemy_hit")
	if health <= 0:
		queue_free()
