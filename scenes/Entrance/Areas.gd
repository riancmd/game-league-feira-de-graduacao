extends Node2D

signal new_area_entered(text : String, image : Texture2D)

@export var title_area : String
@export var image : Texture2D

func enter_new_area() -> void:
	emit_signal("new_area_entered", title_area, image)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	enter_new_area()
