extends Node


var lives = 3
var level = 0
var stageCounter = 1


func decrease_lives():
	lives -= 1
	
func reset_lives():
	lives = 3

func increase_level():
	level += 1
	
func reset_level():
	level = 1
	
func increase_stageCounter():
	stageCounter += 1

func reset_stageCounter():
	stageCounter = 1
