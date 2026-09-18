extends EnemyBase

signal mob_death

@export var speed : float = 15.0
@export var gravity : float = 800.0

var direction : Vector2 = Vector2.LEFT

@export var animated_sprite: AnimatedSprite2D
@export var ledge_checker_01: RayCast2D
@export var ledge_checker_02: RayCast2D

func _physics_process(delta: float) -> void:
	if is_dead: return

	if not is_on_floor():
		velocity.y += gravity * delta
	
	var left_has_ground = ledge_checker_01.is_colliding()
	var right_has_ground = ledge_checker_02.is_colliding()

	if left_has_ground and right_has_ground:
		velocity.x = 0
	elif direction.x < 0 and left_has_ground:
		direction = Vector2.RIGHT
	elif direction.x > 0 and right_has_ground:
		direction = Vector2.LEFT
	elif is_on_wall():
		direction *= -1

	velocity.x = speed * direction.x

	animated_sprite.flip_h = direction.x > 0

	move_and_slide()

func on_died(_source: HitboxComponent) -> void:
	animated_sprite.play("hit")

func _on_animated_sprite_2d_animation_finished() -> void:
	emit_signal("mob_death")
	queue_free()
