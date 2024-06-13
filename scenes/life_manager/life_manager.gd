extends Node2D

# Variável para armazenar a quantidade de vidas
var lives = 3

func decrease_lives():
	lives -= 1
	print_debug("vidas: ",lives)
	if lives <= 0:
		game_over()

func reset_lives():
	lives = 3

func game_over():
	# Exibir a tela de game over ou realizar outra ação
	print("Game Over!")
	get_tree().quit()
