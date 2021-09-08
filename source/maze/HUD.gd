extends CanvasLayer

signal menu_pressed
var selected_item = null

onready var _hungry = $Controls/Stats/Hungry/Progress
onready var _bored = $Controls/Stats/Bored/Progress
onready var _menu = $Controls/MarginContainer/Menu

func set_hungry(value):
	_hungry.value = value

func set_bored(value):
	_bored.value = value

func change_selected_item(is_selected, item):
	var prev_item = selected_item.item if selected_item else null		
	if is_selected && prev_item != item:
		_reset_selected_item()
		selected_item = {
			item = item,
			icon = item.create_icon()		
		}			
	elif !is_selected:
		_reset_selected_item()		#	

func _reset_selected_item():	
	if selected_item:
		selected_item.icon.queue_free()		
		selected_item.item.unpress()
	
	selected_item = null				

func _on_Menu_pressed():
	emit_signal("menu_pressed")
