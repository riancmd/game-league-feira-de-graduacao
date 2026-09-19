extends State
class_name AttackState

func enter() -> void:
	SfxManager.play_sfx(SfxManager.SWORD)
	
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	if rng.randi_range(1,2) == 1:
		player.anim.play("attack")
	else:
		player.anim.play("attack_2")
	
	if not player.is_connected("attack_finished", _on_attack_finished):
		player.connect("attack_finished", _on_attack_finished)
	
	player.is_attacking = true
	player.collision_hitbox.set_deferred("disabled", false)

func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		player.jump_buffer_component.start()
	if event.is_action_pressed("attack"):
		player.attack_buffer_component.start()
	
	return null

func physics_update(delta: float) -> State:
	var input_axis: float = Input.get_axis("left", "right")
	player.movement_component.move_horizontal(delta, input_axis)
	player.movement_component.update_facing(input_axis, player.is_attacking)
	
	if player.movement_component.can_jump() and player.jump_buffer_component.is_active():
		player.jump_buffer_component.stop()
		return get_state(&"jump")
	
	return null

func _on_attack_finished() -> void:
	player.is_attacking = false
	player.collision_hitbox.set_deferred("disabled", true)
	
	if player.attack_buffer_component.is_active():
		player.attack_buffer_component.stop()
		state_machine.transition_to(self)
	else:
		state_machine.transition_to_named(&"idle")
