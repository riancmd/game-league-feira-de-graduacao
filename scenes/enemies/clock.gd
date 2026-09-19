extends EnemyBase

signal clock_boss_defeated
signal tic_tac

@export var clock_timer : Timer
@export var movement_component: FloatingMovementComponent

var is_tic_blue : bool = false

func _physics_process(delta: float) -> void:
	movement_component.physics_update(delta)

func on_died(source: HitboxComponent) -> void:
	emit_signal("clock_boss_defeated")
	clock_timer.stop()
	
	velocity.y = -300
	velocity.x = 100 * sign(global_position.x - source.get_source_position().x)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != &"spawn":
		return
	movement_component.activate()
	_on_clock_timer_timeout()

func _on_clock_timer_timeout() -> void:
	emit_signal("tic_tac", is_tic_blue)
	is_tic_blue = not is_tic_blue
	if is_tic_blue:
		SfxManager.play_sfx(SfxManager.TIC)
	else:
		SfxManager.play_sfx(SfxManager.TAC)
	clock_timer.start()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_dead:
		queue_free()
