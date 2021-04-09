extends "res://screens/BaseScreen.gd"

var first_level = 1 setget _set_first_level

onready var _main = get_tree().current_scene
onready var _start = $Content/MarginContainer/VBoxContainer/Buttons/Start

func _set_first_level(value):
	_start.text = str("Start with level ", value)
	first_level = value

func _on_NewGame_pressed():
	_main.new_game(first_level)

func _on_EnterCode_pressed():
	_main.enter_level_code()
