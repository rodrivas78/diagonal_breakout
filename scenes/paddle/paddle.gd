extends StaticBody2D


# Movimento do Paddle
var velocidade_do_paddle : float = 700.0
var x_minimo : float = 45	# 0 => 0 + (90 / 2)
var x_maximo : float = 755	# 800 => 800 - (90 / 2)


func _process(delta):
	movimentar_paddle(delta)
	limitar_movimento_do_paddle()


func movimentar_paddle(delta : float) -> void:
	# Movimenta o Paddle para Esquerda/Direita
	if Input.is_action_pressed("mv-esquerdo"):
		position.x -= velocidade_do_paddle * delta

	elif Input.is_action_pressed("mv-direito"):
		position.x += velocidade_do_paddle * delta


func limitar_movimento_do_paddle() -> void:
	# Impede que o Paddle saia da tela
	position.x = clamp(position.x, x_minimo, x_maximo)
