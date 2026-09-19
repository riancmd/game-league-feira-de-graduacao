extends RoomController

@export var previous_gate: RoomGate

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	enter_room()
	previous_gate.close()

func on_dialogue_finished() -> void:
	complete_room()
