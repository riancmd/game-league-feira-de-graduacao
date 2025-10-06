extends Node2D

@export var player : CharacterBody2D

func _on_talking() -> void:
	player.is_in_cutscene = true
	player.velocity.x = 0.0

func _on_stop_talking() -> void:
	player.is_in_cutscene = false
