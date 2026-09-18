extends RoomController

signal shake_camera(amount : float)

@export var clock_scene : PackedScene
@export var platformers : Node2D

func _on_area_detect_body_entered(_body: Node2D) -> void:
	enter_room()

func _on_tic_tac(is_tic_blue : bool) -> void:
	for child in platformers.get_children():
		child._on_rhythm_tick(is_tic_blue)

func _on_clock_defeated() -> void:
	emit_signal("shake_camera", 30.0)
	
	for child in platformers.get_children():
		child.queue_free()
	complete_room()

func _on_npc_ended_talking() -> void:
	finish_dialogue()
	
	var clock_instance : CharacterBody2D = clock_scene.instantiate()
	clock_instance.connect("tic_tac", _on_tic_tac)
	clock_instance.connect("clock_boss_defeated", _on_clock_defeated)
	platformers.show()
	add_child(clock_instance)

func _on_npc_start_talking() -> void:
	start_dialogue()
