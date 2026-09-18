extends Node2D

signal new_area_entered(text : String, image : Texture2D)
signal talking
signal stop_talking

@export var title_area : String
@export var image : Texture2D

@export var previous_gate: RoomGate
@export var next_gate: RoomGate

func enter_new_area() -> void:
	emit_signal("new_area_entered", title_area, image)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	enter_new_area()
	previous_gate.close()

func _on_npc_ended_talking() -> void:
	emit_signal("stop_talking")
	next_gate.open()
	$Arrow_Go.show()

func _on_creative_studio_disable_previous() -> void:
	next_gate.close()

func _on_npc_start_talking() -> void:
	emit_signal("talking")
