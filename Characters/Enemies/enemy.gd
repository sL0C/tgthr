extends KinematicBody2D

export (int) var detect_radius
var target
var hit_pos


func _ready():
	$visibility.connect("body_entered", self, "on_visibility_body_entered")
	$visibility.connect("body_exited", self, "on_visibility_body_exited")
	pass
	
	
func on_visibility_body_entered(body):
	target = body
	pass
	
func on_visibility_body_exited(body):
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
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node("CollisionShape2D").get_shape().radius - 1
	var nw = target.position - Vector2(0, target_extents)
	var se = target.position + Vector2(target_extents, 0)
	var sw = target.position + -Vector2(0, target_extents)
	var ne = target.position - Vector2(target_extents, 0)
	for pos in [nw, se, ne, sw]:
		var result = space_state.intersect_ray(position, pos, [self], collision_mask)
		if result:
			hit_pos.append(result.position)
			if result.collider.is_in_group("player"):
				#keep target until lost
				print("player found")
				pass
	pass