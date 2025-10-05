extends ParallaxBackground

@export var layer_1 : ParallaxLayer
@export var layer_4 : ParallaxLayer

func _process(delta: float) -> void:
	layer_1.motion_offset.x += 5 * delta
	layer_4.motion_offset.x += 15 * delta
