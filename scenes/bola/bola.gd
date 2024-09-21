extends Area2D


# Referências Gerais
@onready var timer_da_bola : Timer = $TimerDaBola
@onready var som_impacto_bloco : AudioStreamPlayer = $SomImpactoBloco
@onready var som_impacto_paddle : AudioStreamPlayer = $SomImpactoPaddle
@onready var som_impacto_tela : AudioStreamPlayer = $SomImpactoTela
@onready var som_bola_off : AudioStreamPlayer = $SomBolaOff
@onready var som_game_over : AudioStreamPlayer = $SomGameOver
@onready var game_over_music : AudioStreamPlayer = $GameOverMusic

@onready var current_scene_name = get_tree().current_scene.name

@onready var ball = get_node("/root/"+current_scene_name+"/Bola")
@onready var game_manager = get_node("/root/"+current_scene_name+"/GameManager")
@onready var barra_verde = get_node("/root/"+current_scene_name+"/greenBar")
@onready var barra_amarela = get_node("/root/"+current_scene_name+"/yellowBar")
@onready var barra_vermelha = get_node("/root/"+current_scene_name+"/redBar")
@onready var bola_monitor = get_node("/root/"+current_scene_name+"/BolaMonitor")
@onready var bola_monitor2 = get_node("/root/"+current_scene_name+"/BolaMonitor2")
@onready var watch_out = get_node("/root/"+current_scene_name+"/WatchOut")
@onready var game_over = get_node("/root/"+current_scene_name+"/GameOver")

# Movimento da Bola
var velocidade_da_bola : float = 400.0
var posicao_inicial : Vector2 = Vector2(403, 500)
var direcao_inicial : Vector2 = Vector2(0, 0)
var nova_direcao : Vector2 = Vector2(0, 0)
var hasDied : bool = false
var shoudIncreaseLevel: bool = true
var turnOnFadeOut = false

# Limites da Bola
var x_minimo : float = 0
var x_maximo : float = 800
var y_minimo : float = 0
var y_maximo : float = 600

# Verificações
var primeiro_lancamento : bool = true
var caiu_da_tela : bool = false
var impact_count = 0
var max_impacts = 2


func _ready():
	timer_da_bola.one_shot = true
	resetar_bola()
	update_lives_monitor()
	update_level()
	

func _process(delta):
	# Se for o primeiro lançamento, esperar a ação do Jogador para lançar
	if primeiro_lancamento:
		if Input.is_action_just_pressed("lancar-bola"):
			escolher_direcao_inicial()
			primeiro_lancamento = false
			
	movimentar_bola(delta)
	verificar_posicao_da_bola()
	set_music_fade_out()
	
	
func resetar_bola() -> void:
	# Posiciona a Bola acima do Paddle
	if GlobalData.lives <= 0:
		ball.visible = false
	position = posicao_inicial
	

func escolher_direcao_inicial() -> void:
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
		
		if position.x <= x_minimo or position.x >= x_maximo:
			som_impacto_tela.play()
			nova_direcao.x *= -1
			change_bar_on_impact()
	
	# Se a Bola cair da tela
	if position.y > y_maximo and not caiu_da_tela:
		GlobalData.decrease_lives()
		hasDied = true
		update_lives_monitor()
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
			watch_out.visible = true
			await get_tree().create_timer(2.0).timeout
			watch_out.visible = false
		3:
			barra_vermelha.visible = false
			GlobalData.decrease_lives()
			som_bola_off.play()
			hasDied = true
			update_lives_monitor()
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
		ScoreManager.increase_player_score(10)
		body.receber_dano()
		nova_direcao *= -1

func _on_timer_da_bola_timeout():
	sair_da_tela()
	caiu_da_tela = false	

func update_lives_monitor():
	match GlobalData.lives:
		2:
			bola_monitor2.visible = false
		1:
			bola_monitor2.visible = false
			bola_monitor.visible = false
		0:
			watch_out.visible = false
			gameOver()
			
func update_level():
	#print_debug("LEVEL: ", GlobalData.level)
	#print_debug("Stage Counter: ", GlobalData.stageCounter)
	if (current_scene_name == "Fase10" || current_scene_name == "Fase03" && GlobalData.stageCounter > 1):
		if (GlobalData.shouldIncreaseLevel):
			GlobalData.increase_level()
		#print_debug("LEVEL: ", GlobalData.level)	
	match GlobalData.level:
		1:
			velocidade_da_bola = 400.0
		2:
			velocidade_da_bola = 500.0
		3:
			velocidade_da_bola = 600.0
		4:
			velocidade_da_bola = 700.0
		5:
			velocidade_da_bola = 800.0
		6:
			velocidade_da_bola = 900.0
		7:
			velocidade_da_bola = 1000.0
		8: 
			velocidade_da_bola = 1100.0
		9: 
			velocidade_da_bola = 1200.0	
		10:
			velocidade_da_bola = 1300.0
	if (GlobalData.level > 10):
		velocidade_da_bola = 1400.0
	#print_debug("velocidade_bola: ", velocidade_da_bola)

func gameOver():
	# Exibir a tela de game over ou realizar outra ação
	await get_tree().create_timer(1.0).timeout
	som_game_over.play()
	game_over.visible = true
	velocidade_da_bola = 0.0
	
	await get_tree().create_timer(2.0).timeout
	game_manager.gameOver = true
	game_over_music.play()

func set_music_fade_out() -> void:
	# Diminui o volume da música em 1 dB a cada intervalo de tempo
	if (turnOnFadeOut):
		game_over_music.set_volume_db(game_over_music.volume_db - 0.3)
		if game_over_music.volume_db <= -80:
			game_over_music.stop()
