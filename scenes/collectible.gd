extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "student":
		$AnimatedSprite2D.play("collected")
		$sfx.play()
		await get_tree().create_timer(0.3).timeout
		$"../../student".setScore(1)
		queue_free()
	
