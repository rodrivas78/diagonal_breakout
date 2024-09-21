extends Node

var primeira_fase : String = "res://scenes/fases/fase_03/fase_03.tscn"

var add = false
var turnOnFadeOut = false
var selector_activated = true
var counter = 0

@onready var current_scene_name = get_tree().current_scene.name
@onready var selector1 = get_node("/root/"+current_scene_name+"/selector")
@onready var selector2 = get_node("/root/"+current_scene_name+"/selector2")
@onready var selector3 = get_node("/root/"+current_scene_name+"/selector3")
@onready var selector4 = get_node("/root/"+current_scene_name+"/selector4")
@onready var selector5 = get_node("/root/"+current_scene_name+"/selector5")
@onready var controls_screen = get_node("/root/"+current_scene_name+"/Controls_Scr")
@onready var instructions_screen = get_node("/root/"+current_scene_name+"/Instructions_Scr")
@onready var about_screen = get_node("/root/"+current_scene_name+"/About_Scr")

@onready var titleMusic : AudioStreamPlayer = $SomTitleScreen
@onready var select : AudioStreamPlayer = $SomSelector
@onready var selected : AudioStreamPlayer = $SomChoosed

func _ready():
	pass
	
	
func _process(delta):
	receber_inputs()
	set_music_fade_out()
	

func receber_inputs() -> void:
	if Input.is_action_just_pressed("shift-paddle"):
		match counter:
			0: 
				selected.play()
				turnOnFadeOut = true
				await get_tree().create_timer(2.0).timeout
				GlobalData.reset_lives()
				ScoreManager.reset_player_score()
				GlobalData.reset_level()
				GlobalData.reset_stageCounter()
				get_tree().change_scene_to_file(primeira_fase)
			1: 
				if selector_activated:
					selected.play()
				controls_screen.visible = true 
				selector2.visible = false
				selector_activated = false
			2:
				if selector_activated:
					selected.play()
				instructions_screen.visible = true 
				selector3.visible = false
				selector_activated = false
			3:
				if selector_activated:
					selected.play()
				about_screen.visible = true 
				selector4.visible = false
				selector_activated = false
			4:
				selected.play()
				await get_tree().create_timer(1.0).timeout
				get_tree().quit()
	
	if Input.is_action_just_pressed("mv-baixo"):
		if selector_activated:
			add = true
			change_selector(add)
	elif Input.is_action_just_pressed("mv-cima"):
		if selector_activated:
			add = false
			change_selector(add)
	if Input.is_action_just_pressed("sair"):
		if !selector_activated:
			controls_screen.visible = false
			instructions_screen.visible = false 
			about_screen.visible = false
			selector_activated = true
			match counter:
				1:
					selector2.visible = true
				2:
					selector3.visible = true
				3: 
					selector4.visible = true

func change_selector(add: bool) -> void:
	if (add):
		counter += 1
	else :
		counter -= 1
	if counter < 0:
		counter = 4
	counter = counter % 5

	match counter:
		0: 
			select.play()
			selector1.visible = true
			selector2.visible = false
			selector3.visible = false
			selector4.visible = false
			selector5.visible = false
		1: 
			select.play()
			selector1.visible = false
			selector2.visible = true
			selector3.visible = false
			selector4.visible = false
			selector5.visible = false
		2: 
			select.play()
			selector1.visible = false
			selector2.visible = false
			selector3.visible = true
			selector4.visible = false
			selector5.visible = false
		3: 
			select.play()
			selector1.visible = false
			selector2.visible = false
			selector3.visible = false
			selector4.visible = true
			selector5.visible = false
		4: 
			select.play()
			selector1.visible = false
			selector2.visible = false
			selector3.visible = false
			selector4.visible = false
			selector5.visible = true

func set_music_fade_out() -> void:
	# Diminui o volume da música em 1 dB a cada intervalo de tempo
	if (turnOnFadeOut):
		titleMusic.set_volume_db(titleMusic.volume_db - 0.3)
		if titleMusic.volume_db <= -80:
		# Para a reprodução da música
			titleMusic.stop()
