extends CharacterBody3D

@onready var npc_animation: Node3D = $NPCAnimation
@onready var animation_player: AnimationPlayer = $NPCAnimation/AnimationPlayer
const SPEED : int = 1
var gate : bool = true
func _ready() -> void:
	pass

func _physics_process(_delta):
		# Plays the idle animation.
	if is_on_floor() and animation_player.current_animation != "IdleNPC":
		animation_player.play("IdleNPC")
	move_and_slide()
	
	if gate == true:
		wander()
		print("chodze se")
		gate = false
	else:
		pass

func wander():
	var rand_x : float = randf_range(-1,1)#Randomowy kierunek.x
	var rand_z : float = randf_range(-1,1)#Randomowy kierunek.y
												 #randomowa prędkość
	velocity = Vector3(rand_x, 0, rand_z) * SPEED * randf_range(0.5,0.8)
	$WanderTimer.wait_time = randi_range(2,5) #Losowy czas po którym zmieni kierunek
	$WanderTimer.start()
	look_at(Vector3(rand_x,0,rand_z) * -360)
	
func _on_wander_timer_timeout() -> void:
	gate = true
