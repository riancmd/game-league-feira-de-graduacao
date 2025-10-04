extends State
class_name IdleState

@onready var state_machine : Node = get_parent()

# Preenche a função "enter" do molde.
# Idle é um estado "terrestre", por isso reiniciamos o contador de pulos
# Executamos ações que só precisam ser feitas uma vez como animações.
func enter() -> void:
	player.anim.play("idle")
	player.reset_jump_count()

# Preenche a função "handle_input" do molde.
# Aqui armazenamos o pulo, não porque o jogador está caindo, 
# mas para evitar desincronia com physics_update
func handle_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		player.start_jump_buffer()
	if event.is_action_pressed("attack"):
		return state_machine.get_node("attack")
	
	return null

# Preenche a função "physics_update" do molde.
func physics_update(delta: float) -> State:
	# Checa se o jogador está apertando para alguma direção
	var input_axis : float = Input.get_axis("left", "right")
	# Aplica o jogador para de se mover
	player.move(delta, 0.0)
	
	# 1. Checa a ação de maior prioridade: PULAR
	if player.can_jump() and player.is_jump_buffering():
		player.stop_jump_buffer()
		return state_machine.get_node("jump")
	
	# 2. Se não for pular, checa a segunda ação mais ativa: ANDAR
	if input_axis != 0 and player.is_on_floor():
		return state_machine.get_node("walk")
	
	# 3. Se não for pular nem andar, checa uma transição reativa: CAIR
	if player.velocity.y > 0:
		return state_machine.get_node("fall")
	
	# 4. Se NENHUMA das condições acima for atendida, não faz nada.
	return null
