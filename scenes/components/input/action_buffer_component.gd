class_name ActionBufferComponent
extends Node

@export var timer: Timer


func start() -> void:
	if timer:
		timer.start()


func stop() -> void:
	if timer:
		timer.stop()


func is_active() -> bool:
	return timer != null and not timer.is_stopped()
