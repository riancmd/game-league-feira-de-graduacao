extends RoomController

@export var previous_gate: RoomGate

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	enter_room()
	previous_gate.close()

func _on_npc_ended_talking() -> void:
	finish_dialogue()
	complete_room()

func _on_npc_start_talking() -> void:
	start_dialogue()
