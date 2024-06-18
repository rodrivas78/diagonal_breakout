extends Node

# Variáveis para armazenar o placar do jogador
var player_score = 0
@onready var current_scene_name = get_tree().current_scene.name
@onready var score_label = get_node("/root/"+current_scene_name)

# Função para aumentar o placar do jogador
func increase_player_score(amount: int = 1):
	player_score += amount
	emit_signal("player_score_updated", player_score)

# Sinal para notificar outras partes do jogo sobre a atualização do placar
signal player_score_updated(new_score)

func startScore():
	var start_score: int = 10
	score_label.bbcode_text = "[font=res://fonts/digital-7-italic.ttf][font_size=42][color=#75ef63]%d[/color][/font_size][/font]" % start_score
	 
