extends CanvasLayer

@onready var level_label: RichTextLabel = $RichTextLabel
var updated_level = 0
var hi_score = 0

func _ready():
	updated_level = GlobalData.level
	if updated_level < 10:
		level_label.set_position(Vector2(196, 242))
	else: level_label.set_position(Vector2(176, 242))
	level_label.bbcode_text = "[font=res://fonts/digital-7-italic.ttf][font_size=122][color=#75ef63]Level %d[/color][/font_size][/font]" % updated_level
