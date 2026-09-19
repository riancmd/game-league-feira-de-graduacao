class_name HealthComponent
extends Node

signal health_changed(current_health: float, max_health: float)
signal died(source: HitboxComponent)

@export var max_health: float = 1.0

var current_health: float


func _ready() -> void:
	reset()


func take_damage(amount: float, source: HitboxComponent) -> void:
	if amount <= 0.0 or current_health <= 0.0:
		return

	current_health = maxf(current_health - amount, 0.0)
	health_changed.emit(current_health, max_health)
	if current_health <= 0.0:
		died.emit(source)


func reset() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)
