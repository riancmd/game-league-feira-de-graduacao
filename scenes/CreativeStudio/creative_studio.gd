extends RoomController

signal shake_camera(amount : float)

@export var brain_boss_scene : PackedScene
@export var player : CharacterBody2D

@export var markers : Array[Marker2D]
@export var text_platform : PackedScene
@onready var npc: Area2D = $NPC
@export var texts_for_platformers : Array[String]
@onready var cool_down_timer: Timer = $CoolDown_Timer
@onready var platformers_holder: Node2D = $Platformers_Holder
@onready var projectiles_holder: Node2D = $Projectiles_Holder

var boss_is_dead : bool = false
var next_platform_index : int = 0

func _on_area_detect_body_entered(_body: Node2D) -> void:
	enter_room()

func _on_npc_ended_talking() -> void:
	finish_dialogue()
	
	var brain_boss_instance : CharacterBody2D = brain_boss_scene.instantiate()
	brain_boss_instance.setup(player, projectiles_holder)
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
	complete_room()

func _on_cool_down_timer_timeout() -> void:
	var available_platforms := mini(markers.size(), texts_for_platformers.size())
	if next_platform_index < available_platforms and not boss_is_dead:
		var marker_selected : Marker2D = markers[next_platform_index]
		var platform_instance : AnimatableBody2D = text_platform.instantiate()
		platform_instance.setup(
			npc.global_position,
			marker_selected.global_position,
			texts_for_platformers[next_platform_index]
		)
		platformers_holder.add_child(platform_instance)
		next_platform_index += 1
		cool_down_timer.start()

func _on_npc_start_talking() -> void:
	start_dialogue()
