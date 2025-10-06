extends Node2D

signal new_area_entered(text : String, image : Texture2D)
signal disable_previous
signal talking
signal stop_talking

@export var camera : Camera2D

@export var title_area : String
@export var image : Texture2D
@export var collisionArea : CollisionShape2D
@export var next_wall_collision : CollisionShape2D

@export var clock_scene : PackedScene
@export var platformers : Node2D

func enter_new_area() -> void:
	emit_signal("new_area_entered", title_area, image)
	emit_signal("disable_previous")

func _on_creative_studio_disable_previous() -> void:
	next_wall_collision.disabled = false

func _on_area_detect_body_entered(body: Node2D) -> void:
	enter_new_area()
	var tween : Tween = create_tween()
	tween.tween_property(camera, "global_position:x", collisionArea.global_position.x, 0.3)

func _on_tic_tac(is_tic_blue : bool) -> void:
	for child in platformers.get_children():
		child._on_rhythm_tick(is_tic_blue)

func _on_clock_defeated() -> void:
	for child in platformers.get_children():
		child.queue_free()
	
	next_wall_collision.set_deferred("disabled", true)

func _on_npc_ended_talking() -> void:
	emit_signal("stop_talking")
	
	var clock_instance : CharacterBody2D = clock_scene.instantiate()
	clock_instance.connect("tic_tac", _on_tic_tac)
	clock_instance.connect("clock_boss_defeated", _on_clock_defeated)
	platformers.show()
	add_child(clock_instance)

func _on_lab_prog_disable_previous() -> void:
	next_wall_collision.set_deferred("disabled", false)

func _on_npc_start_talking() -> void:
	emit_signal("talking")
