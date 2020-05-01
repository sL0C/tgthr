extends KinematicBody2D
class_name Character

# Constants
const FRICTION_STRENGTH = 23 # The Strength of the friction force

# To specify the datatype increases the perfomance
export  var health:float = 100
export  var move_speed:int = 100
export  var max_speed:float = 300

# Vector Types
var velocity:Vector2 = Vector2.ZERO

func take_damage(dmg:float) -> void: # To specify the return value increases the perfomance
	health -= dmg
	if health <= 0:
		print(name + " died!")
		queue_free()

# Take the direction and multiply it by the move_speed
func move(dir:Vector2):
	velocity += dir * move_speed
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	apply_friction()
	

# we have to ask ourself what friction is.
# friction is a force, which applies when a object is moving!
# but in which direction does friction point?
# in the opposite direction of velocity
# Formular: -1 * strength of friction * velocity
func apply_friction():
	if velocity.length() > FRICTION_STRENGTH:
		velocity -= velocity.normalized() * FRICTION_STRENGTH
	else:
		velocity = Vector2.ZERO
