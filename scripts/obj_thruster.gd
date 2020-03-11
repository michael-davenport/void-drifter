extends Node2D

class_name part_Thruster

export(NodePath) var Parent
export(NodePath) var EffectsParent
export(NodePath) var Audio
export(float,0,65535) var IdealSpeed = 500
export(Vector2) var Force = Vector2(0,-1)

onready var _parent = get_node(Parent)
onready var _effect = get_node(EffectsParent) as AnimatedSprite
onready var _audio = get_node(Audio) as AudioStreamPlayer2D

var _thrust: = Vector2(0,0)

func _ready() -> void:
	_effect.visible = false
	_effect.playing = true
	if _audio: 
		_audio.playing = true
		_audio.pitch_scale = 0.01
	return

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(_parent) or not _effect:
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
		#_parent.apply_impulse(_parent.global_position - global_position, _thrust)
		_parent.apply_impulse(_parent.global_position - global_position, _parent.Forward * _parent.InputVector.x * Force.x)
		_parent.apply_central_impulse(_parent.Forward.rotated(PI/2) * _parent.InputVector.y * Force.y)
	else:
		_effect.visible = false
	
	if _audio:
		_audio.pitch_scale = clamp(_parent.linear_velocity.length() / IdealSpeed,0.001,2.5)
	
	return
