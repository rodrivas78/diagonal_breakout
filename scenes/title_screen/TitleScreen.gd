extends Node

var primeira_fase : String = "res://scenes/fases/fase_11/fase_11.tscn"
var add = false
var turnOnFadeOut = false
var counter = 0

@onready var current_scene_name = get_tree().current_scene.name
@onready var selector1 = get_node("/root/"+current_scene_name+"/selector")
@onready var selector2 = get_node("/root/"+current_scene_name+"/selector2")
@onready var selector3 = get_node("/root/"+current_scene_name+"/selector3")

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
				get_tree().change_scene_to_file(primeira_fase)
			1:
				#todo - add 
				selected.play()
				await get_tree().create_timer(1.0).timeout
				get_tree().change_scene_to_file(primeira_fase)
			2:
				selected.play()
				await get_tree().create_timer(1.0).timeout
				get_tree().quit()
	
	if Input.is_action_just_pressed("mv-baixo"):
		add = true
		change_selector(add)
	elif Input.is_action_just_pressed("mv-cima"):
		add = false
		change_selector(add)

func change_selector(add: bool) -> void:
	if (add):
		counter += 1
	else :
		counter -= 1
	if counter < 0:
		counter = 2
	counter = counter % 3
	match counter:
		0: 
			select.play()
			selector1.visible = true
			selector2.visible = false
			selector3.visible = false
		1: 
			select.play()
			selector1.visible = false
			selector2.visible = true
			selector3.visible = false
		2: 
			select.play()
			selector1.visible = false
			selector2.visible = false
			selector3.visible = true

func set_music_fade_out() -> void:
	# Diminui o volume da música em 1 dB a cada intervalo de tempo
	if (turnOnFadeOut):
		titleMusic.set_volume_db(titleMusic.volume_db - 0.3)
		if titleMusic.volume_db <= -80:
		# Para a reprodução da música
			titleMusic.stop()
