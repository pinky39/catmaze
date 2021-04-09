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

func _on_inventory_item_toggled(is_selected, item):
	
	var prev = selected_item	
	selected_item = null
		
	if prev:				
		prev.icon.queue_free()		
		prev.item.unpress()
			
	if is_selected:		
		
		selected_item = {
			item = item,
			icon = item.create_icon()		
		}


func _on_Menu_pressed():
	emit_signal("menu_pressed")
