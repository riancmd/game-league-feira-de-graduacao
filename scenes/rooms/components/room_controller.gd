class_name RoomController
extends Node2D

signal new_area_entered(text: String, image: Texture2D)
signal talking
signal stop_talking
signal room_entered(room: RoomController)
signal room_completed(room: RoomController)

enum RoomState { IDLE, DIALOGUE, ACTIVE, COMPLETED }

@export_category("Presentation")
@export var title_area: String
@export var image: Texture2D
@export var progress_indicator: CanvasItem

@export_category("Room Flow")
@export var next_gate: RoomGate

@export_category("Camera")
@export var camera: Camera2D
@export var camera_anchor: Node2D
@export var camera_transition_duration: float = 0.3

var current_state: RoomState = RoomState.IDLE
var has_entered: bool = false


func enter_room() -> void:
	if has_entered:
		return

	has_entered = true
	current_state = RoomState.ACTIVE
	new_area_entered.emit(title_area, image)
	room_entered.emit(self)
	focus_camera()


func focus_camera() -> void:
	if not camera or not camera_anchor:
		return

	var tween := create_tween()
	tween.tween_property(
		camera,
		"global_position:x",
		camera_anchor.global_position.x,
		camera_transition_duration
	)


func start_dialogue() -> void:
	if current_state == RoomState.COMPLETED:
		return

	current_state = RoomState.DIALOGUE
	talking.emit()


func finish_dialogue() -> void:
	if current_state == RoomState.COMPLETED:
		return

	current_state = RoomState.ACTIVE
	stop_talking.emit()


func complete_room() -> void:
	if current_state == RoomState.COMPLETED:
		return

	current_state = RoomState.COMPLETED
	if next_gate:
		next_gate.open()
	if progress_indicator:
		progress_indicator.show()
	room_completed.emit(self)
