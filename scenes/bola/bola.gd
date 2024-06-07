extends Area2D


# Referências Gerais
@onready var timer_da_bola : Timer = $TimerDaBola
@onready var som_impacto_bloco : AudioStreamPlayer = $SomImpactoBloco
@onready var som_impacto_paddle : AudioStreamPlayer = $SomImpactoPaddle
@onready var som_impacto_tela : AudioStreamPlayer = $SomImpactoTela

# Movimento da Bola
var velocidade_da_bola : float = 400.0
var posicao_inicial : Vector2 = Vector2(403, 500)
var direcao_inicial : Vector2 = Vector2(0, 0)
var nova_direcao : Vector2 = Vector2(0, 0)

# Limites da Bola
var x_minimo : float = 0
var x_maximo : float = 800
var y_minimo : float = 0
var y_maximo : float = 600

# Verificações
var primeiro_lancamento : bool = true
var caiu_da_tela : bool = false


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
	# Se a Bola estiver dentro da tela, a rebate ao colidir com as bordas
	if position.y <= y_maximo:
		if position.y <= y_minimo:
			som_impacto_tela.play()
			nova_direcao.y *= -1
		
		if position.x <= x_minimo or position.x >= x_maximo:
			som_impacto_tela.play()
			nova_direcao.x *= -1
	
	# Se a Bola cair da tela
	if position.y > y_maximo and not caiu_da_tela:
		timer_da_bola.start()
		caiu_da_tela = true


func sair_da_tela() -> void:
	# Para o movimento da Bola e reseta sua posição
	nova_direcao = Vector2(0, 0)
	primeiro_lancamento = true
	resetar_bola()


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
