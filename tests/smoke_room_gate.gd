extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var entrance_scene := load("res://scenes/Entrance/entrance.tscn") as PackedScene
	assert(entrance_scene, "Entrance scene must load")

	var entrance := entrance_scene.instantiate()
	root.add_child(entrance)
	await process_frame

	var previous_gate: RoomGate = entrance.previous_gate
	var next_gate: RoomGate = entrance.next_gate

	assert(previous_gate.is_open, "Previous gate must start open")
	assert(previous_gate.collision_shape.disabled, "Open gate collision must be disabled")
	assert(not next_gate.is_open, "Next gate must start closed")
	assert(not next_gate.collision_shape.disabled, "Closed gate collision must be enabled")

	previous_gate.close()
	next_gate.open()
	await physics_frame

	assert(not previous_gate.is_open, "Previous gate must close")
	assert(not previous_gate.collision_shape.disabled, "Closed gate collision must be enabled")
	assert(next_gate.is_open, "Next gate must open")
	assert(next_gate.collision_shape.disabled, "Open gate collision must be disabled")

	entrance.queue_free()
	print("SMOKE_ROOM_GATE_OK")
	quit()
