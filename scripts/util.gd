extends Node

var OffscreenMin = sqrt(
	pow(ProjectSettings.get_setting("display/window/size/width"),2) +
	pow(ProjectSettings.get_setting("display/window/size/height"),2)
) / 2

var CurAIDirector = null

var ArrowScene = preload("res://scenes/Objects/arrow.tscn")

onready var root = get_node("/root")
onready var world = get_node("/root/World")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	return

func random_point_minmax(center : Vector2, minimum : float, maximum: float) -> Vector2:
	var diff = maximum - minimum
	var ret = Vector2(minimum + (randf() * diff), 0)
	ret = ret.rotated(randf() * 2 * PI)
	return (center + ret)

func random_point_circle(center : Vector2, rng : float) -> Vector2:
	var ret = Vector2(rng,0).rotated(randf() * 2 * PI)
	return (center + ret)

func fx_spawn(point : Vector2, rot : float, scl : Vector2, type : PackedScene):
	var _root = get_tree().get_current_scene()
	var _fx = type.instance()
	_root.call_deferred("add_child",_fx)
	_fx.global_position = point
	_fx.scale = scl
	_fx.global_rotation = rot
	return _fx

func select_random(arr : Array):
	return arr[randi() % arr.size()]

func scn_spawn(point : Vector2, rot : float, type : PackedScene):
	var _scn = type.instance()
	world.add_child(_scn)
	_scn.global_position = point
	_scn.global_rotation = rot
	return _scn

func scn_spawn_parented(point : Vector2, rot : float, type : PackedScene, parent : Node2D):
	var _scn = type.instance()
	parent.add_child(_scn)
	_scn.global_position = point
	_scn.global_rotation = rot
	return _scn

func register_target(anchor, target, color : Color):
	var arrow = scn_spawn(anchor.global_position,0,util.ArrowScene) as target_arrow
	arrow._anchor = anchor
	arrow._target = target
	arrow.z_index = 10
	arrow.modulate = color
	return arrow

func get_all_children(node : Node2D, retarray : Array):
	if is_instance_valid(node):
		var n = node.get_children()
		if n.size() > 0:
			for x in n:
				retarray.push_back(x)
				get_all_children(x, retarray)

func find_hardpoint(ship : Node2D):
	#Validate the ship
	if not ship.get('parts'): return null
	
	#Make a reference to the hardpoints array and check it for empty slots
	var hardpoint = ship.parts.hardpoint
	for x in hardpoint:
		if not is_instance_valid(x._weapon):
			return x
	
	#If not, return our currently selected hardpoint and shift the pointer up
	var ret = hardpoint[ship.parts.controller.HardPointer]
	ship.parts.controller.HardPointer += 1
	if ship.parts.controller.HardPointer > hardpoint.size():
		ship.parts.controller.HardPointer = 0
	return ret
