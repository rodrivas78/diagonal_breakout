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
@onready var score_label = get_node("/root/"+current_scene_name+"/CanvasLayer2")
@onready var barra_verde = get_node("/root/"+current_scene_name+"/greenBar")
@onready var barra_amarela = get_node("/root/"+current_scene_name+"/yellowBar")
@onready var perfect = get_node("/root/"+current_scene_name+"/Perfect")
@onready var watch_out = get_node("/root/"+current_scene_name+"/WatchOut")
@onready var nice = get_node("/root/"+current_scene_name+"/Nice")
@onready var bonus_25 = get_node("/root/"+current_scene_name+"/25")
@onready var bonus_50 = get_node("/root/"+current_scene_name+"/50")
@onready var no_bonus = get_node("/root/"+current_scene_name+"/NoBonus")
@onready var ball = get_node("/root/"+current_scene_name+"/Bola")
@onready var level_label = get_node("/root/"+current_scene_name+"/CanvasLayer3")
#@onready var level_number = get_node("/root/"+current_scene_name+"/Level_num")

@onready var black_overlay = get_node("/root/"+current_scene_name+"/BkOverlay")
@onready var continue_yn = get_node("/root/"+current_scene_name+"/ContinueYN")
@onready var yes_selector = get_node("/root/"+current_scene_name+"/YesSelector")
@onready var no_selector = get_node("/root/"+current_scene_name+"/NoSelector")

var title_screen : String = "res://scenes/title_screen/TitleScreen.tscn"

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

@onready var select : AudioStreamPlayer = $SomSelector
@onready var selected : AudioStreamPlayer = $SomChoosed
@onready var point_sound : AudioStreamPlayer = $SomBonusPoints
@onready var level_completed_sound : AudioStreamPlayer = $SomLevelCompleted
@onready var perfect_sound : AudioStreamPlayer = $SomPerfect

var stage_node
var stage_number
var timer_node
var score = 0
var gameOver = false
var firstTime = true
var counter = 0
var toggle = false
var turnOnFadeOut = false

	
func _ready():
	buscar_blocos()
	ativa_ou_desativa_paddles()
	manage_show_stage_number_timer()
	show_stage_number_sprite()
	show_level_eligibility()
	
func _process(delta):
	receber_inputs()
	
func receber_inputs() -> void:
	# Reinicia a fase
	jump_positions = Vector2i(xPosition[iX], yPosition[iY])
	diagonalA.position = jump_positions
	diagonalB.position = jump_positions
	if Input.is_action_just_pressed("nextStage"):
		print_debug("is_action_just_pressed(nextStage)")
		timer_do_passar_de_fase.start()
	if Input.is_action_just_pressed("reiniciar"):
		#TODO - Continue -> YES
		GlobalData.reset_lives()
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
						
	#todo - implementar gameOver
	if (gameOver):
		diagonalA.visible = false
		diagonalB.visible = false
		black_overlay.visible = true
		continue_yn.visible = true
		if (firstTime):
			yes_selector.visible = true
		if Input.is_action_just_pressed("shift-paddle"):
			match counter:
				0:  #continue
					selected.play()
					ball.turnOnFadeOut = true
					await get_tree().create_timer(2.0).timeout
					GlobalData.reset_lives()
					ScoreManager.reset_player_score()
					GlobalData.toggle_shouldIncreaseLevel(false)
					get_tree().reload_current_scene()
				1:  #nao continue 
					selected.play()
					ball.turnOnFadeOut = true
					await get_tree().create_timer(1.0).timeout
					get_tree().change_scene_to_file(title_screen)
		if Input.is_action_just_pressed("mv-direito"):
			toggle = true
			change_selector(toggle)
		elif Input.is_action_just_pressed("mv-esquerdo"):
			toggle = false
			change_selector(toggle)

func change_selector(toggle: bool) -> void:
	firstTime = false
	if (toggle):
		counter = 1
	else:
		counter = 0
	match counter:
		0:
			select.play()
			yes_selector.visible = true
			no_selector.visible = false
		1:
			select.play()
			yes_selector.visible = false
			no_selector.visible = true
	
func buscar_blocos() -> void:
	# Conta quantos Blocos há na fase
	for bloco in blocos.get_children():
		blocos_na_fase += 1

func atualizar_contagem_dos_blocos() -> void:
	# Remove um Bloco da contagem e, SE não tiver mais nenhum, inicia o passar de fase
	blocos_na_fase -= 1
	if blocos_na_fase <= 0 && barra_verde.visible && ball.hasDied == false:
		perfect_sound.play()
		perfect.visible = true
		ball.velocidade_da_bola = 0.0
		await get_tree().create_timer(1.0).timeout
		bonus_50.visible = true
		add_50_points()
	elif blocos_na_fase <= 0 && barra_amarela.visible && ball.hasDied == false:
		level_completed_sound.play()
		nice.visible = true
		ball.velocidade_da_bola = 0.0
		await get_tree().create_timer(1.0).timeout
		bonus_25.visible = true
		add_25_points()
	elif blocos_na_fase <= 0:
		ball.velocidade_da_bola = 0.0
		watch_out.visible = false
		no_bonus.visible = true
		await get_tree().create_timer(1.0).timeout
		timer_do_passar_de_fase.start()

# Método para adicionar 50 pontos ao placar, incrementando 1 ponto por vez
func add_50_points():
	# Inicialize o contador em 0
	score += 50
	# Incrementar o placar em 1 ponto até atingir 50 pontos
	for i in range(50):
		ScoreManager.increase_player_score(1)
		point_sound.play()
		await get_tree().create_timer(0.03).timeout
	if score >= 50:
		timer_do_passar_de_fase.start()
		
func add_25_points():
	# Inicialize o contador em 0
	score += 25
	# Incrementar o placar em 1 ponto até atingir 50 pontos
	for i in range(25):
		ScoreManager.increase_player_score(1)
		point_sound.play()
		# Faça uma pausa de 0,1 segundos entre cada incremento
		await get_tree().create_timer(0.03).timeout
	if score >= 25:
		timer_do_passar_de_fase.start()
		
	
func _on_timer_do_passar_de_fase_timeout():
	# Carrega a próxima fase
	GlobalData.increase_stageCounter()
	GlobalData.shouldIncreaseLevel = true
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
	score_label.visible = true
	timer_node.start(3.0)

func _on_timer_timeout():
	score_label.visible = false

func show_level_eligibility():
	if (current_scene_name == "Fase10" || current_scene_name == "Fase03"):
		show_level_label()
	
func show_level_label():
	black_overlay.visible = true
	level_label.visible = true
	await get_tree().create_timer(2.6).timeout
	black_overlay.visible = false
	level_label.visible = false

