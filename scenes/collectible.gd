extends Area2D

signal collected

@export var anim : AnimatedSprite2D

func _on_body_entered(_body: Node2D) -> void:
	anim.play("collected")
	SfxManager.play_sfx("item_pickup")

func _on_animated_sprite_2d_animation_finished() -> void:
	emit_signal("collected")
	queue_free()
