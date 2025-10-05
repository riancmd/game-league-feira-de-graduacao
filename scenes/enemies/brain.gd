extends CharacterBody2D

signal boss_defeated

@export var projectile_scene: PackedScene
@export var projectile_text : Array[String]
@export var player : CharacterBody2D
@export var cooldown_timer : Timer

@export var speed : float = 50.0
@export var gravity : float = 800.0

var direction : Vector2 = Vector2.LEFT
var is_dead: bool = false

@export var animated_sprite: AnimatedSprite2D
@export var ledge_checker_01: RayCast2D
@export var ledge_checker_02: RayCast2D

@export var hurtbox : Area2D
@export var collision : CollisionShape2D

@export var amp: float = 25.0 
@export var freq: float = 5.0

var time_passed : float = 0.0
var initial_pos_y : Vector2

func _ready() -> void:
	initial_pos_y = global_position

func _physics_process(delta: float) -> void:
	if is_dead: return
	
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

	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	is_dead = true
	collision.set_deferred("disabled", true)
	animated_sprite.play("hit")
	emit_signal("boss_defeated")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func _on_cool_down_timer_timeout() -> void:
	var projectile : Area2D = projectile_scene.instantiate()
	get_parent().add_child(projectile)

	projectile.global_position = self.global_position
	projectile.setup(projectile_text.pick_random(), player.global_position)
	
	cooldown_timer.start()
