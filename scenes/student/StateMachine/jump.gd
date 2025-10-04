extends State
class_name JumpState

@onready var state_machine : Node = get_parent()

func enter() -> void:
	SfxManager.play_sfx("jump")
	player.jump()
	player.stop_coyote_timer()
	
	if not player.is_attacking:
		player.anim.play("jump")

func handle_input(event : InputEvent) -> State:
	if event.is_action_released("jump"):
		player.cut_velocity()
		return state_machine.get_node("fall")
	if event.is_action_pressed("attack"):
		return state_machine.get_node("attack")
	return null

func physics_update(delta: float) -> State:
	var input_axis : float = Input.get_axis("left", "right")
	player.move(delta, input_axis)
	player.flip_sprite(input_axis)
	
	if player.velocity.y > 0:
		return state_machine.get_node("fall")
	
	return null

func exit() -> void:
	pass
