extends Node2D

@export var camera : Camera2D

func _on_creative_studio_new_area_entered(text: String, image: Texture2D, pos : Vector2) -> void:
	camera.position = pos
