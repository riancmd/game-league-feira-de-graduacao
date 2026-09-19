extends State
class_name AttackState

const ATTACK_ANIMATIONS := [&"attack", &"attack_2"]
const MAX_ATTACK_DURATION_SECONDS := 1.0

var attack_elapsed: float = 0.0


func enter() -> void:
	attack_elapsed = 0.0
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
	attack_elapsed += delta
	if player.anim.animation not in ATTACK_ANIMATIONS or attack_elapsed >= MAX_ATTACK_DURATION_SECONDS:
		return _get_next_state()

	var input_axis: float = Input.get_axis("left", "right")
	player.movement_component.move_horizontal(delta, input_axis)
	player.movement_component.update_facing(input_axis)
	
	if player.movement_component.can_jump() and player.jump_buffer_component.is_active():
		player.jump_buffer_component.stop()
		return get_state(&"jump")
	
	return null

func exit() -> void:
	player.is_attacking = false
	player.collision_hitbox.set_deferred("disabled", true)
	player.attack_buffer_component.stop()

func _on_attack_finished() -> void:
	if state_machine.current_state != self:
		return

	state_machine.transition_to(_get_next_state())


func _get_next_state() -> State:
	if player.attack_buffer_component.is_active():
		player.attack_buffer_component.stop()
		return self
	if not player.is_on_floor():
		return get_state(&"fall")
	if Input.get_axis("left", "right") != 0.0:
		return get_state(&"walk")
	return get_state(&"idle")
