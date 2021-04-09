extends "res://screens/BaseScreen.gd"


onready var _level_code = $Content/MarginContainer/LevelCode
onready var _main = get_tree().current_scene

func set_level_code(code):
	_level_code.text = str("Level code: ", code)

func _on_ReturnToGame_pressed():	
	_main.close_screen()	

func _on_Restart_pressed():
	_main.restart_level()

func _on_QuitToMain_pressed():
	_main.open_main_menu(_main.get_current_level())
