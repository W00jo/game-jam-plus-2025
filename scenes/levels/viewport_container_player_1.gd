extends SubViewportContainer

# In Godot 4, you just need to define the function; no need to enable it in _ready().
func _unhandled_input(event: InputEvent) -> void:
	# Forward the input to the first child, which should be the SubViewport.
	var sub_viewport = get_child(0) if get_child_count() > 0 else null
	if sub_viewport and sub_viewport is SubViewport:
		# The input needs to be transformed to the Viewport's local coordinate system.
		# However, ViewportContainer does not transform input events for its children automatically.
		# We need to create a copy and set the transformed position.
		if event is InputEventMouse:
			var transformed_event = event.duplicate()
			transformed_event.position = get_local_mouse_position()
			sub_viewport.push_input(transformed_event)
			# Accept the event to prevent it from propagating further if it's handled.
			get_viewport().set_input_as_handled()
		else:
			sub_viewport.push_input(event)
			get_viewport().set_input_as_handled()
