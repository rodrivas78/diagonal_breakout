extends CanvasLayer

@onready var stage_label: RichTextLabel = $RichTextLabel
var updated_stage = 0
var hi_score = 0

func _ready():
	updated_stage = GlobalData.stageCounter
	if updated_stage < 10:
		stage_label.set_position(Vector2(854, 417))
	else: stage_label.set_position(Vector2(846, 417))
	stage_label.bbcode_text = "[font=res://fonts/digital-7-italic.ttf][font_size=42][color=#75ef63]Stage %d[/color][/font_size][/font]" % updated_stage
