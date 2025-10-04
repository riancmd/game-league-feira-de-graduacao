extends Node2D

func _process(delta: float) -> void:
	print($student.getScore())

func _on_finish_body_entered(body: Node2D) -> void:
	if body.name == "student":
		get_tree().reload_current_scene()
