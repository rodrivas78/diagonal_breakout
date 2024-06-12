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

@onready var barra_verde = get_node("/root/Fase01/greenBar")
@onready var barra_amarela = get_node("/root/Fase01/yellowBar")
@onready var barra_vermelha = get_node("/root/Fase01/redBar")
@onready var game_manager = get_node("/root/"+current_scene_name+"/GameManager")
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
	#var my_sprite = get_node(VerdePeq)
	# Se a Bola estiver dentro da tela, a rebate ao colidir com as bordas
	if position.y <= y_maximo:
		if position.y <= y_minimo:
			som_impacto_tela.play()
			nova_direcao.y *= -1
			impact_count += 1
			print_debug("impact count: ", impact_count)
		
		if position.x <= x_minimo or position.x >= x_maximo:
			som_impacto_tela.play()
			nova_direcao.x *= -1
			impact_count += 1
			print_debug("impact count: ", impact_count)
			
		if impact_count > max_impacts:
			caiu_da_tela = true
			game_manager.perde_uma_vida()
			# Reset the impact count
			impact_count = 0
	
	# Se a Bola cair da tela
	if position.y > y_maximo and not caiu_da_tela:
		som_bola_off.play()
		timer_da_bola.start()
		caiu_da_tela = true
		game_manager.perde_uma_vida()
		impact_count = 0


func sair_da_tela() -> void:
	# Para o movimento da Bola e reseta sua posição
	nova_direcao = Vector2(0, 0)
	primeiro_lancamento = true
	resetar_bola()
	impact_count = 0


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
