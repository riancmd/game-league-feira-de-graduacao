extends StaticBody2D

enum PlatformGroup { BLUE, RED }
@export var platform_group: PlatformGroup = PlatformGroup.BLUE

@export var sprite: AnimatedSprite2D
@export var collision_shape: CollisionShape2D

func _ready() -> void:
	if platform_group == PlatformGroup.RED:
		deactivate()

func _on_rhythm_tick(is_blue_active: bool) -> void:
	if is_blue_active and platform_group == PlatformGroup.BLUE:
		activate()
	elif not is_blue_active and platform_group == PlatformGroup.RED:
		activate()
	else:
		deactivate()

func activate() -> void:
	collision_shape.set_deferred("disabled", false)
	sprite.modulate.a = 1.0

func deactivate() -> void:
	collision_shape.set_deferred("disabled", true)
	sprite.modulate.a = 0.3
