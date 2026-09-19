extends CharacterBody2D

signal attack_finished
signal damaged
signal dead

@export_category("Components")
@export var movement_component: StudentMovementComponent
@export var jump_buffer_component: ActionBufferComponent
@export var attack_buffer_component: ActionBufferComponent
@export var knockback_component: KnockbackComponent
@export var state_machine: StateMachine

#region Animation Data
@export_category("Animation")
@export var anim : AnimatedSprite2D
@export var cutscene_player : AnimationPlayer
#endregion

#region Attack Data
@export_category("Attack")
@export var is_attacking : bool = false
#endregion

#region Others
@export_category("Others")
@export var collision_hitbox : CollisionShape2D
#endregion

var is_dead : bool = false
var is_talking : bool = false
var is_in_cutscene : bool = false
var score : int = 0

func _unhandled_input(event: InputEvent) -> void:
	if not is_talking and not is_dead and not is_in_cutscene and not knockback_component.is_active:
		state_machine._on_input(event)

func _physics_process(delta: float) -> void:
	movement_component.apply_gravity(delta)
	
	if not is_talking and not is_dead and not is_in_cutscene and not knockback_component.is_active:
	
		movement_component.update_floor_state()
		
		state_machine._on_physics_update(delta)

		#limit_horizontal_position()

	move_and_slide()

#region Death Methods
func die() -> void:
	is_dead = true
	state_machine.transition_to_named(&"death")

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation in [&"attack", &"attack_2"]:
		emit_signal("attack_finished")
#endregion

func apply_knockback(attacker_position: Vector2) -> void:
	if knockback_component.is_active:
		return
	
	emit_signal("damaged")
	knockback_component.apply(attacker_position)

func receive_hit(hitbox: HitboxComponent) -> void:
	apply_knockback(hitbox.get_source_position())

func play_cutscene_animation(anim_name : String) -> void:
	is_in_cutscene = true
	cutscene_player.play(anim_name)

func stop_cutscene_animation() -> void:
	is_in_cutscene = false
	cutscene_player.stop()
	anim.play("idle")

func getScore() -> int:
	return score
	
func setScore(s) -> void:
	score += s
