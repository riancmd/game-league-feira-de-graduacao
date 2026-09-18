extends EnemyBase

signal brain_boss_defeated

@export var projectile_scene: PackedScene
@export var projectile_text : Array[String]
@export var player : CharacterBody2D
@export var projectiles_holder: Node2D
@export var cooldown_timer : Timer

@export var speed : float = 50.0
@export var gravity : float = 800.0

var direction : Vector2 = Vector2.LEFT

@export var animated_sprite: AnimatedSprite2D
@export var ledge_checker_01: RayCast2D
@export var ledge_checker_02: RayCast2D

@export var amp: float = 8.0 
@export var freq: float = 5.0

var time_passed : float = 0.0
var initial_pos_y : Vector2

func setup(player_reference: CharacterBody2D, holder_reference: Node2D) -> void:
	player = player_reference
	projectiles_holder = holder_reference

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

func on_died(source: HitboxComponent) -> void:
	emit_signal("brain_boss_defeated")
	cooldown_timer.stop()
	velocity.y = -300
	velocity.x = 100 * sign(global_position.x - source.get_source_position().x)

func _on_cool_down_timer_timeout() -> void:
	if not player or not projectiles_holder:
		return

	var projectile : Area2D = projectile_scene.instantiate()
	projectiles_holder.add_child(projectile)

	projectile.global_position = self.global_position
	projectile.setup(projectile_text.pick_random(), player.global_position)
	
	cooldown_timer.start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	initial_pos_y = global_position
	_on_cool_down_timer_timeout()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_dead:
		queue_free()
