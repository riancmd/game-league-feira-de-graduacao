class_name FloatingMovementComponent
extends Node

@export var entity: EnemyBase
@export var left_ray: RayCast2D
@export var right_ray: RayCast2D
@export var config: FloatingMovementConfig

var direction: Vector2 = Vector2.LEFT
var elapsed_time: float = 0.0
var initial_height: float = 0.0
var is_active: bool = false


func activate() -> void:
	if not entity or not config:
		push_error("FloatingMovementComponent is missing entity or config: %s" % get_path())
		return

	initial_height = entity.global_position.y
	elapsed_time = 0.0
	is_active = true


func physics_update(delta: float) -> void:
	if not entity or not config:
		return

	if entity.is_dead:
		entity.velocity.y += config.gravity * delta
		entity.move_and_slide()
		return

	if not is_active:
		return

	elapsed_time += delta
	var target_height := initial_height + sin(elapsed_time * config.frequency) * config.amplitude
	entity.velocity.y = (target_height - entity.global_position.y) / maxf(delta, 0.0001)

	var left_colliding := left_ray and left_ray.is_colliding()
	var right_colliding := right_ray and right_ray.is_colliding()
	if left_colliding and right_colliding:
		entity.velocity.x = 0.0
	elif direction.x < 0.0 and left_colliding:
		direction = Vector2.RIGHT
	elif direction.x > 0.0 and right_colliding:
		direction = Vector2.LEFT
	elif entity.is_on_wall():
		direction *= -1.0

	entity.velocity.x = direction.x * config.speed
	entity.move_and_slide()
