class_name RoomGate
extends StaticBody2D

signal opened
signal closed

@export var collision_shape: CollisionShape2D
@export var starts_open: bool = false

var is_open: bool


func _ready() -> void:
	is_open = starts_open
	_apply_collision_state(false)


func open() -> void:
	set_open(true)


func close() -> void:
	set_open(false)


func set_open(value: bool) -> void:
	if is_open == value:
		return

	is_open = value
	_apply_collision_state(true)


func _apply_collision_state(deferred: bool) -> void:
	if not collision_shape:
		push_error("RoomGate requires a CollisionShape2D reference: %s" % get_path())
		return

	if deferred:
		collision_shape.set_deferred("disabled", is_open)
	else:
		collision_shape.disabled = is_open

	if is_open:
		opened.emit()
	else:
		closed.emit()
