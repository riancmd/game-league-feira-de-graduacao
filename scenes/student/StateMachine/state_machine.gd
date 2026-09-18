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
			child.state_machine = self
	
	# Inicia no estado inicial definido no Inspetor (variável exportada)
	if initial_state:
		current_state = initial_state
		current_state.enter()

# Apenas repassa o input para o estado que estiver ativo
func _on_input(event: InputEvent) -> void:
	if not current_state:
		return
	var new_state = current_state.handle_input(event)
	if new_state: transition_to(new_state)

# Apenas repassa o update de física para o estado que estiver ativo
func _on_physics_update(delta: float) -> void:
	if not current_state:
		return
	var new_state = current_state.physics_update(delta)
	if new_state: transition_to(new_state)


func get_state(state_name: StringName) -> State:
	var normalized_name := String(state_name).to_lower()
	var state := states.get(normalized_name) as State
	if not state:
		push_error("Unknown state '%s' in %s" % [state_name, get_path()])
	return state


func transition_to_named(state_name: StringName) -> void:
	transition_to(get_state(state_name))

# A mágica da transição acontece aqui
func transition_to(new_state : State) -> void:
	if not new_state:
		return
	if current_state: current_state.exit()
	previous_state = current_state
	current_state = new_state
	current_state.enter()
