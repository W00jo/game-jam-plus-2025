extends CharacterBody3D

var player = null
var state_machine
var health = 1

signal zombie_hit

const SPEED = 4.0
const ATTACK_RANGE = 2.5
var can_attack = true

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
#@onready var anim_tree = $AnimationTree

func _ready():
	player = get_node(player_path)
	#state_machine = 

func _process(_delta):
	velocity = Vector3.ZERO
	
	if player == null:
		return
	
	#match state_machine.get_current_node():
		#"Run"
			# Navigation
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		#"Attack"
			#look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	# Conditions
	#anim_tree.set("parameters", _target_in_range())
	#anim_tree.set("parameters", !_target_in_range())
	
	#anim_tree.get("parameters")
	
	if _target_in_range() and can_attack:
		_hit_finished()
		can_attack = false
		get_tree().create_timer(1.5).timeout.connect(func(): can_attack = true)
	
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		# The 'hit' function in player_2.gd takes no arguments.
		player.hit()

func _on_area_3d_body_part_hit(dam):
	health -= dam
	emit_signal("zombie_hit")
