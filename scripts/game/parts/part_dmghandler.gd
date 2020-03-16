extends Node2D

class_name part_dmghandler

export(float) var Health = 10

var _shield
onready var _health = Health
signal death

func _process(_delta: float) -> void:
	pass

func damage(dmg):
	if is_instance_valid(_shield):
		if not _shield.disabled: _shield.damage(dmg)
		else: _health -= dmg
	else: _health -= dmg
	if _health <= 0.0: emit_signal("death")
