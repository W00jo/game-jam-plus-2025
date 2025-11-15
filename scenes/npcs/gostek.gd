extends CharacterBody3D

var player = null
var state_machine
var health = 1

signal zombie_hit

const SPEED = 4.0
const ATTACK_RANGE = 2.5

@export var player_path : NodePath

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree

func _ready():
	player = get_node(player_path)

func _process(_delta):
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	move_and_slide()

func _on_area_3d_body_part_hit(dam):
	health -= dam
	emit_signal("zombie_hit")
