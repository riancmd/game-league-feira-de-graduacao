extends Area2D

@export var label : Label
@export var animation_player : AnimationPlayer
@export var speed : float = 150.0

var can_move : bool = false
var direction_to_player : Vector2 

func setup(text_content: String, player_position: Vector2) -> void:
	label.text = text_content

	direction_to_player = (player_position - global_position).normalized()

func _physics_process(delta: float) -> void:
	if not can_move: return
	
	position += direction_to_player * speed * delta

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	can_move = true
	modulate.a = 255

func _on_body_entered(body: Node2D) -> void:
	body.apply_knockback(global_position)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
