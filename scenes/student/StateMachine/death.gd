extends State
class_name DeathState

func enter() -> void:
	player.anim.play("die")

func physics_update(delta: float) -> State:
	player.move(delta, 0)
	
	return null
