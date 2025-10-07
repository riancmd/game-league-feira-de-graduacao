extends Node2D

signal new_area_entered(text : String, image : Texture2D)
signal talking
signal stop_talking

@export var title_area : String
@export var image : Texture2D

@export var collision_wall: CollisionShape2D
@export var next_wall_collision : CollisionShape2D

func enter_new_area() -> void:
	emit_signal("new_area_entered", title_area, image)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	enter_new_area()
	collision_wall.disabled = false

func _on_npc_ended_talking() -> void:
	emit_signal("stop_talking")
	next_wall_collision.set_deferred("disabled", true)
	$Arrow_Go.show()

func _on_creative_studio_disable_previous() -> void:
	next_wall_collision.set_deferred("disabled", false)

func _on_npc_start_talking() -> void:
	emit_signal("talking")
