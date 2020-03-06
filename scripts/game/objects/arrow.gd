extends Node2D

class_name target_arrow

export(NodePath) var AnchorNode
export(NodePath) var TargetPath
export(float) var ScreenRatio = 0.15

var _anchor #should generally always be the camera
var _target
var _max

func _ready() -> void:
	if not _anchor:
		_anchor = get_node(AnchorNode)
	if not _target:
		_target = get_node(TargetPath)
	if not (_anchor is Node) and not (_anchor is Node2D):
		print("Target arrow anchor invalid")
		queue_free()
	if _anchor is ShipObj:
		_max = _anchor.SensorStrength

func _process(_delta: float) -> void:
	if _anchor and _target:
		var dir = _anchor.global_position.direction_to(_target.global_position)
		var pos = _anchor.global_position + (dir * (util.OffscreenMin * ScreenRatio))
		var dst = _anchor.global_position.distance_to(_target.global_position)
		global_position = pos
		rotate(get_angle_to(_target.global_position))
		modulate.a = -(log(dst/_max)/2.718)
