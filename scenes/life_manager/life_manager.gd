extends Node2D


# Variável para armazenar a quantidade de vidas
@export var lives = 3
@onready var current_scene_name = get_tree().current_scene.name
@onready var bola_monitor = get_node("/root/"+current_scene_name+"/BolaMonitor")
@onready var bola_monitor2 = get_node("/root/"+current_scene_name+"/BolaMonitor2")
const SAVE_PATH = "res://scenes/save_data/game_state.tres"

func decrease_lives():
	lives -= 1
	print_debug("vidas: ",lives)
	if lives == 2:
		bola_monitor2.visible = false
	elif lives == 1:
		bola_monitor.visible = false
	elif lives <= 0:
		game_over()

func reset_lives():
	lives = 3

func game_over():
	# Exibir a tela de game over ou realizar outra ação
	print("Game Over!")
	get_tree().quit()
	
func save_state():
	# Salvar o estado do GameManager em um arquivo, banco de dados, etc.
	# Por exemplo, você pode usar o ResourceSaver para salvar em um arquivo
	ResourceSaver.save(lives, SAVE_PATH)

func load_state():
	# Carregar o estado do GameManager a partir de um arquivo, banco de dados, etc.
	# Por exemplo, você pode usar o ResourceLoader para carregar de um arquivo
	var saved_state = ResourceLoader.load("res://scenes/save_data/game_state.tres")
	lives = saved_state.lives	
