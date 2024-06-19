extends Node

# Variáveis para armazenar o placar do jogador
var player_score = 0

# Função para aumentar o placar do jogador
func increase_player_score(amount: int = 1):
	player_score += amount
	emit_signal("player_score_updated", player_score)

# Sinal para notificar outras partes do jogo sobre a atualização do placar
signal player_score_updated(new_score)
