extends RigidBody2D

class_name ShipObj

export(NodePath) var DamageHandler
export(Array,NodePath) var EnginePaths
export(Array,NodePath) var WeaponPaths
export(float) var TorqueForce = PI*mass
export(float) var MaxAngularVelocity = PI/16
export(PackedScene) var Explod
var InputVector : Vector2
var Thrust : Vector2
var Forward: Vector2
var TarPos: Vector2
var TarDir: Vector2

var _dmg
var _eng = []
var _wep = []
var _torque: = 0.0
var _prevang: = 0.0

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
	pass
