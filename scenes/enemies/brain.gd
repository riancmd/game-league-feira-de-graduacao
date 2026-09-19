extends EnemyBase

signal brain_boss_defeated

@export var projectile_scene: PackedScene
@export var projectile_text : Array[String]
@export var player : CharacterBody2D
@export var projectiles_holder: Node2D
@export var cooldown_timer : Timer
@export var movement_component: FloatingMovementComponent

func setup(player_reference: CharacterBody2D, holder_reference: Node2D) -> void:
	player = player_reference
	projectiles_holder = holder_reference

func _physics_process(delta: float) -> void:
	movement_component.physics_update(delta)

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
	if anim_name != &"spawn":
		return
	movement_component.activate()
	_on_cool_down_timer_timeout()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_dead:
		queue_free()
