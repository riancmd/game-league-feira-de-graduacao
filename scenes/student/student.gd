extends CharacterBody2D

@export var speed = 200
@export var gravity = 1000
var jump_velocity = -500
var attacking = false
@export var screen_size = Vector2(0,0)

var atkCD : Timer

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	move(delta)
	handleAttack()
	
	# se caiu, reinicia
	if position.y > screen_size.y:
		get_tree().reload_current_scene()
	
func move(delta: float):
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
	velocity.x = direction * speed
			
	move_and_slide()
	switch_animation(direction)
	
	# limita movimentação pela tela
	position.x = clamp(position.x, 25, screen_size.x - 25)

# lida com o ataque
func handleAttack():
	# verifica botão e variável de ataque
	if Input.is_action_just_pressed("attack") && !attacking:
		attacking = true
		# troca entre duas diferentes animações aleatoriamente
		var RNG = RandomNumberGenerator.new()
		if RNG.randi_range(1,2) == 1:
			$AnimatedSprite2D.play("attack")
		else:
			$AnimatedSprite2D.play("attack_2")
		$AudioStreamPlayer2D.play(0)
		await get_tree().create_timer(0.6).timeout # garante minimamente que 
		attacking = false						   # animação não seja substituida
		
# troca movimentação
func switch_animation(direction):
	if !is_on_floor():
		if velocity.y < 0:
			$AnimatedSprite2D.play("fall")
		else: 
			$AnimatedSprite2D.play("jump")
	else:
		if attacking:
			pass
		else:
			if direction != 0:
				$AnimatedSprite2D.play("walking")
			else:
				$AnimatedSprite2D.play("idle")
