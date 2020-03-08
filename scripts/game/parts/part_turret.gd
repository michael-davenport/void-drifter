extends Node2D

class_name part_turret

export(NodePath) var Parent
export(NodePath) var BarrelAnchor
export(float,0.0,50.266) var MaxRotationSpeed = PI/8

var _parent
var _barrel
var _bulletparent

func _ready() -> void:
	if not BarrelAnchor:
		_barrel = $BarrelAnchor
	else:
		_barrel = get_node(BarrelAnchor)
	if not _barrel:
		print("Turret " + str(self) + " cannot find the barrel anchor or parent")
		queue_free()
	_parent = get_node(Parent)
	if not _parent or not (_parent is ShipObj):
		print("Turret " + str(self) + " cannot find the parent ship or it is not valid")
	call_deferred("pass_range")
	return
	
	
func _physics_process(delta: float) -> void:
	var _rotoff = PI / 2
	var _maxrot = MaxRotationSpeed*delta
	var _rot = _barrel.get_angle_to(_parent.TarPos) + _rotoff
	_rot = clamp(_rot,-_maxrot,_maxrot)
	_barrel.rotate(_rot)
	#linear_velocity = _parent.linear_velocity
	return

func fire() -> void:
	_barrel.fire()

func pass_range():
	_parent._weprange.push_back(_barrel.MaxRange)
	_parent.find_maxrange()
