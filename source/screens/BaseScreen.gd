extends CanvasLayer

export var fade_in_time = 0.5
export var fade_out_time = 0.5

signal opened
signal closed

const FADE_OUT = Color(1,1,1,0)
const FADE_IN = Color(1,1,1,1)

onready var _v_buttons = $Content/MarginContainer/VBoxContainer/Buttons
onready var _h_buttons = $Content/MarginContainer/VBoxContainer/HButtons
var _is_active = false

func _ready():
	$Content.hide()
	$Content.modulate = FADE_OUT	

func show():	
	_enable_buttons(false)
	
	_is_active = true
	$Content.show()	
		
	$Tween.interpolate_property(
		$Content, 
		"modulate", 
		FADE_OUT,
		FADE_IN,
		fade_in_time,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT)
	
	$Tween.start()		
		
func hide():			
	_is_active = false
	
	$Tween.interpolate_property(
		$Content, 
		"modulate", 
		FADE_IN,
		FADE_OUT,
		fade_out_time,		
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT)
	
	$Tween.start()		

func _enable_buttons(enabled):
	for btn in _v_buttons.get_children():						
			btn.disabled = !enabled
	for btn in _h_buttons.get_children():						
			btn.disabled = !enabled

func _on_tween_completed(_object, _key):
	if _is_active:
		_enable_buttons(true)
	else:
		$Content.hide()			
	
	if _is_active:		
		emit_signal("opened")
	else:
		emit_signal("closed")
