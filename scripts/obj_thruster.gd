extends Node2D

class_name part_Thruster

export(NodePath) var Parent
export(NodePath) var EffectsParent
export(Vector2) var Force = Vector2(0,-1)

onready var _parent = get_node(Parent)
onready var _effect = get_node(EffectsParent) as AnimatedSprite

var _thrust: = Vector2(0,0)

func _ready() -> void:
	_effect.visible = false
	_effect.playing = true
	return

func _physics_process(_delta: float) -> void:
	if not _parent or not _effect:
		print(
			"ENGINE MISSING CRITICAL COMPONENTS:\n" +
			"SELF: " + str(self) + "\n" + 
			"PARENT: " + str(_parent) + "\n" +
			"EFFECT: " + str(_effect)
			)
		queue_free()
		return
	_thrust = (Force * _parent.InputVector).rotated(global_rotation - PI/2)
	
	if _parent.InputVector != Vector2.ZERO:
		_effect.visible = true
		_parent.apply_impulse(_parent.global_position - global_position, _thrust)
	else:
		_effect.visible = false
	
	return
