extends Node2D

@export var camera : Camera2D
@export var player : CharacterBody2D
@export var rooms: Array[RoomController]

var is_returning_to_menu : bool = false

func _ready() -> void:
	for room in rooms:
		if not room.room_entered.is_connected(_on_room_entered):
			room.room_entered.connect(_on_room_entered)

func _on_room_entered(room: RoomController) -> void:
	var room_index := rooms.find(room)
	if room_index <= 0:
		return

	var previous_room := rooms[room_index - 1]
	if previous_room.next_gate:
		previous_room.next_gate.close()

func _on_talking() -> void:
	player.is_in_cutscene = true
	player.velocity.x = 0.0

func _on_stop_talking() -> void:
	player.is_in_cutscene = false

func _on_student_damaged() -> void:
	camera.shake(15.0)

func _on_shake_camera(amount: float) -> void:
	camera.shake(amount)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_viewport().set_input_as_handled()
		return_to_menu()


func return_to_menu() -> void:
	if is_returning_to_menu:
		return
	
	is_returning_to_menu = true
	
	Dialogic.paused = false
	
	if Dialogic.has_subsystem("Voice"):
		Dialogic.Voice.stop_audio()

	if Dialogic.current_timeline:
		await Dialogic.end_timeline(true)

	get_tree().change_scene_to_file("res://scenes/Menu/menu.tscn")
