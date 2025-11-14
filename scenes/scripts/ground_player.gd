extends CharacterBody3D

## Ground player controller for Player 1

const SPEED := 5.0
const SPRINT_SPEED := 8.0
const JUMP_VELOCITY := 4.5
const MOUSE_SENSITIVITY := 0.002

@export var camera_path: NodePath
@onready var camera: Camera3D = get_node_or_null(camera_path) if camera_path else null

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	# Find camera if not set
	if not camera:
		camera = get_node_or_null("Camera3D")
	
func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Get input direction
	var input_dir := Vector2.ZERO
	input_dir.x = Input.get_action_strength("p1_move_right") - Input.get_action_strength("p1_move_left")
	input_dir.y = Input.get_action_strength("p1_move_backward") - Input.get_action_strength("p1_move_forward")
	
	# Calculate movement direction relative to camera
	var direction := Vector3.ZERO
	if camera:
		var camera_basis := camera.global_transform.basis
		direction = (camera_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	else:
		direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	# Apply movement
	var current_speed := SPRINT_SPEED if Input.is_action_pressed("p1_sprint") else SPEED
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	# Handle interaction
	if event.is_action_pressed("p1_interact"):
		interact()

func interact() -> void:
	# Check for nearby interactable objects
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(
		global_position + Vector3.UP,
		global_position + Vector3.UP + global_transform.basis.z * -2.0
	)
	query.collision_mask = 4  # Objectives layer
	
	var result := space_state.intersect_ray(query)
	if result:
		var collider := result.get("collider")
		if collider and collider.has_method("interact"):
			collider.interact()
