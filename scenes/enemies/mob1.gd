extends EnemyBase

signal mob_death

@export var animated_sprite: AnimatedSprite2D
@export var movement_component: GroundPatrolComponent

func _physics_process(delta: float) -> void:
	movement_component.physics_update(delta)

func on_died(_source: HitboxComponent) -> void:
	animated_sprite.play("hit")

func _on_animated_sprite_2d_animation_finished() -> void:
	emit_signal("mob_death")
	queue_free()
