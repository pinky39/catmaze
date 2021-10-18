extends Node

var _current_level = null
var _level_count = _get_level_count()

onready var _s = $Screens

# Entrypoint
func _ready():
	open_main_menu(1)

func new_game(first_level):
	_start_level(first_level)

func open_main_menu(first_level):
	if _current_level:		
		_current_level.queue_free()
		_current_level = null
	
	_s.main_menu.first_level = first_level
	_s.change_screen(_s.main_menu)

func open_level_menu():
	_current_level.paused = true
	_s.level_menu.set_level_code(get_code(_current_level.num))
	_s.change_screen(_s.level_menu)
	yield(_s.level_menu, "closed")
	if _current_level:
		_current_level.paused = false

func enter_level_code():
	_s.change_screen(_s.code_screen)
	yield(_s.code_screen, "closed")
	var level_num = get_level(_s.code_screen.code)
	
	if  1 <= level_num  and level_num <= _level_count:
		_s.main_menu.first_level = level_num
	
	_s.change_screen(_s.main_menu)

func restart_level():		
	_start_level(_current_level.num)

func close_screen():
	_s.change_screen(null)

func get_current_level():	
	return _current_level.num

func get_code(num):	
	var offset = 1231
	var key = 1847	
	var code = str((40 * num + offset) ^ key)
	code = code.pad_zeros(4)	
	return code

func get_level(codestr):	
	var offset = 1231
	var key = 1847	
	if codestr:
		var code = int(codestr)	
		var num = ((code ^ key) - offset) / 40	
		return num
	return 0

func _level_finished(level):
	var message = "Level complete, well done!"
	var is_game_won = level.num == _level_count
	if is_game_won:
		message = "Congratulations, you won!"
	
	_s.level_finished.set_message(message)
	_s.change_screen(_s.level_finished)	
	yield(_s.level_finished, "opened")	
	yield(get_tree().create_timer(2), "timeout")
	
	if is_game_won:		
		open_main_menu(1)
	else:
		_start_level(level.num + 1)

func _start_level(num):		
	if _current_level:
		_current_level.queue_free()
		_current_level = null
	
	_s.level_splash.set_message(str("Level ", num))
	_s.change_screen(_s.level_splash)
	var level = _load_level(num)
			
	yield(_s.level_splash, "opened")
		
	# pause a bit for splash screen
	yield(get_tree().create_timer(1), "timeout")
			
	_s.change_screen(null)	
	$Level.add_child(level)
	
	_current_level = level

func _load_level(num):
	var level_path = str("res://levels/Level",num,".tscn")
	var level = load(level_path).instance()
	level.connect("finished", self, "_level_finished", [level])
	level.num = num
	return level

func _get_level_count():
	var dir = Directory.new()
	dir.open("res://levels")
	dir.list_dir_begin(true)
	var file = dir.get_next()
	var count = 0
	while file != "":
		count += 1
		file = dir.get_next()
	
	return count
