extends State
class_name DamagedState


func enter() -> void:
	if not player.knockback_component.finished.is_connected(_on_knockback_finished):
		player.knockback_component.finished.connect(_on_knockback_finished)


func exit() -> void:
	if player.knockback_component.finished.is_connected(_on_knockback_finished):
		player.knockback_component.finished.disconnect(_on_knockback_finished)


func _on_knockback_finished() -> void:
	if state_machine.current_state != self:
		return
	if player.is_on_floor():
		state_machine.transition_to_named(&"idle")
	else:
		state_machine.transition_to_named(&"fall")
