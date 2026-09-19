extends RoomController

@export var bugs_scene : PackedScene

@onready var spawn_points: Node2D = $SpawnPoints

var bugs_counter : int = 0

func on_dialogue_finished() -> void:
	var points := spawn_points.get_children()
	bugs_counter = points.size()

	for child in points:
		var spawn_point := child as Marker2D
		if not spawn_point:
			push_warning("Ignoring invalid spawn point in LabProg: %s" % child.name)
			bugs_counter -= 1
			continue

		var bug_instance : CharacterBody2D = bugs_scene.instantiate()
		bug_instance.position = spawn_point.position
		bug_instance.connect("mob_death", _on_mob_death)
		add_child(bug_instance)
		await get_tree().create_timer(1.0).timeout

	if bugs_counter == 0:
		complete_room()

func _on_mob_death() -> void:
	bugs_counter -= 1
	request_camera_shake(10.0)
	if bugs_counter <= 0:
		complete_room()
