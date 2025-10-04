extends CharacterBody2D

@export var speed: float = 30.0
@export var gravity: float = 800.0

var direction : Vector2 = Vector2.LEFT
var is_dead: bool = false

@export var animated_sprite: AnimatedSprite2D
@export var ledge_checker_01: RayCast2D
@export var ledge_checker_02: RayCast2D

@export var hurtbox : Area2D
@export var collision : CollisionShape2D

func _physics_process(delta: float) -> void:
	if is_dead: return

	if not is_on_floor():
		velocity.y += gravity * delta
	
	if direction.x == 1:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
	
	var left_has_ground = ledge_checker_01.is_colliding()
	var right_has_ground = ledge_checker_02.is_colliding()

	if not left_has_ground and not right_has_ground:
		velocity.x = 0
	elif direction.x < 0 and not left_has_ground:
		direction = Vector2.RIGHT
	elif direction.x > 0 and not right_has_ground:
		direction = Vector2.LEFT
	elif is_on_wall():
		direction *= -1

	velocity.x = speed * direction.x

	animated_sprite.flip_h = direction.x > 0

	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	is_dead = true
	collision.set_deferred("disabled", true)
	animated_sprite.play("hit")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
