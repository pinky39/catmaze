extends HBoxContainer

export var amount = 0 setget _set_amount

func _ready():
	_set_amount(amount)
		
	if amount == 0:
		hide()
	else:
		$Button.connect("toggled", owner, "change_selected_item", [self])

func unpress():
	$Button.pressed = false

func consume():				
	_set_amount(amount - 1)

func create_icon():
	return $Icon.duplicate()	

func create_shiny():
	var scene_path = str("res://maze/shiny/",name,".tscn")
	return load(scene_path).instance()

func _set_amount(value):
	amount = value
	$Label.text = str(amount)
	
	if amount <= 0:
		unpress()
		$Button.disabled = true
