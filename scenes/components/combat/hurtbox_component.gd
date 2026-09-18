class_name HurtboxComponent
extends Area2D

signal hit_received(hitbox: HitboxComponent)

@export var entity: Node


func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	var hitbox := area as HitboxComponent
	if not hitbox:
		return

	hit_received.emit(hitbox)
	if entity and entity.has_method("receive_hit"):
		entity.receive_hit(hitbox)
