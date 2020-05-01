extends Character # <- If we specified the class_name then we can refer to it like this 

var move_vec = Vector2.ZERO
var friction = Vector2.ZERO

#onready var step = preload("res://Characters/Player/step_sound.tscn")

# onready starts if the timer is fully initialized, so stand_timer gets defined when the Timer node is ready
onready var stand_timer:Timer = $stand_Timer
onready var step_timer:Timer = $step_Timer

# We use that, to collect all connections and keep our code cleaned up
func _init_connections() -> void:
	stand_timer.connect("timeout",self,"release_stand")
	step_timer.connect("timeout",self,"_on_step_Timer_timeout")
	
func _ready():
	health = 200
	_init_connections()
	set_physics_process(true)
	
func _physics_process(delta):
	var move_direction:Vector2
	
	# A neat trick to get the direction of movement
	move_direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	move_direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	move(move_direction)
	velocity = move_and_slide(velocity) # velocity = move_and_slide() to keep track of velocity after colliding
