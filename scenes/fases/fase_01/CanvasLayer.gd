extends CanvasLayer

# Referência para o nó RichTextLabel que exibe o placar
@onready var score_label: RichTextLabel = $RichTextLabel

func _ready():
	# Conectar o sinal de atualização do placar do GameManager
	ScoreManager.connect("player_score_updated", _on_player_score_updated)

func _on_player_score_updated(new_score: int):
	# Atualizar o texto do RichTextLabel com o novo placar
	score_label.bbcode_text = "[font=res://fonts/MyFont.ttf]Placar: %d[/font]" % new_score
