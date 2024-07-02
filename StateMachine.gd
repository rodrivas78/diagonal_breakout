extends Node

var current_state: Node = null
#var initial_scene: PackedScene = preload("res://scenes/title_screen/TitleScreen.tscn")
#res://scenes/title_screen/TitleScreen.tscn
@onready var current_scene_name = get_tree().current_scene.name
@onready var intro = get_node("/root/"+current_scene_name+"/Intro")
@onready var fase01 = get_node("/root/"+current_scene_name+"/Fase01")

func _ready():
	#var title_screen = initial_scene.instantiate()
	#change_state(title_screen)
	#goto_intro()
	pass
	

func change_state(new_state: Node):
	print_debug("entrou no change_state")
	#if current_state:
	#	current_state.call_deferred("_exit_tree")
	current_state = new_state
	print_debug(new_state)
	#print_debug(current_state.to_string())
	current_state.call_deferred("_ready")
	
func goto_intro():
	change_state(intro)		
	
func goto_fase01():
	change_state(fase01)	
	
func goto_fase02():
	change_state($Fase02)
