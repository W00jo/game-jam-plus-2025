extends MeshInstance3D

func _ready() -> void:
	pass # Replace with function body.

func init(pos1, pos2):
	var draw_mesh = ImmediateMesh.new()
	mesh = draw_mesh
	draw_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material_override)
	draw_mesh.surface_add_vertex(pos1)
	draw_mesh.surface_add_vertex(pos2)
	draw_mesh.surface_end()

func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	queue_free()
