extends State
class_name WalkState

@onready var state_machine : Node = get_parent()

func enter() -> void:
	player.anim.play("walk")
	player.reset_jump_count()

func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		player.start_jump_buffer()
	if event.is_action_pressed("attack"):
		return state_machine.get_node("attack")
	
	return null

func physics_update(delta: float) -> State:
	var input_axis: float = Input.get_axis("left", "right")
	player.move(delta, input_axis)
	player.flip_sprite(input_axis)
	
	if player.can_jump() and player.is_jump_buffering():
		player.stop_jump_buffer()
		return state_machine.get_node("jump")
	
	if input_axis == 0 and player.is_on_floor():
		return state_machine.get_node("idle")
	
	if player.velocity.y > 0:
		return state_machine.get_node("fall")
	
	return null
