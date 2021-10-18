extends Node2D

signal bored_changed(value)
signal hungry_changed(value)

const MAX_HUNGRY = 100
const MAX_BORED = 100
const ORIENTATION = Vector2.RIGHT
const TILE_SIZE = 16
const SPEED = 1.5
const MOVE_HUNGRY = 4
const MOVE_BORED = 4

export var hungry = MAX_HUNGRY
export var bored = MAX_BORED

onready var tile = position

var _can_move = true
var _next_shiny = null
var _reached_end_of_level = false

onready var _animation_state = $AnimationTree.get("parameters/playback")
onready var _look_directions = [$LookForward, $LookRight, $LookLeft, $LookBack]
onready var _maze = owner

func _ready():	
	$AnimationTree.active = true
	_animation_state.travel("Sleep")
	_can_move = false

func _physics_process(_delta):
	if !_can_move or _maze.paused:
		return
		
	if _next_shiny:
		_move_one_step(_next_shiny.direction)
	else:
		_next_shiny = _get_next_shiny()		
		if _next_shiny:						
			# We only rotate in this frame and move 
			# on next. This will ensure $ForwardDetector
			# will be updated in next frame, this
			# could also be solved by always updating 
			# the detector before using it			
			_rotate_towards(_next_shiny.direction)
		else:
			_animation_state.travel("Sleep")

func _can_see_shiny(shiny):	
	for look_direction in _look_directions:
		var colider = look_direction.get_collider()
		if colider == shiny:
			return true
		
	return false

func _can_get_shiny(shiny):
	if (shiny.calories > 0 and MAX_HUNGRY <= (hungry + shiny.attractiveness)) or \
		(shiny.fun > 0 and MAX_BORED <= (bored + shiny.attractiveness)):
		return _can_see_shiny(shiny)
	
	return false
	
func _get_colliders():
	var colliders = []	
	var ray = $ForwardDetector		
			
	while ray.is_colliding():
		var collider = ray.get_collider()
		colliders.append(collider)
		ray.add_exception(collider)
		ray.force_raycast_update()

	for collider in colliders:
		ray.remove_exception(collider)
	
	return colliders

func _move_one_step(dir):	
		
	for collider in _get_colliders():	
		if collider:				
			var cls = collider.get_class()				
		
			if cls == "Goal":
				_reached_end_of_level = true																									
			elif cls == "Shiny":
				_pick_up_shiny(collider)	
			else:
				return # hit the wall -> stop			
		
	_change_hungry(MOVE_HUNGRY)
	_change_bored(MOVE_BORED)	
	
	_can_move = false	
		
	_animation_state.travel("Walk")	
	var next_position = position + dir * TILE_SIZE	
	# set position of the cat to next tile
	tile = next_position
	
	$Tween.interpolate_property(self, "position", position,
								next_position, 1.0 / SPEED,
								Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()	

func _pick_up_shiny(shiny):	
	_next_shiny = null
		
	shiny.queue_free()	
	
	_change_hungry(-shiny.calories)
	_change_bored(-shiny.fun)	

func _get_direction_to(shiny):
	return global_position.direction_to(shiny.position)	
	
func _rotate_towards(direction):
	var angle = ORIENTATION.angle_to(direction)						
	rotate(angle - rotation)	

func _get_next_shiny():		
		
	var shiny = null
	
	for s in _maze.get_shiny_list():
		if _can_get_shiny(s):
			var distance = global_position.distance_to(s.position)			
			if !shiny or shiny.distance > distance:
				shiny = {s = s, distance = distance}									
	
	if shiny:
		var direction =  _get_direction_to(shiny.s)		
				
		return {
			shiny = shiny.s,
			direction = direction
		}					
	
	return null

func _change_hungry(amount):
	hungry += amount
	
	if hungry > MAX_HUNGRY:
		hungry = MAX_HUNGRY
	
	if hungry < 0:
		hungry = 0
		
	emit_signal("hungry_changed", hungry)

func _change_bored(amount):
	bored += amount
	
	if bored > MAX_BORED:
		bored = MAX_BORED
	
	if bored < 0:
		bored = 0
		
	emit_signal("bored_changed", bored)

func _on_tween_completed(_object, _key):	
	if _reached_end_of_level:
		_animation_state.travel("Sleep")		
		_maze.end_level()
	else:	
		_can_move = true	


func _on_StartDelay_timeout():
	_can_move = true
