extends RigidBody2D

class_name ShipObj

export(NodePath) var DamageHandler
export(Array,NodePath) var EnginePaths
export(Array,NodePath) var WeaponPaths
export(float) var TorqueForce = PI*mass
export(float) var MaxAngularVelocity = PI/16
export(PackedScene) var Explod
export(float) var SensorStrength = 7000
var InputVector : Vector2
var Thrust : Vector2
var Forward: Vector2
var TarPos: Vector2
var TarDir: Vector2

var _dmg
var _eng = []
var _wep = []
var _weprange = []
var _maxrange: = 65535
var _torque: = 0.0
var _prevang: = 0.0
var _indicator
var _mineralbay: = 0
var marked_for_death: = false

func _ready() -> void:
	if DamageHandler:
		_dmg = get_node(DamageHandler)
		if _dmg: _dmg.connect("death", self, "on_death")
	if EnginePaths.size() > 0:
		for x in EnginePaths: _eng.push_back(get_node(x))
	if WeaponPaths.size() > 0:
		for x in WeaponPaths: _wep.push_back(get_node(x))
	return

func _physics_process(delta: float) -> void:
	#Turning
	_torque = clamp(get_angle_to(TarPos),-MaxAngularVelocity,MaxAngularVelocity)
	apply_torque_impulse(_torque * TorqueForce * delta)
	
	#Information
	Forward = Vector2(1,0).rotated(rotation)
	return

func on_death():
	if _indicator: _indicator.queue_free()

func find_maxrange():
	for x in _weprange:
		if x < _maxrange: _maxrange = x

func die_clean():
	for x in _wep:
		x.queue_free()
	for x in _eng:
		x.queue_free()
	_dmg.queue_free()
	queue_free()
