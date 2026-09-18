class_name EnemyDefinition
extends Resource

@export var display_name: StringName
@export_range(0.1, 1000.0, 0.1) var max_health: float = 1.0
@export_range(0.0, 1000.0, 0.1) var contact_damage: float = 1.0
@export_range(0.0, 1000.0, 1.0) var move_speed: float = 100.0
@export_range(0.0, 3000.0, 1.0) var gravity: float = 800.0
