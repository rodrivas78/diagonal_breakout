extends Node

var current_state: Node = null
#var initial_scene: PackedScene = preload("res://scenes/title_screen/TitleScreen.tscn")
#res://scenes/title_screen/TitleScreen.tscn
var primeira_fase : String = "res://scenes/fases/fase_07/fase_07.tscn"

@onready var current_scene_name = get_tree().current_scene.name
@onready var intro = get_node("/root/"+current_scene_name+"/Intro")
@onready var fase01 = get_node("/root/"+current_scene_name+"/Fase01")

func _ready():
	pass
	
	
func _process(delta):
	receber_inputs()
	

func receber_inputs() -> void:
	if Input.is_action_just_pressed("shift-paddle"):
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file(primeira_fase)


