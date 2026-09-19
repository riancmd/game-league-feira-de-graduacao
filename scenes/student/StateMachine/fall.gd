extends State
class_name FallState

func enter() -> void:
	player.anim.play("fall")

func handle_input(event : InputEvent) -> State:
	if event.is_action_pressed("jump"):
		if player.movement_component.is_coyote_active():
			return get_state(&"jump")
		
		player.jump_buffer_component.start()
	if event.is_action_pressed("attack"):
		return get_state(&"attack")
	
	return null

func physics_update(delta: float) -> State:
	var input_axis : float = Input.get_axis("left", "right")
	player.movement_component.move_horizontal(delta, input_axis)
	player.movement_component.update_facing(input_axis)
	
	if player.is_on_floor():
		player.movement_component.play_squash_and_stretch()
		
		if player.jump_buffer_component.is_active():
			return get_state(&"jump")
		
		if input_axis == 0:
			return get_state(&"idle")
		
		if input_axis != 0:
			return get_state(&"walk")
	
	return null
