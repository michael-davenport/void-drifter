extends Node2D

class_name part_turret

export(NodePath) var Parent
export(NodePath) var BarrelAnchor
export(float,0.0,50.266) var MaxRotationSpeed

onready var _parent = get_node(Parent)

var _barrel
#var linear_velocity
var _bulletparent

func _ready() -> void:
	if not BarrelAnchor:
		_barrel = $BarrelAnchor
	else:
		_barrel = get_node(BarrelAnchor)
	if not _barrel:
		print("Turret " + str(self) + " cannot find the barrel anchor or parent")
		queue_free()
	if not _parent or not (_parent is ShipObj):
		print("Turret " + str(self) + " cannot find the parent ship or it is not valid")
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
