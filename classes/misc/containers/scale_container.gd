@tool
extends Container
# A container that scales up its children by a given factor.

@export var scale: Vector2 = Vector2.ONE: set = set_scale


func _notification(what) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		for child in get_children():
			child.scale = scale
			custom_minimum_size = child.size * scale


func set_scale(new_scale) -> void:
	scale = new_scale
	queue_sort()
