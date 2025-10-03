extends CharacterBody2D

@export var speed = 200
@export var gravity = 1000
var jump_velocity = -500
@export var screen_size = Vector2(0,0)

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta

	# pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	if velocity.y >= 500 : velocity.y = 500
	
	# andar
	var direction = Input.get_axis("left", "right")
	
	# troca o sentido do sprite
	if direction != 0:
		$AnimatedSprite2D.flip_h = (direction == -1)
		
	# ataca
	if Input.is_action_just_pressed("attack"):
		$AnimatedSprite2D.play("attack")
	velocity.x = direction * speed
	move_and_slide()
	switch_animation(direction)
	
	position.x = clamp(position.x, 25, screen_size.x - 25)
	
	# se caiu, reinicia
	if position.y > screen_size.y:
		get_tree().reload_current_scene()
	
func switch_animation(direction):
	if !is_on_floor():
		if velocity.y < 0:
			$AnimatedSprite2D.play("fall")
		else: 
			$AnimatedSprite2D.play("jump")
	else:
		if direction != 0:
			$AnimatedSprite2D.play("walking")
		else:
			$AnimatedSprite2D.play("idle")
