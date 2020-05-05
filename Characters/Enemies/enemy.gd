extends KinematicBody2D

var target = null
var result

func _ready():
	#$visibility.connect("body_entered", self, "on_visibility_body_entered")
	#$visibility.connect("body_exited", self, "on_visibility_body_exited")
	#$visibility.connect("body_entered", self, "_on_visibility_body_entered")
	$direct_vision.connect("body_entered", self, "direct_vision_entered")
	$direct_vision.connect("body_exited", self, "direct_vision_exited")
	pass
	
#not responding
func direct_vision_entered(body):
	if body.is_in_group("player"):
		#get_parent().get_node("player").get_node("Camera2D").make_current()
		target = body
	pass
	
func direct_vision_exited(body):
	target = null
	pass

func _physics_process(delta):
	if target:
		check_if_target_seen()
	pass

func check_if_target_seen():
	#following line can be used if shape is a square
	#var target_extents = target.get_node("CollisionShape2D").get_shape().extends - Vector2(5,5)
	if !target.is_in_group("player"):
		return
	var space_state = get_world_2d().direct_space_state
	#Get Collisionshape of target minus size of one
	var target_extents = target.get_node("CollisionShape2D").get_shape().radius - 1
	var s = target.position + Vector2(0, -target_extents)
	var e = target.position + Vector2(target_extents, 0)
	var n = target.position + Vector2(0, target_extents)
	var w = target.position - Vector2(target_extents, 0)
	for pos in [s, e, n, w]:
		result = space_state.intersect_ray(position, pos, [self], collision_mask)
		if result:
			if result.collider.is_in_group("player"):
				#keep target until lost
				print(target)
				pass
		#result.clear()
	pass
