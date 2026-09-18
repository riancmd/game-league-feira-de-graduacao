extends RoomController

func _on_area_detect_body_entered(_body: Node2D) -> void:
	enter_room()

func _on_npc_start_talking() -> void:
	start_dialogue()

func _on_npc_ended_talking() -> void:
	finish_dialogue()
	complete_room()
