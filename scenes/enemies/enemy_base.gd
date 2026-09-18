class_name EnemyBase
extends CharacterBody2D

signal died

@export var health_component: HealthComponent
@export var collision: CollisionShape2D

var is_dead: bool = false


func _ready() -> void:
	if not health_component:
		push_error("EnemyBase requires a HealthComponent: %s" % get_path())
		return

	if not health_component.died.is_connected(_on_health_depleted):
		health_component.died.connect(_on_health_depleted)


func receive_hit(hitbox: HitboxComponent) -> void:
	if is_dead:
		return
	health_component.take_damage(hitbox.damage, hitbox)


func _on_health_depleted(source: HitboxComponent) -> void:
	if is_dead:
		return

	is_dead = true
	if collision:
		collision.set_deferred("disabled", true)
	for child in get_children():
		if child is HitboxComponent or child is HurtboxComponent:
			child.set_deferred("monitoring", false)
	died.emit()
	on_died(source)


func on_died(_source: HitboxComponent) -> void:
	pass
