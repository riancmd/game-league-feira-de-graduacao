class_name KnockbackComponent
extends Node

signal started
signal finished

@export var entity: CharacterBody2D
@export var timer: Timer
@export var force: float = 250.0
@export var vertical_boost: float = 200.0

var is_active: bool = false


func _ready() -> void:
	if timer and not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)


func apply(source_position: Vector2) -> void:
	if is_active or not entity:
		return

	is_active = true
	var direction := (entity.global_position - source_position).normalized()
	entity.velocity = direction * force
	entity.velocity.y -= vertical_boost

	if timer:
		timer.start()
	started.emit()


func _on_timer_timeout() -> void:
	is_active = false
	finished.emit()
