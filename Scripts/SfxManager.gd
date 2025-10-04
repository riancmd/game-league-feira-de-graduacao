extends Node

const JUMP = preload("res://sounds/sfx/jump.wav")
const SWORD_SFX = preload("res://sounds/sfx/sword_sfx.mp3")
const ITEM_PICKUP = preload("res://sounds/sfx/item_pickup.wav")

func play_sfx(sfx_name : String) -> void:
	var asp : AudioStreamPlayer = AudioStreamPlayer.new()
	
	match sfx_name:
		"sword":
			asp.stream = SWORD_SFX
		"item_pickup":
			asp.stream = ITEM_PICKUP
		"jump":
			asp.stream = JUMP
	
	add_child(asp)
	asp.play()
	await asp.finished
	asp.queue_free()
