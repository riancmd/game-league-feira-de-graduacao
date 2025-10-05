extends Camera2D

const shakeFade : float = 9.0

var shakeStrength : float = 0.0

func shake(InitialStrength : float):
	shakeStrength = InitialStrength
	
func _process(delta: float) -> void:
	if shakeStrength > 0.05:
		shakeStrength = lerp(shakeStrength, 0.0, shakeFade * delta)
		offset = randomOffset()
		
func randomOffset() -> Vector2:
	return Vector2(randf_range(-shakeStrength, shakeStrength), randf_range(-shakeStrength, shakeStrength))
