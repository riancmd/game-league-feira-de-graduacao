extends Node

const JUMP = preload("res://sounds/sfx/jump.mp3")
const SWORD_SFX = preload("res://sounds/sfx/sword_sfx.mp3")
const ITEM_PICKUP = preload("res://sounds/sfx/item_pickup.wav")
const TIC = preload("res://sounds/sfx/tic.mp3")
const TAC = preload("res://sounds/sfx/tac.mp3")

func play_sfx(sfx_name : String) -> void:
	var asp : AudioStreamPlayer = AudioStreamPlayer.new()
	asp.bus = "SFX"
	match sfx_name:
		"sword":
			asp.stream = SWORD_SFX
		"item_pickup":
			asp.stream = ITEM_PICKUP
		"jump":
			asp.stream = JUMP
		"tic":
			asp.stream = TIC
		"tac":
			asp.stream = TAC
	
	add_child(asp)
	asp.play()
	await asp.finished
	asp.queue_free()
