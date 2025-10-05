extends Node2D

signal new_area_entered(text : String, image : Texture2D, pos : Vector2)

@export var brain_boss_scene : PackedScene

@export var title_area : String
@export var image : Texture2D

@export var previous_wall : CollisionShape2D
@export var next_wall : CollisionShape2D

func enter_new_area() -> void:
	emit_signal("new_area_entered", title_area, image, global_position)

func _on_area_detect_body_entered(body: Node2D) -> void:
	previous_wall.set_deferred("disabled", false)

func _on_npc_ended_talking() -> void:
	var brain_boss_instance : Area2D = brain_boss_scene.instantiate()
	add_child(brain_boss_instance)
