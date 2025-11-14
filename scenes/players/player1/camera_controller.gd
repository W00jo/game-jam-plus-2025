extends Node3D

@onready var player: CharacterBody3D = $".."
var input_rotation: Vector3
var mouse_input: Vector2
var mouse_sensivity: float = 0.005  #sensivity myszki

var use_interpolation : bool = false
var circle_strafe : bool = true
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player = get_parent()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_input.x += -event.screen_relative.x * mouse_sensivity
		mouse_input.y += -event.screen_relative.y * mouse_sensivity

func _process(delta: float) -> void:
	input_rotation.x =clampf(input_rotation.x + mouse_input.y, deg_to_rad(-90),deg_to_rad(85))
	input_rotation.y +=mouse_input.x
	
	#obrót kamery góra dół
	player.camera_controller_anchor.transform.basis = Basis.from_euler(Vector3(input_rotation.x, 0.0, 0.0))
	
	#obrót kamery lewo prawo
	player.global_transform.basis = Basis.from_euler(Vector3(0.0,input_rotation.y,0.0))
	global_transform = player.camera_controller_anchor.get_global_transform_interpolated()
	mouse_input = Vector2.ZERO
