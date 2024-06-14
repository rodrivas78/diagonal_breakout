extends Area2D

#@export var verdePeq2 : Node2D
#@export var amareloPeq : Node2D

# Referências Gerais
@onready var timer_da_bola : Timer = $TimerDaBola
@onready var som_impacto_bloco : AudioStreamPlayer = $SomImpactoBloco
@onready var som_impacto_paddle : AudioStreamPlayer = $SomImpactoPaddle
@onready var som_impacto_tela : AudioStreamPlayer = $SomImpactoTela
@onready var som_bola_off : AudioStreamPlayer = $SomBolaOff

@onready var current_scene_name = get_tree().current_scene.name

@onready var barra_verde = get_node("/root/"+current_scene_name+"/greenBar")
@onready var barra_amarela = get_node("/root/"+current_scene_name+"/yellowBar")
@onready var barra_vermelha = get_node("/root/"+current_scene_name+"/redBar")
@onready var life_manager = get_node("/root/"+current_scene_name+"/LifeManager")
# Movimento da Bola
var velocidade_da_bola : float = 400.0
var posicao_inicial : Vector2 = Vector2(403, 500)
var direcao_inicial : Vector2 = Vector2(0, 0)
var nova_direcao : Vector2 = Vector2(0, 0)

# Limites da Bola
var x_minimo : float = 0
var x_maximo : float = 800
var y_minimo : float = 0
var y_maximo : float = 550

# Verificações
var primeiro_lancamento : bool = true
var caiu_da_tela : bool = false
var impact_count = 0
var max_impacts = 2


func _ready():
	timer_da_bola.one_shot = true
	resetar_bola()
	#life_manager.load_state()
	print_debug("vidas: ",life_manager.lives)

func _process(delta):
	# Se for o primeiro lançamento, esperar a ação do Jogador para lançar
	if primeiro_lancamento:
		if Input.is_action_just_pressed("lancar-bola"):
			escolher_direcao_inicial()
			primeiro_lancamento = false
			
	movimentar_bola(delta)
	verificar_posicao_da_bola()
	
	
func resetar_bola() -> void:
	# Posiciona a Bola acima do Paddle
	position = posicao_inicial
	

func escolher_direcao_inicial() -> void:
	# Escolhe uma nova direção Horizontal
	#var x_aleatorio = [-1, 1].pick_random()
	# Aplica a nova direção
	direcao_inicial = Vector2(0, -1)
	nova_direcao = direcao_inicial
	

func movimentar_bola(delta : float) -> void:
	# Movimenta a Bola com base em sua nova direção
	position += nova_direcao * velocidade_da_bola * delta
	

func verificar_posicao_da_bola() -> void:
	# Se a Bola estiver dentro da tela, a rebate ao colidir com as bordas
	if position.y <= y_maximo:
		if position.y <= y_minimo:
			som_impacto_tela.play()
			nova_direcao.y *= -1
			change_bar_on_impact()
			print_debug("impact count: ", impact_count)
		
		if position.x <= x_minimo or position.x >= x_maximo:
			som_impacto_tela.play()
			nova_direcao.x *= -1
			change_bar_on_impact()
			print_debug("impact count: ", impact_count)
	
	# Se a Bola cair da tela
	if position.y > y_maximo and not caiu_da_tela:
		life_manager.decrease_lives()
		#life_manager.save_state()
		som_bola_off.play()
		timer_da_bola.start()
		caiu_da_tela = true
		impact_count = 0
		
func change_bar_on_impact() -> void:
	impact_count += 1
	match impact_count:
		1: 
			barra_verde.visible = false
			barra_amarela.visible = true 		
		2: 
			barra_amarela.visible = false
			barra_vermelha.visible = true
		3:
			barra_vermelha.visible = false
			life_manager.decrease_lives()
			#life_manager.save_state()
			impact_count = 0
			sair_da_tela()
	

func sair_da_tela() -> void:
	# Para o movimento da Bola e reseta sua posição
	nova_direcao = Vector2(0, 0)
	primeiro_lancamento = true
	resetar_bola()
	impact_count = 0
	barra_verde.visible = true
	barra_vermelha.visible = false
	barra_amarela.visible = false


func _on_body_entered(body):
	# Se colidir com o Paddle, rebate
	if body.is_in_group("diagonal_a"):
		som_impacto_paddle.play()
		if nova_direcao == Vector2(0, -1):
			nova_direcao = Vector2(1, 0)
		elif nova_direcao == Vector2(0, 1):	
			nova_direcao = Vector2(-1, 0)
		elif nova_direcao == Vector2(-1, 0):	
			nova_direcao = Vector2(0, 1)
		elif nova_direcao == Vector2(1, 0):	
			nova_direcao = Vector2(0, -1)
			
	if body.is_in_group("diagonal_b"):
		som_impacto_paddle.play()
		if nova_direcao == Vector2(0, -1):
			nova_direcao = Vector2(-1, 0)
		elif nova_direcao == Vector2(0, 1):	
			nova_direcao = Vector2(1, 0)
		elif nova_direcao == Vector2(-1, 0):	
			nova_direcao = Vector2(0, -1)
		elif nova_direcao == Vector2(1, 0):	
			nova_direcao = Vector2(0, 1)
	
	# Se colidir com o Bloco, desconta sua vida e rebate
	if body.is_in_group("blocos"):
		som_impacto_bloco.play()
		body.receber_dano()
		nova_direcao *= -1


func _on_timer_da_bola_timeout():
	sair_da_tela()
	caiu_da_tela = false	
