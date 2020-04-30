extends "res://Characters/character.gd"

const MAX_SPEED = 250
const ACCELERATION = 50
var move_vec = Vector2()
var friction_x = false
var friction_y = false
var step_Timer
#onready var step = preload("res://Characters/Player/step_sound.tscn")
var standing_locked = false
var standing = true
var stand_Timer

func _ready():
	stand_Timer = $stand_Timer
	stand_Timer.one_shot = true
	stand_Timer.connect("timeout",self,"release_stand")
	step_Timer = $step_Timer
	step_Timer.connect("timeout",self,"_on_step_Timer_timeout")
	set_physics_process(true)
	health = 200
	pass # Replace with function body.

#does NOT work
func friction_start_step_start(friction_axis, start):
	if start:
		friction_axis = true
		if not step_Timer.is_stopped():
			step_Timer.stop()
	else:
		friction_axis = false
		if step_Timer.is_stopped():
			step_Timer.start()
	pass


func _physics_process(delta):
	if Input.is_action_pressed("move_up"):
		move_vec.y = max(move_vec.y-ACCELERATION, -MAX_SPEED)
		#should be replaced by friction_start_step_start(friction_y, false), maybe doesn't work because it passes by value
		friction_y = false
		if step_Timer.is_stopped():
			step_Timer.start()
	if Input.is_action_pressed("move_down"):
		move_vec.y = min(move_vec.y+ACCELERATION, MAX_SPEED)
		friction_y = false
		if step_Timer.is_stopped():
			step_Timer.start()
	if Input.is_action_pressed("move_left"):
		move_vec.x = max(move_vec.x-ACCELERATION, -MAX_SPEED)
		friction_x = false
		if step_Timer.is_stopped():
			step_Timer.start()
	if Input.is_action_pressed("move_right"):# if step timer is not running start 
		move_vec.x = min(move_vec.x+ACCELERATION, MAX_SPEED)
		friction_x = false
		if step_Timer.is_stopped():
			step_Timer.start()
	if Input.is_action_just_released("move_up"):
		#friction_start_step_start(friction_y, true)
		friction_y = true
		if not step_Timer.is_stopped():
			step_Timer.stop()	
	if Input.is_action_just_released("move_down"):
		#friction_start_step_start(friction_y, true)
		friction_y = true
		if not step_Timer.is_stopped():
			step_Timer.stop()	
	if Input.is_action_just_released("move_left"):
		friction_x = true
		if not step_Timer.is_stopped():
			step_Timer.stop()
	if Input.is_action_just_released("move_right"):
		friction_x = true
		if not step_Timer.is_stopped():
			step_Timer.stop()
	
	#!no else lerp because standing should be instant also bc it's weird if multiple ifs need to be activated at the same time
	#move_vec = move_vec.normalized() no normalization to enable diagonal speedrunning
	if friction_x:#if step timer is running stop
		move_vec.x = lerp(move_vec.x, 0, 0.2)
	if friction_y:
		move_vec.y = lerp(move_vec.y, 0, 0.2)
		
	if not standing_locked:
		standing = false
		if Input.is_action_pressed("sneak"):
			step_Timer.stop()
			move_vec = move_vec / 2
		move_and_collide(move_vec * delta)
	else:
		if !step_Timer.is_stopped():
			step_Timer.stop()
		standing = true