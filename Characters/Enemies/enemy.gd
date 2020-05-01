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


func check_out_position():
	pass

func hear_sound(source):
	var hits = segment_cast(source.position, position)
	var obstructed_hearing = 0
	var hearing_strength = 1
	for object in hits:
		if object.is_in_group("obstructs_hearing"):
			obstructed_hearing -= object.hearing_restance
	if hearing_strength - obstructed_hearing > 0.1:
		check_out_position()
	else:
		return
	pass
	
# Do this inside _fixed_process() or _integrate_forces()
func segment_cast(begin_pos, end_pos):
	var space_state = get_world_2d().get_direct_space_state()

	var segment = SegmentShape2D.new()
	segment.set_a(begin_pos)
	segment.set_b(end_pos)

	var query = Physics2DShapeQueryParameters.new()
	query.set_shape(segment)
	query.set_exclude([self]) # If you want to exclude the object casting the segment
	query.set_layer_mask(0) # Set the collision mask you want, or none if you want to hit anything

	var hits = space_state.intersect_shape(query, 32)
	return hits
