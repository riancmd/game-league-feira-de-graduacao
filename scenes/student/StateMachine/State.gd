extends Node
class_name State

var player : CharacterBody2D # Referência do Player

# Método chamado uma vez ao ENTRAR no estado
# Ideal para iniciar animações, sons, etc.
func enter() -> void: 
	pass

# Método chamado uma vez ao SAIR do estado
# Ideal para limpar timers ou qualquer outro resquício.
func exit() -> void: 
	pass

# Chamada para lidar com evento de input do jogador.
# Ideal para ações de "apertar/soltar botão".
# Retorna um novo estado para transição, ou null para permanecer no estado atual.
func handle_input(_event : InputEvent) -> State:
	return null

# Chamada a cada frame de física.
# Ideal para lógica de movimento e checagens contínuas.
# Retorna um novo estado para transição, ou null para permanecer.
func physics_update(_delta : float) -> State:
	return null
