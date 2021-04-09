extends "res://screens/BaseScreen.gd"

var code = null

onready var _line_edit = $Content/MarginContainer/VBoxContainer/LineEdit
onready var _main = get_tree().current_scene
onready var _keyboard = $Content/MarginContainer/VBoxContainer/Keyboard

func _ready():	
	for btn in _keyboard.get_children():
		btn.connect("pressed", self, "_on_key_pressed", [btn])			
		
func _enable_buttons(enabled):		
	for btn in _keyboard.get_children():
		btn.disabled = !enabled	
	
	._enable_buttons(enabled)

func show():
	_line_edit.text = ""
	.show()

func _on_key_pressed(btn):
	_line_edit.text = str(_line_edit.text, btn.text)

func _on_Ok_pressed():
	code = _line_edit.text	
	_main.close_screen()	

func _on_Cancel_pressed():
	code = null	
	_main.close_screen()	
