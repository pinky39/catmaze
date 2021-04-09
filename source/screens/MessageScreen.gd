extends "res://screens/BaseScreen.gd"

onready var _message = $Content/MarginContainer/Message

func set_message(message):
	_message.text = message
