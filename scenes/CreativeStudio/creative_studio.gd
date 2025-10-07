extends Node2D

signal new_area_entered(text : String, image : Texture2D)
signal disable_previous
signal talking
signal stop_talking
signal shake_camera(amount : float)

@export var brain_boss_scene : PackedScene
@export var player : CharacterBody2D

@export var title_area : String
@export var image : Texture2D

@export var next_wall : CollisionShape2D

@export var camera : Camera2D
@onready var collisionArea : CollisionShape2D = $AreaDetect/CollisionShape2D

@export var markers : Array[Marker2D]
@export var text_platform : PackedScene
@onready var npc: Area2D = $NPC
@export var texts_for_platformers : Array[String]
@onready var cool_down_timer: Timer = $CoolDown_Timer
@onready var platformers_holder: Node2D = $Platformers_Holder
@onready var projectiles_holder: Node2D = $Projectiles_Holder

var boss_is_dead : bool = false

func enter_new_area() -> void:
	emit_signal("new_area_entered", title_area, image)
	emit_signal("disable_previous")

func _on_area_detect_body_entered(body: Node2D) -> void:
	enter_new_area()
	var tween : Tween = create_tween()
	tween.tween_property(camera, "global_position:x", collisionArea.global_position.x, 0.3)

func _on_npc_ended_talking() -> void:
	emit_signal("stop_talking")
	
	var brain_boss_instance : CharacterBody2D = brain_boss_scene.instantiate()
	brain_boss_instance.setup(player)
	brain_boss_instance.connect("brain_boss_defeated", _on_brain_boss_defeated)
	add_child(brain_boss_instance)
	cool_down_timer.start()

func _on_brain_boss_defeated() -> void:
	boss_is_dead = true
	emit_signal("shake_camera", 30.0)
	for child in platformers_holder.get_children():
		child.queue_free()
	
	for child in projectiles_holder.get_children():
		child.queue_free()
	$Arrow_Go.show()
	next_wall.set_deferred("disabled", true)

func _on_cool_down_timer_timeout() -> void:
	if markers.size() > 0 and not boss_is_dead:
		var marker_selected : Marker2D = markers.pop_front()
		var platform_instance : AnimatableBody2D = text_platform.instantiate()
		platform_instance.setup(npc.global_position, marker_selected.global_position, texts_for_platformers.pop_front())
		platformers_holder.add_child(platform_instance)
		cool_down_timer.start()

func _on_pixelarium_disable_previous() -> void:
	next_wall.set_deferred("disabled", false)

func _on_npc_start_talking() -> void:
	emit_signal("talking")
