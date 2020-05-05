extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("_on_body_entered", self, "_on_Area2D_body_entered")
	connect("_on_body_entered", self, "on_visibility_body_entered")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func on_visibility_body_entered(body):
	print(body)
	pass

func _on_Area2D_body_entered(body):
	print("...")
	print(body)
	pass # Replace with function body.
