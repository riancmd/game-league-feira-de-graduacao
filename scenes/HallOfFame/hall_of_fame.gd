extends Node2D

signal new_area_entered(text : String, image : Texture2D)
signal disable_previous

@export var camera : Camera2D

@export var title_area : String
@export var image : Texture2D
@export var collisionArea : CollisionShape2D
@export var next_wall_collision : CollisionShape2D

func enter_new_area() -> void:
	emit_signal("new_area_entered", title_area, image)
	emit_signal("disable_previous")

func _on_area_detect_body_entered(body: Node2D) -> void:
	enter_new_area()
	var tween : Tween = create_tween()
	tween.tween_property(camera, "global_position:x", collisionArea.global_position.x, 0.3)
