class_name GroundPatrolComponent
extends Node

@export var entity: EnemyBase
@export var left_ground_ray: RayCast2D
@export var right_ground_ray: RayCast2D
@export var visuals: AnimatedSprite2D

var direction: Vector2 = Vector2.LEFT


func physics_update(delta: float) -> void:
	if not entity or not entity.definition:
		return

	if entity.is_dead:
		return

	if not entity.is_on_floor():
		entity.velocity.y += entity.definition.gravity * delta

	var left_has_ground := left_ground_ray and left_ground_ray.is_colliding()
	var right_has_ground := right_ground_ray and right_ground_ray.is_colliding()
	if left_has_ground and right_has_ground:
		entity.velocity.x = 0.0
	elif direction.x < 0.0 and left_has_ground:
		direction = Vector2.RIGHT
	elif direction.x > 0.0 and right_has_ground:
		direction = Vector2.LEFT
	elif entity.is_on_wall():
		direction *= -1.0

	entity.velocity.x = entity.definition.move_speed * direction.x
	if visuals:
		visuals.flip_h = direction.x > 0.0
	entity.move_and_slide()
