extends CharacterBody2D

signal mob_death

@export var speed : float = 15.0
@export var gravity : float = 800.0

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

func _on_hurtbox_area_entered(area: Area2D) -> void:
	is_dead = true
	collision.set_deferred("disabled", true)
	animated_sprite.play("hit")

func _on_animated_sprite_2d_animation_finished() -> void:
	emit_signal("mob_death")
	queue_free()

func _on_hit_box_body_entered(body: Node2D) -> void:
	if not is_dead:
		body.apply_knockback(global_position)
