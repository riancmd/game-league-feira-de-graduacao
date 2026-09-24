extends Control

@export var start_button : Button

func _ready() -> void:
	start_button.grab_focus()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game/game.tscn")
