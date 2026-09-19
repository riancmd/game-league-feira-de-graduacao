class_name StudentMovementConfig
extends Resource

@export_range(0.0, 2000.0, 1.0) var max_speed: float = 350.0
@export_range(0.0, 20.0, 0.1) var acceleration: float = 2.0
@export_range(0.0, 30.0, 0.1) var friction: float = 10.0
@export_range(0.0, 5000.0, 1.0) var gravity: float = 1280.0
@export_range(-3000.0, 0.0, 1.0) var jump_force: float = -600.0
@export_range(0, 10, 1) var extra_jump_count: int = 1
@export_range(0.0, 5000.0, 1.0) var max_fall_speed: float = 1500.0
