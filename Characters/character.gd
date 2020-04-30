extends KinematicBody2D
class_name character

export var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func take_damage(dmg):
	health -= dmg
	if health < 1:
		queue_free()


func move(vec):
	move_and_slide(vec)
	pass