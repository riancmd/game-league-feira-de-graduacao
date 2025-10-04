extends State
class_name DeathState

func enter() -> void:
	#player.anim.play("die")
	player.emit_signal("dead")

func physics_update(delta: float) -> State:
	player.move(delta, 0)
	
	return null
