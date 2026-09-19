extends State
class_name DeathState

func enter() -> void:
	#player.anim.play("die")
	player.emit_signal("dead")

func physics_update(delta: float) -> State:
	player.movement_component.move_horizontal(delta, 0.0)
	
	return null
