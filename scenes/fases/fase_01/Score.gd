extends CanvasLayer

# Referência para o nó RichTextLabel que exibe o placar
@onready var score_label: RichTextLabel = $RichTextLabel
var updated_score = 0
var hi_score = 0

func _ready():
	# Conectar o sinal de atualização do placar do ScoreManager
	ScoreManager.connect("player_score_updated", _on_player_score_updated)
	updated_score = ScoreManager.player_score
	score_label.bbcode_text = "[font=res://fonts/digital-7-italic.ttf][font_size=42][color=#75ef63]%d[/color][/font_size][/font]" % updated_score
	#if updated_score >= hi_score:
	#	hi_score = updated_score
		#score_label.bbcode_text = "[font=res://fonts/digital-7-italic.ttf][font_size=42][color=#75ef63]%d[/color][/font_size][/font]" % updated_score


func _on_player_score_updated(new_score: int):
	# Atualizar o texto do RichTextLabel com o novo placar
	score_label.bbcode_text = "[font=res://fonts/digital-7-italic.ttf][font_size=42][color=#75ef63]%d[/color][/font_size][/font]" % new_score
	
#func _on_player_set_hi_score()	
