extends Node2D

class_name part_thruster

export(Vector2) var ThrustForce = Vector2.ZERO
export(float) var Torque = 15000
export(float) var Mass = 1

var exhaust : AnimatedSprite
var audio : AudioStreamPlayer2D

func _ready() -> void:
	var n = get_children()
	for x in n:
		if x is AnimatedSprite:
			exhaust = x
		if x is AudioStreamPlayer2D:
			audio = x
	if exhaust == null or audio == null:
		free()
