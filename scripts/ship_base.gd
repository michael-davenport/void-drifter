extends KinematicBody2D
class_name ShipBase

export var InputVector: = Vector2.ZERO
export var Velocity: = Vector2.ZERO
export(float, 0, 1) var DragCoef = 0.0
export var Thrust: = Vector2.ZERO
export(PackedScene) var Explod
var ThrustVector: = Vector2.ZERO
var DirVec: = Vector2.ZERO
var TargetPos: = Vector2.ZERO
var DamageHandler : gp_Damage
var ForwardVec: = Vector2.ZERO

const DEBUG = preload("res://scenes/debug_marker.tscn")
var debugmarker1
var debugmarker2
var marked_for_death: = false

func _ready() -> void:
	DamageHandler = find_node("gp_Damage")
	if DamageHandler: DamageHandler.connect("death",self,"on_death")
	return

func _physics_process(_delta: float) -> void:
	DirVec = TargetPos - global_position
	DirVec = DirVec / DirVec.length()
	ThrustVector = (DirVec * InputVector.x * Thrust.x + DirVec.rotated(PI/2) * InputVector.y * Thrust.y)
	Velocity += ThrustVector
	Velocity *= DragCoef
	Velocity = move_and_slide(Velocity)
	rotate(lerp_angle(0,get_angle_to((global_position + DirVec)),4 * _delta))
	ForwardVec = Vector2(1,0).rotated(rotation)
	return

func on_death() -> void:
	marked_for_death = true
	return
