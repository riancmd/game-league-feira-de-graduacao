extends Area2D

signal start_talking
signal ended_talking

@export var talk_container : Control
@export var timeline_name : String 

var player_in_range : bool = false
var dialog

func _ready() -> void:
	Dialogic.connect("timeline_ended", _on_timeline_ended)

func _on_body_entered(_body: Node2D) -> void:
	player_in_range = true
	talk_container.show()

func _on_body_exited(_body: Node2D) -> void:
	player_in_range = false
	talk_container.hide()

func _unhandled_input(event: InputEvent) -> void:
	if not dialog and player_in_range and (event.is_action_pressed("down") or event.is_action_pressed("up")):
		Dialogic.start(timeline_name)
		emit_signal("start_talking")
		talk_container.hide()

func _on_timeline_ended(dialogue : String) -> void:
	if dialogue == timeline_name:
		emit_signal("ended_talking")
