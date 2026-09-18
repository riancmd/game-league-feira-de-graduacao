extends Node

const JUMP: AudioStream = preload("res://sounds/sfx/jump.mp3")
const SWORD: AudioStream = preload("res://sounds/sfx/sword_sfx.mp3")
const ITEM_PICKUP: AudioStream = preload("res://sounds/sfx/item_pickup.wav")
const TIC: AudioStream = preload("res://sounds/sfx/tic.mp3")
const TAC: AudioStream = preload("res://sounds/sfx/tac.mp3")

func play_sfx(stream: AudioStream) -> void:
	if not stream:
		push_warning("SfxManager received an empty AudioStream")
		return

	var audio_player := AudioStreamPlayer.new()
	audio_player.bus = &"SFX"
	audio_player.stream = stream
	add_child(audio_player)
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
