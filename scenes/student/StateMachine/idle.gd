extends State
class_name IdleState

# Preenche a função "enter" do molde.
# Idle é um estado "terrestre", por isso reiniciamos o contador de pulos
# Executamos ações que só precisam ser feitas uma vez como animações.
func enter() -> void:
	player.anim.play("idle")
	player.movement_component.reset_jump_count()

# Preenche a função "handle_input" do molde.
# Aqui armazenamos o pulo, não porque o jogador está caindo, 
# mas para evitar desincronia com physics_update
func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		player.jump_buffer_component.start()
	if event.is_action_pressed("attack"):
		return get_state(&"attack")
	
	return null

# Preenche a função "physics_update" do molde.
func physics_update(delta: float) -> State:
	# Checa se o jogador está apertando para alguma direção
	var input_axis : float = Input.get_axis("left", "right")
	# Aplica o jogador para de se mover
	player.movement_component.move_horizontal(delta, 0.0)
	
	# 1. Checa a ação de maior prioridade: PULAR
	if player.movement_component.can_jump() and player.jump_buffer_component.is_active():
		player.jump_buffer_component.stop()
		return get_state(&"jump")
	
	# 2. Se não for pular, checa a segunda ação mais ativa: ANDAR
	if input_axis != 0 and player.is_on_floor():
		return get_state(&"walk")
	
	# 3. Se não for pular nem andar, checa uma transição reativa: CAIR
	if player.velocity.y > 0:
		return get_state(&"fall")
	
	# 4. Se NENHUMA das condições acima for atendida, não faz nada.
	return null
