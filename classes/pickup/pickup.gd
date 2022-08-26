class_name Pickup
extends Area2D

# If true, free the parent node as well when collected.
# Useful for pickup children of physics objects.
export var parent_is_root: bool = false

# Enables pickup ID behavior, so pickups can only be collected once per level.
export var persistent_collect = true

export var disabled: bool = false setget set_disabled

export var _sprite_path: NodePath = "Sprite"
onready var sprite = get_node_or_null(_sprite_path)

var collect_id


func _ready():
	_ready_override()


func _ready_override() -> void:
	if sprite != null:
		sprite.playing = !disabled
	if persistent_collect:
		_pickup_id_setup()
	_connect_signals()


func _connect_signals() -> void:
	connect("body_entered", self, "pickup")


func set_disabled(val):
	disabled = val
	monitoring = !val
	sprite = get_node_or_null(_sprite_path)
	if sprite != null:
		sprite.playing = !val


func _pickup_id_setup() -> void:
	var room = get_tree().get_current_scene().get_filename()
	collect_id = Singleton.get_collect_id()
	if Singleton.collected_dict[room][collect_id]:
		queue_free()
	else:
		Singleton.collected_dict[room].append(false)


func pickup(_body) -> void:
	_award_pickup()
	_mark_collected()
	_pickup_effect()
	_kill_pickup()


func _kill_pickup() -> void:
	if parent_is_root:
		get_parent().queue_free()
	else:
		queue_free()


func _pickup_effect() -> void:
	pass


func _mark_collected() -> void:
	if persistent_collect:
		Singleton.collected_dict[get_tree().get_current_scene().get_filename()][collect_id] = true
	Singleton.collect_count += 1


func _award_pickup() -> void:
	pass
