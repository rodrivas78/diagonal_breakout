extends Node2D


# Controle dos Blocos
@export_group("Controle dos Blocos")
@export var blocos : Node2D
var blocos_na_fase : int = 0

# Passar de Fase
@export_group("Passar de Fase")
@export var proxima_fase : String
@onready var timer_do_passar_de_fase : Timer = $TimerDoPassarDeFase

@onready var current_scene_name = get_tree().current_scene.name

#Controle dos bumpers
@export_group("Controle dos Bumpers")
@export var diagonalA : Node2D
@export var diagonalB : Node2D
@export var verdePeq : Node2D
var iX : int = 1
var iY : int = 1 
@export var yPosition = [184, 298, 412]
@export var xPosition = [211, 401, 595]
@export var jump_positions = Vector2i(xPosition[iX], yPosition[iY])
var current_jump_index = 0

var stage_node
var timer_node


func _ready():
	buscar_blocos()
	manage_show_stage_number_timer()
	show_stage_number_sprite()


func _process(delta):
	receber_inputs()
	

func receber_inputs() -> void:
	# Reinicia a fase
	jump_positions = Vector2i(xPosition[iX], yPosition[iY])
	diagonalA.position = jump_positions
	diagonalB.position = jump_positions
	if Input.is_action_just_pressed("nextStage"):
		timer_do_passar_de_fase.start()
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
		ativa_ou_desativa_paddles()
		if get_tree().paused:
			get_tree().paused = false
		
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
						
	
func buscar_blocos() -> void:
	# Conta quantos Blocos há na fase
	for bloco in blocos.get_children():
		blocos_na_fase += 1

func atualizar_contagem_dos_blocos() -> void:
	# Remove um Bloco da contagem e, SE não tiver mais nenhum, inicia o passar de fase
	blocos_na_fase -= 1
	if blocos_na_fase <= 0:	
		timer_do_passar_de_fase.start()

#func pause_game_for_seconds(seconds):
#	get_tree().paused = true
#	await(get_tree().create_timer(seconds))
#	get_tree().paused = false

func _on_timer_do_passar_de_fase_timeout():
	# Carrega a próxima fase
	get_tree().change_scene_to_file(proxima_fase)
	
func ativa_ou_desativa_paddles() -> void:
	if diagonalA.visible == true:
		diagonalB.process_mode = Node.PROCESS_MODE_DISABLED
		diagonalA.process_mode = Node.PROCESS_MODE_ALWAYS
	elif diagonalB.visible == true:
		diagonalA.process_mode = Node.PROCESS_MODE_DISABLED
		diagonalB.process_mode = Node.PROCESS_MODE_ALWAYS

func manage_show_stage_number_timer():
	timer_node = get_node("/root/"+current_scene_name+"/GameManager/Timer")
	timer_node.connect("timeout", _on_timer_timeout)
	
func show_stage_number_sprite():
	var scene_name = get_tree().current_scene.name
	var scene_number_str = scene_name.trim_prefix("Fase")
	stage_node = get_node("/root/" + scene_name + "/Stage" + scene_number_str)
	stage_node.visible = true
	# Inicia um temporizador de 3 segundos
	timer_node.start(3.0)

func _on_timer_timeout():
	print_debug("entrou no temporizador: ")
	stage_node.visible = false

