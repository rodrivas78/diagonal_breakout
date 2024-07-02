extends Node2D

#var fase_01: PackedScene = preload("res://scenes/game_manager/game_manager.tscn")


#func enter():
	#print_debug("entrou no enter da Title Screen")
#
#func exit():
	#pass
func _ready():
	receber_inputs()

func _process(delta):
	receber_inputs()
	

func receber_inputs() -> void:
	if Input.is_action_just_pressed("nextStage"):
		start_game()
	
	
func start_game():
	print_debug("entrou no start_game")
	#StateMachine.change_state(fase_01.instantiate())
	#StateMachine.change_state(fase_01.instantiate())
	StateMachine.goto_fase01()
