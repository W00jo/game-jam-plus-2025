extends CharacterBody3D

@onready var npc_animation: Node3D = $NPCAnimation
@onready var animation_player: AnimationPlayer = $NPCAnimation/AnimationPlayer

func _ready() -> void:
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Plays the idle animation.
	if is_on_floor() and animation_player.current_animation != "IdleNPC":
		animation_player.play("IdleNPC")
		
	move_and_slide()
