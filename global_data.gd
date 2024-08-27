extends Node


var lives = 3
var level = 1


func decrease_lives():
	lives -= 1
	

func reset_lives():
	lives = 3


func increase_level():
	level += 1
