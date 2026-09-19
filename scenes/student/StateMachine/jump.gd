extends State
class_name JumpState

func enter() -> void:
	SfxManager.play_sfx(SfxManager.JUMP)
	player.movement_component.jump()
	player.movement_component.stop_coyote_timer()
	
	if not player.is_attacking:
		player.anim.play("jump")

func handle_input(event : InputEvent) -> State:
	if event.is_action_released("jump"):
		player.movement_component.cut_jump()
		return get_state(&"fall")
	if event.is_action_pressed("attack"):
		return get_state(&"attack")
	return null

func physics_update(delta: float) -> State:
	var input_axis : float = Input.get_axis("left", "right")
	player.movement_component.move_horizontal(delta, input_axis)
	player.movement_component.update_facing(input_axis)
	
	if player.velocity.y > 0:
		return get_state(&"fall")
	
	return null

func exit() -> void:
	pass
