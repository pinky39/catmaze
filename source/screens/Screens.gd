extends Node

var current_screen = null

onready var main_menu = $MainMenu
onready var level_menu = $LevelMenu
onready var level_finished = $LevelFinished
onready var level_splash = $LevelSplash
onready var code_screen = $CodeScreen

func change_screen(new_screen):
	if current_screen:
		current_screen.hide()
		yield(current_screen, "closed")
	
	current_screen = new_screen
	
	if new_screen:		
		new_screen.show()		
