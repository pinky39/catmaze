class_name Maze
extends Node2D

signal finished

var num = 1
var paused = false

func _ready():
	$HUD.set_bored($Cat.bored)
	$HUD.set_hungry($Cat.hungry)	
		
	$Cat.connect("bored_changed", $HUD, "set_bored")
	$Cat.connect("hungry_changed", $HUD, "set_hungry")
	
	var main = _try_get_main()
	if main:
		$HUD.connect("menu_pressed", main, "open_level_menu")	

func get_shiny_list():
	return $ShinyList.get_children()

func end_level():
	emit_signal("finished")

func _has_shiny(pos):		
	for shiny in get_shiny_list():
		if shiny.position == pos:
			return true
						
	return false		

func _has_cat(pos):
	return $Cat.tile == pos

func _move_inventory_item(pos):
	var tile_pos = $Floor.get_tile(pos)
	var selected_item = $HUD.selected_item
	
	if selected_item and !selected_item.icon.visible:
		selected_item.icon.visible = true
		add_child(selected_item.icon)
	
	if tile_pos and selected_item:
		selected_item.icon.position = tile_pos
	
	elif selected_item:				
		selected_item.icon.position = get_global_mouse_position()

func _add_shiny_to_maze(pos):
	var tile_pos = $Floor.get_tile(pos)
	var selected_item = $HUD.selected_item
	
	if tile_pos and selected_item:
		
		if !_has_shiny(tile_pos) and !_has_cat(tile_pos):
			var shiny = selected_item.item.create_shiny()
			shiny.position = tile_pos			
			$ShinyList.add_child(shiny)
			
			selected_item.item.consume()

func _unhandled_input(event):
	
	if event is InputEventMouseMotion:
		_move_inventory_item(event.position)	
			
	elif event is InputEventMouseButton and \
		event.button_index == BUTTON_LEFT and \
		event.pressed:		
		
		_add_shiny_to_maze(event.position)

func _try_get_main():
	var main = get_tree().current_scene
	
	# run levels alone via F6, no main
	if main == self:
		return null
	
	return main
		
	
