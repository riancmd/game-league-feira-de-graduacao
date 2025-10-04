extends State
class_name FallState

@onready var state_machine : Node = get_parent()

func enter() -> void:
	player.anim.play("fall")

func handle_input(event : InputEvent) -> State:
	if event.is_action_pressed("jump"):
		if player.is_coyote_timer_activated():
			return state_machine.get_node("jump")
		
		player.start_jump_buffer()
	if event.is_action_pressed("attack"):
		return state_machine.get_node("attack")
	
	return null

func physics_update(delta: float) -> State:
	var input_axis : float = Input.get_axis("left", "right")
	player.move(delta, input_axis)
	player.flip_sprite(input_axis)
	
	if player.is_on_floor():
		player.play_squash_n_stretch()
		
		if player.is_jump_buffering():
			return state_machine.get_node("jump")
		
		if input_axis == 0:
			return state_machine.get_node("idle")
		
		if input_axis != 0:
			return state_machine.get_node("walk")
	
	return null
