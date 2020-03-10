extends Node2D

class_name target_arrow

export(NodePath) var AnchorNode
export(NodePath) var TargetPath
export(float) var ScreenRatio = 0.15

var _anchor #should generally always be the camera
var _target
var _max

onready var dbgLabel = $arrow/Debug/dbgLabel
onready var dbg = $arrow/Debug
onready var spr = $arrow

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
	if not validate():
		deregister()
		return
		
	var fademax = _max
	if _target is ShipObj:
		fademax += _target.PassiveDetectionFactor
		spr.scale = Vector2(1,1) * _target.ArrowSize
	var dir = _anchor.global_position.direction_to(_target.global_position)
	var pos = _anchor.global_position + (dir * (util.OffscreenMin * ScreenRatio))
	var dst = _anchor.global_position.distance_to(_target.global_position)
	var threat = pos
	if _target is ShipObj:
		threat += dir * clamp((dst - _target.PassiveDetectionFactor) * ScreenRatio,util.OffscreenMin * (ScreenRatio/-2),700)
	global_position = threat
	rotate(get_angle_to(_target.global_position))
	if not _target is object_gate:
		spr.self_modulate.a = -(log(dst/fademax)/2.718)
	
	if dbg:
		dbg.rotation = -rotation - PI / 2
		if _target is ShipObj:
			dbgLabel.text = "Ship: " + str(_target) + "\n" + "FSM State: " + str(_target._fsm.state) + "\n" + "FSM Params: " + str(_target._fsm.curparams)

func validate() -> bool:
	if not is_instance_valid(_target):
		return false
	if not is_instance_valid(_anchor):
		return false
	if _target is ShipObj:
		if _target.marked_for_death:
			return false
	return true

func deregister() -> void:
	queue_free()
