class_name StudentMovementComponent
extends Node

@export var entity: CharacterBody2D
@export var config: StudentMovementConfig
@export var coyote_timer: Timer
@export var visuals: AnimatedSprite2D
@export var squash_animation_player: AnimationPlayer
@export var attack_collision: CollisionShape2D

var remaining_jumps: int = 0
var was_on_floor: bool = false
var base_attack_offset_x: float = 0.0


func _ready() -> void:
	if not entity or not config:
		push_error("StudentMovementComponent requires an entity and config: %s" % get_path())
		return
	if attack_collision:
		base_attack_offset_x = attack_collision.position.x


func apply_gravity(delta: float) -> void:
	if not entity or not config:
		return
	if not entity.is_on_floor() and entity.velocity.y <= config.max_fall_speed:
		entity.velocity.y += config.gravity * delta


func update_floor_state() -> void:
	if not entity:
		return
	if was_on_floor and not entity.is_on_floor() and entity.velocity.y >= 0.0 and coyote_timer:
		coyote_timer.start()
	was_on_floor = entity.is_on_floor()


func move_horizontal(delta: float, input_axis: float) -> void:
	if not entity or not config:
		return
	if input_axis != 0.0:
		entity.velocity.x = lerp(entity.velocity.x, input_axis * config.max_speed, config.acceleration * delta)
	else:
		entity.velocity.x = lerp(entity.velocity.x, 0.0, config.friction * delta)


func update_facing(input_axis: float, is_attacking: bool) -> void:
	if input_axis == 0.0 or is_attacking:
		return
	if visuals:
		visuals.flip_h = input_axis < 0.0
	if attack_collision:
		attack_collision.position.x = base_attack_offset_x * input_axis


func jump() -> void:
	if not entity or not config:
		return
	if remaining_jumps > 0:
		remaining_jumps -= 1
	play_squash_and_stretch()
	entity.velocity.y = config.jump_force
	if not Input.is_action_pressed("jump"):
		cut_jump()


func can_jump() -> bool:
	if not entity:
		return false
	return entity.is_on_floor() or remaining_jumps > 0 and is_coyote_active()


func reset_jump_count() -> void:
	if config:
		remaining_jumps = config.extra_jump_count


func cut_jump() -> void:
	if entity:
		entity.velocity.y *= 0.25


func play_squash_and_stretch() -> void:
	if squash_animation_player:
		squash_animation_player.play(&"squash")


func is_coyote_active() -> bool:
	return coyote_timer != null and not coyote_timer.is_stopped()


func stop_coyote_timer() -> void:
	if coyote_timer:
		coyote_timer.stop()
