extends Node
class_name StateMachine

@export var initial_state : State

var previous_state : State
var current_state : State
var states : Dictionary = {}

# Ao iniciar, ele encontra todos os estados filhos e os prepara.
func _ready() -> void:
	for child in get_children():
		if child is State:
			# Adiciona o estado a um dicionário para acesso fácil
			states[child.name.to_lower()] = child
			# Injeta a referência do Player em cada estado
			child.player = get_parent()
	
	# Inicia no estado inicial definido no Inspetor (variável exportada)
	if initial_state:
		current_state = initial_state
		current_state.enter()

# Apenas repassa o input para o estado que estiver ativo
func _on_input(event: InputEvent) -> void:
	var new_state = current_state.handle_input(event)
	if new_state: transition_to(new_state)

# Apenas repassa o update de física para o estado que estiver ativo
func _on_physics_update(delta: float) -> void:
	var new_state = current_state.physics_update(delta)
	if new_state: transition_to(new_state)

# A mágica da transição acontece aqui
func transition_to(new_state : State) -> void:
	if current_state: current_state.exit()
	previous_state = current_state
	current_state = new_state
	current_state.enter()
