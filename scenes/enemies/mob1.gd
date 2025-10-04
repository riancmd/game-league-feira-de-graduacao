extends CharacterBody2D

# movimentação
@export var speed: float = 50.0
var dir = 1
@export var walkLen = 270
var initPos_x # guarda de onde ele começa

# estado
var hurting = false # nesse caso, é se estiver num estado "pré-machucado"

func _ready() -> void:
	initPos_x = global_position.x # onde foi colocado na cena
	hurting = false

func _physics_process(delta: float) -> void:
	if hurting && $"../student".attacking: # só morre se jogador tiver atacado mesmo
		$AnimatedSprite2D.play("hit")
		await get_tree().create_timer(0.5).timeout
		queue_free()
		
	velocity.x = speed * dir
	
	# anda pra direita, mas se chegar no limite volta
	if dir == 1 && global_position.x >= initPos_x + walkLen:
		dir = -1
		$AnimatedSprite2D.flip_h
	elif dir == -1 && global_position.x <= initPos_x:
		dir = 1
		$AnimatedSprite2D.flip_h
		
	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	hurting = true
	
func _on_hurtbox_area_exited(area: Area2D) -> void:
	hurting = false
