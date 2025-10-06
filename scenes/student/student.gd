extends CharacterBody2D

signal attack_finished
signal dead

#region Movement Data
@export_category("Movement Stats")
@export var max_speed : float
@export var acceleration : float
@export var friction : float
@export var gravity : float
#endregion

#region Jump and Fall Data
@export_category("Jump and Fall")
@export var jump_force : float
@export var jump_count_max : int
@export var jump_count : int
@export var max_fall_speed : float
@export var coyote_timer : Timer
@export var jump_buffer_timer : Timer
@export var was_on_floor : bool = false
#endregion

#region Animation Data
@export_category("Animation")
@export var anim : AnimatedSprite2D
@export var animation_player : AnimationPlayer
@export var cutscene_player : AnimationPlayer
#endregion

#region Attack Data
@export_category("Attack")
@export var is_attacking : bool = false
@export var attack_buffer_timer : Timer
#endregion

#region KnockBack Data
@export_category("Knockback")
@export var knockback_force: float = 250.0
@export var knockback_timer : Timer
#endregion

#region Others
@export_category("Others")
@export var state_machine : Node
@export var screen_size : Vector2
@export var collision_hitbox : CollisionShape2D
@export var collision_physics : CollisionShape2D
@onready var base_hitbox_offset_x : int = collision_hitbox.position.x
#endregion

var is_dead : bool = false
var is_talking : bool = false
var is_in_cutscene : bool = false
var is_in_knockback : bool = false
var score : int = 0

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _unhandled_input(event: InputEvent) -> void:
	if not is_talking and not is_dead and not is_in_cutscene and not is_in_knockback:
		state_machine._on_input(event)

func _physics_process(delta: float) -> void:
	active_gravity(gravity, delta)
	
	if not is_talking and not is_dead and not is_in_cutscene and not is_in_knockback:
	
		check_was_on_floor()

		state_machine._on_physics_update(delta)

		#limit_horizontal_position()

	move_and_slide()

func active_gravity(accel : float, delta : float) -> void:
	if not is_on_floor() and velocity.y <= max_fall_speed:
		velocity.y += accel * delta

func check_was_on_floor() -> void:
	if was_on_floor and not is_on_floor() and velocity.y >= 0:
		coyote_timer.start()
	was_on_floor = is_on_floor()

func move(delta : float, input_axis : int) -> void:
	if input_axis != 0:
		velocity.x = lerp(velocity.x, input_axis * max_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction * delta)

func flip_sprite(input_axis : int) -> void:
	if input_axis != 0 and not is_attacking:
		anim.flip_h = input_axis < 0
		collision_hitbox.position.x = base_hitbox_offset_x * input_axis

func limit_horizontal_position() -> void:
	global_position.x = clamp(global_position.x, 0.0, screen_size.x)

#region Jump and Fall Methods
func jump() -> void:
	minus_jump_count()
	play_squash_n_stretch()
	velocity.y = jump_force
	
	if not Input.is_action_pressed("jump"):
		cut_velocity()

func can_jump() -> bool:
	return is_on_floor() or jump_count > 0 and not coyote_timer.is_stopped()

func minus_jump_count() -> void:
	if jump_count > 0:
		jump_count -= 1

func reset_jump_count() -> void:
	jump_count = jump_count_max

func cut_velocity() -> void:
	velocity.y *= 0.25

func play_squash_n_stretch() -> void:
	animation_player.play("squash")
#endregion

#region Jump Buffer Methods
func start_jump_buffer() -> void:
	jump_buffer_timer.start()

func is_jump_buffering() -> bool:
	return not jump_buffer_timer.is_stopped()

func stop_jump_buffer() -> void:
	jump_buffer_timer.stop()
#endregion

#region CoyoteTimer Methods
func is_coyote_timer_activated() -> bool:
	return not coyote_timer.is_stopped()

func stop_coyote_timer() -> void:
	coyote_timer.stop()
#endregion

#region Attack Buffer Methods
func start_attack_buffer() -> void:
	attack_buffer_timer.start()

func is_attack_buffering() -> bool:
	return not attack_buffer_timer.is_stopped()

func stop_attack_buffer() -> void:
	attack_buffer_timer.stop()
#endregion

#region Death Methods
func die() -> void:
	is_dead = true
	state_machine.transition_to(state_machine.get_node("death"))

func _on_animated_sprite_2d_animation_finished() -> void:
	emit_signal("attack_finished")
#endregion

func apply_knockback(attacker_position: Vector2) -> void:
	if is_in_knockback: return

	is_in_knockback = true

	var direction = (global_position - attacker_position).normalized()

	velocity = direction * knockback_force
	velocity.y -= 200.0

	knockback_timer.start()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	#if not body.is_dead:
		#die()
	print("danou-se")

func play_cutscene_animation(anim_name : String) -> void:
	is_in_cutscene = true
	cutscene_player.play(anim_name)

func stop_cutscene_animation() -> void:
	is_in_cutscene = false
	cutscene_player.stop()
	anim.play("idle")

func _on_knock_back_timer_timeout() -> void:
	is_in_knockback = false

func getScore() -> int:
	return score
	
func setScore(s) -> void:
	score += s
