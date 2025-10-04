extends CharacterBody2D

@export var speed: float = 50.0
var dir = 1
@export var walkLen = 270
var initPos_x # guarda de onde ele começa

func _ready() -> void:
	initPos_x = global_position.x # onde foi colocado na cena

func _physics_process(delta: float) -> void:
	velocity.x = speed * dir
	
	# anda pra direita, mas se chegar no limite
	if dir == 1 && global_position.x >= initPos_x + walkLen:
		dir = -1
		$AnimatedSprite2D.flip_h
	elif dir == -1 && global_position.x <= initPos_x:
		dir = 1
		$AnimatedSprite2D.flip_h
		
	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if $"../student".attacking:
		$AnimatedSprite2D.play("hit")
		await get_tree().create_timer(0.5).timeout
		queue_free()
