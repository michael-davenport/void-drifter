extends Node

var OffscreenMin = sqrt(
	pow(ProjectSettings.get_setting("display/window/size/width"),2) +
	pow(ProjectSettings.get_setting("display/window/size/height"),2)
) / 2

var CurAIDirector = null

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
	var _root = get_tree().get_current_scene()
	var _scn = type.instance()
	_root.call_deferred("add_child",_scn)
	_scn.global_position = point
	_scn.global_rotation = rot
	return _scn
