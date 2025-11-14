extends Camera3D

## Sniper camera controller for Player 2 - top-down view with mouse aiming

const CAMERA_HEIGHT := 20.0
const MOVE_SPEED := 10.0
const ZOOM_SPEED := 2.0
const MIN_FOV := 30.0
const MAX_FOV := 90.0

@export var follow_target: NodePath
@export var crosshair_scene: PackedScene

var target: Node3D = null
var mouse_position_3d := Vector3.ZERO
var current_fov := 75.0

func _ready() -> void:
	# Set initial camera settings
	current_fov = fov
	
	# Find target if path is set
	if follow_target:
		target = get_node_or_null(follow_target)
	
	# Position camera above the world
	position.y = CAMERA_HEIGHT
	rotation_degrees.x = -90  # Look straight down

func _process(delta: float) -> void:
	# Follow target if set
	if target:
		var target_pos := target.global_position
		global_position.x = lerp(global_position.x, target_pos.x, delta * 5.0)
		global_position.z = lerp(global_position.z, target_pos.z, delta * 5.0)
	
	# Handle zoom
	if Input.is_action_pressed("p2_zoom_in"):
		current_fov = max(current_fov - ZOOM_SPEED * delta * 60.0, MIN_FOV)
	if Input.is_action_pressed("p2_zoom_out"):
		current_fov = min(current_fov + ZOOM_SPEED * delta * 60.0, MAX_FOV)
	
	fov = current_fov
	
	# Update mouse world position for aiming
	update_mouse_world_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("p2_shoot"):
		shoot()

func update_mouse_world_position() -> void:
	# Cast ray from camera through mouse to find world position
	var viewport := get_viewport()
	if not viewport:
		return
	
	var mouse_pos := viewport.get_mouse_position()
	var from := project_ray_origin(mouse_pos)
	var to := from + project_ray_normal(mouse_pos) * 1000.0
	
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 1  # World layer
	
	var result := space_state.intersect_ray(query)
	if result:
		mouse_position_3d = result.get("position", Vector3.ZERO)

func shoot() -> void:
	print("Sniper shot fired at: ", mouse_position_3d)
	
	# Check if we hit an enemy or target
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsShapeQueryParameters3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 0.5
	query.shape = shape
	query.transform = Transform3D(Basis(), mouse_position_3d)
	query.collision_mask = 8  # Enemies layer
	
	var results := space_state.intersect_shape(query)
	if results.size() > 0:
		for result in results:
			var collider := result.get("collider")
			if collider and collider.has_method("take_damage"):
				collider.take_damage(100)
				GameManager.add_sniper_score(10)
				print("Enemy hit!")

func get_aim_position() -> Vector3:
	return mouse_position_3d
