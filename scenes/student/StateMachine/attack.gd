extends State
class_name AttackState

@onready var state_machine : Node = get_parent()

func enter() -> void:
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	if rng.randi_range(1,2) == 1:
		player.anim.play("attack")
	else:
		player.anim.play("attack_2")
	
	if not player.is_connected("attack_finished", _on_attack_finished):
		player.connect("attack_finished", _on_attack_finished)
	
	player.is_attacking = true

func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		player.start_jump_buffer()
	
	return null

func physics_update(delta: float) -> State:
	var input_axis: float = Input.get_axis("left", "right")
	player.move(delta, input_axis)
	player.flip_sprite(input_axis)
	
	if player.can_jump() and player.is_jump_buffering():
		player.stop_jump_buffer()
		return state_machine.get_node("jump")
	
	return null

func _on_attack_finished() -> void:
	player.is_attacking = false
	state_machine.transition_to(state_machine.get_node("idle"))
