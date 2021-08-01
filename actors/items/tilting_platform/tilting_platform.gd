tool
extends StaticBody2D

onready var ride_area = $RideArea

export var width = 1 setget set_width

var ang_vel = 0

func set_width(new_width):
	width = new_width
	if width <= 0:
		$Middle.visible = false #can't use the variable cuz the node isn't ready yet
		$MiddleCollision.disabled = true
	else:
		$Middle.visible = true
		$Collision.disabled = false
		$Middle.rect_size.x = 48 * width
		$Middle.rect_position.x = -24 * width
		$Collision.shape.extents.x = 24 * width + 16
		$RideArea/RideShape.shape.extents.x = 24 * width + 16
	$Left.position.x = -24 * width - 8
	$Right.position.x = 24 * width + 8


func _physics_process(_delta):
	if !Engine.editor_hint:
		#calculate total torque
		#M = Fd
		#yeah i know this is the formula for moments shush
		#F will just be a constant for now
		#maybe objects could have weights at some point idk
		
		var torque = 0
		for body in ride_area.get_overlapping_bodies():
			if body.is_on_floor():
				var angle = get_angle_to(body.position)
				var dist = position.distance_to(body.position)
				var perpendicular_dist = cos(angle) * dist #calculate perpendicular distance from pivot
				torque += perpendicular_dist
		ang_vel += torque / 8000 / width
		rotation += ang_vel
		if rotation > deg2rad(1):
			ang_vel -= deg2rad(0.025)
		elif rotation < deg2rad(-1):
			ang_vel += deg2rad(0.025)
		rotation = lerp(rotation, 0, 0.0125)
		ang_vel = lerp(ang_vel, 0, 0.0125)
	
#	for body in ride_area.get_overlapping_bodies():
#		if body.is_on_floor():
#			body.move_and_collide(move_vec)


#func _on_RideArea_body_entered(body):
#	if body.vel.y > 0:
#		riding += 1
#
#
#func _on_RideArea_body_exited(body):
#	riding -= 1
