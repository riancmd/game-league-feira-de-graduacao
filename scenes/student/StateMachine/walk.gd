extends State
class_name WalkState

func enter() -> void:
	player.anim.play("walk")
	player.movement_component.reset_jump_count()

func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		player.jump_buffer_component.start()
	if event.is_action_pressed("attack"):
		return get_state(&"attack")
	
	return null

func physics_update(delta: float) -> State:
	var input_axis: float = Input.get_axis("left", "right")
	player.movement_component.move_horizontal(delta, input_axis)
	player.movement_component.update_facing(input_axis)
	
	if player.movement_component.can_jump() and player.jump_buffer_component.is_active():
		player.jump_buffer_component.stop()
		return get_state(&"jump")
	
	if input_axis == 0 and player.is_on_floor():
		return get_state(&"idle")
	
	if player.velocity.y > 0:
		return get_state(&"fall")
	
	return null
