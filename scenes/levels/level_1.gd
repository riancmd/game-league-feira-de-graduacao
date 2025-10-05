extends Node2D

@export var camera : Camera2D
@export var player : CharacterBody2D

func _process(_delta: float) -> void:
	print($Student.getScore())

func _on_finish_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("reload_current_scene")

func _on_student_dead() -> void:
	camera.shake(25.0)
	await get_tree().create_timer(1.0).timeout
	get_tree().call_deferred("reload_current_scene")

func _on_item_collected() -> void:
	player.setScore(1)
