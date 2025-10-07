extends Area2D

signal start_talking
signal ended_talking

@export var talk_container : Control
@export var timeline_name : String 

var player_in_range : bool = false
var dialog : bool = false

var talked : bool = false

func _ready() -> void:
	Dialogic.connect("signal_event", _on_dialogic_signal)

func _process(delta: float) -> void:
	match timeline_name:
		"01_game_design":
			$AnimatedSprite2D.play("gui")
		"02_pixelarium":
			$AnimatedSprite2D.play("giulia")
		"03_labprog":
			$AnimatedSprite2D.play("joão")
		"04_hall":
			$AnimatedSprite2D.play("julia")

func _on_body_entered(_body: Node2D) -> void:
	if talked: return
	player_in_range = true
	talk_container.show()

func _on_body_exited(_body: Node2D) -> void:
	player_in_range = false
	talk_container.hide()

func _unhandled_input(event: InputEvent) -> void:
	if not talked and not dialog and player_in_range and (event.is_action_pressed("down") or event.is_action_pressed("up")):
		Dialogic.start(timeline_name)
		emit_signal("start_talking")
		talk_container.hide()
		dialog = true
		talked = true

func _on_dialogic_signal(argument : String) -> void:
	if argument == timeline_name:
		emit_signal("ended_talking")
		print(argument)
