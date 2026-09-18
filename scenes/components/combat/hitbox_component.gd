class_name HitboxComponent
extends Area2D

signal body_hit(body: Node2D)

@export var entity: Node2D
@export var damage: float = 1.0


func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func get_source_position() -> Vector2:
	if entity:
		return entity.global_position
	return global_position


func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("receive_hit"):
		return

	body.receive_hit(self)
	body_hit.emit(body)
