extends Node2D

@export var camera : Camera2D
@export var player : CharacterBody2D

func _on_talking() -> void:
	player.is_in_cutscene = true
	player.velocity.x = 0.0

func _on_stop_talking() -> void:
	player.is_in_cutscene = false

func _on_student_damaged() -> void:
	camera.shake(15.0)

func _on_shake_camera(amount: float) -> void:
	camera.shake(amount)
