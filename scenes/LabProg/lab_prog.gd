extends Node2D

signal new_area_entered(text : String, image : Texture2D)
signal disable_previous
signal talking
signal stop_talking
signal shake_camera(amount : float)

@export var camera : Camera2D
@export var bugs_scene : PackedScene

@export var title_area : String
@export var image : Texture2D
@export var collisionArea : CollisionShape2D
@export var next_wall_collision : CollisionShape2D

@onready var spawn_points: Node2D = $SpawnPoints

var bugs_counter : int = 6

func enter_new_area() -> void:
	emit_signal("new_area_entered", title_area, image)
	emit_signal("disable_previous")

func _on_creative_studio_disable_previous() -> void:
	next_wall_collision.disabled = false

func _on_area_detect_body_entered(body: Node2D) -> void:
	enter_new_area()
	var tween : Tween = create_tween()
	tween.tween_property(camera, "global_position:x", collisionArea.global_position.x, 0.3)

func _on_npc_ended_talking() -> void:
	emit_signal("stop_talking")
	for child in spawn_points.get_children():
		var bug_instance : CharacterBody2D = bugs_scene.instantiate()
		bug_instance.position = child.position
		bug_instance.connect("mob_death", _on_mob_death)
		add_child(bug_instance)
		await get_tree().create_timer(1.0).timeout

func _on_mob_death() -> void:
	bugs_counter -= 1
	emit_signal("shake_camera", 10.0)
	if bugs_counter <= 0:
		next_wall_collision.set_deferred("disabled", true)

func _on_hall_of_fame_disable_previous() -> void:
	next_wall_collision.set_deferred("disabled", false)

func _on_npc_start_talking() -> void:
	emit_signal("talking")
