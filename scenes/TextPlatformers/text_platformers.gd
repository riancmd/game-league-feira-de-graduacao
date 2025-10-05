extends AnimatableBody2D

@export var move_duration: float = 1.5
@export var initial_pos : Vector2
@export var target_position_marker: Vector2

@export var label : Label

var text_label : String
var has_activated: bool = false

func setup(initial_pos : Vector2, pos : Vector2, text : String) -> void:
	self.initial_pos = initial_pos
	self.target_position_marker = pos
	self.text_label = text

func _ready() -> void:
	global_position = initial_pos
	label.text = text_label

func activate() -> void:
	if has_activated:
		return
	has_activated = true

	var tween = create_tween()
	tween.tween_property(self, "global_position", target_position_marker, move_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	activate()
