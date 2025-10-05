extends CharacterBody2D

signal clock_boss_defeated
signal tic_tac

@export var clock_timer : Timer

@export var speed : float = 150.0
@export var gravity : float = 800.0

var direction : Vector2 = Vector2.LEFT
var is_dead: bool = false

@export var animated_sprite: AnimatedSprite2D
@export var ledge_checker_01: RayCast2D
@export var ledge_checker_02: RayCast2D

@export var hurtbox : Area2D
@export var collision : CollisionShape2D

@export var amp: float = 15.0 
@export var freq: float = 5.0

var time_passed : float = 0.0
var initial_pos_y : Vector2

var is_tic_blue : bool = false

func _physics_process(delta: float) -> void:
	if not is_dead: 
		
		time_passed += delta
		
		var offset_y = sin(time_passed * freq) * amp
		var proxima_posicao_y = initial_pos_y.y + offset_y
		
		velocity.y = (proxima_posicao_y - global_position.y) / delta
		
		var left_has_ground = ledge_checker_01.is_colliding()
		var right_has_ground = ledge_checker_02.is_colliding()

		if left_has_ground and right_has_ground:
			velocity.x = 0
		elif direction.x < 0 and left_has_ground:
			direction = Vector2.RIGHT
		elif direction.x > 0 and right_has_ground:
			direction = Vector2.LEFT
		elif is_on_wall():
			direction *= -1

		velocity.x = direction.x * speed
	else:
		velocity.y += gravity * delta
	
	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if is_dead: return

	is_dead = true
	collision.set_deferred("disabled", true)
	clock_timer.stop()
	emit_signal("clock_boss_defeated")
	
	velocity.y = -300
	velocity.x = 100 * sign(global_position.x - area.get_owner().global_position.x)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	initial_pos_y = global_position
	_on_clock_timer_timeout()

func _on_clock_timer_timeout() -> void:
	emit_signal("tic_tac", is_tic_blue)
	is_tic_blue = not is_tic_blue
	clock_timer.start()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_dead:
		queue_free()
