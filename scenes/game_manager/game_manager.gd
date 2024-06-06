extends Node2D


# Controle dos Blocos
@export_group("Controle dos Blocos")
@export var blocos : Node2D
var blocos_na_fase : int = 0

# Passar de Fase
@export_group("Passar de Fase")
@export var proxima_fase : String
@onready var timer_do_passar_de_fase : Timer = $TimerDoPassarDeFase

#Controle dos bumpers
@export_group("Controle dos Bumpers")
@export var diagonalA : Node2D
@export var diagonalB : Node2D
var iX : int = 1
var iY : int = 1 
@export var yPosition = [184, 298, 412]
@export var xPosition = [211, 401, 595]
@export var jump_positions = Vector2i(xPosition[iX], yPosition[iY])
var current_jump_index = 0

# Limites da Bola
#x_minimo : float = 0
var x_offset : float = 100.0
#var y_minimo : float = 0
var y_offset : float = 100.0
var newPosition : float = 0.0

# Make the object visible
#meu_objeto.deactivate()
#my_object.activate()

func _ready():
	buscar_blocos()


func _process(delta):
	receber_inputs()
	

func receber_inputs() -> void:
	# Reinicia a fase
	jump_positions = Vector2i(xPosition[iX], yPosition[iY])
	diagonalA.position = jump_positions
	diagonalB.position = jump_positions
	if Input.is_action_just_pressed("reiniciar"):
		get_tree().reload_current_scene()
	# Sai do jogo
	if Input.is_action_just_pressed("sair"):
		get_tree().quit()
	#alterna rebatedores
	# Verifique se a tecla "espaço" foi pressionada
	if Input.is_action_just_pressed("shift-paddle"):
		diagonalA.visible = !diagonalA.visible
		diagonalB.visible = !diagonalB.visible
		
	# movimenta os paddles
	if Input.is_action_just_pressed("mv-esquerdo"):
		if iX > 0:
			iX -= 1
			
	elif Input.is_action_just_pressed("mv-direito"):
		if iX < 2:
			iX += 1
			
	elif Input.is_action_just_pressed("mv-baixo"):
		if iY < 2:
			iY += 1
			
	elif Input.is_action_just_pressed("mv-cima"):
		if iY > 0:
			iY -= 1	
						
	#TODO - Definir a posição inicial dos paddles
	#TODO - e movimentos para cima e para baixo. 
	
func buscar_blocos() -> void:
	# Conta quantos Blocos há na fase
	for bloco in blocos.get_children():
		blocos_na_fase += 1


func atualizar_contagem_dos_blocos() -> void:
	# Remove um Bloco da contagem e, SE não tiver mais nenhum, inicia o passar de fase
	blocos_na_fase -= 1
	if blocos_na_fase <= 0:
		timer_do_passar_de_fase.start()


func _on_timer_do_passar_de_fase_timeout():
	# Carrega a próxima fase
	get_tree().change_scene_to_file(proxima_fase)

# Posiciona o objeto na próxima posição de destino
#func jump_to_next_position():
	## Verifica se há mais posições de destino
	#if current_jump_index < jump_positions.size():
		## Move o objeto para a nova posição
		#position = jump_positions[current_jump_index]
		#current_jump_index += 1
	#else:
		## Volta para a primeira posição
		#current_jump_index = 0
		#position = jump_positions[current_jump_index]
	
		
