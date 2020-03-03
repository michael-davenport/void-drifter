extends Node2D

class_name part_dmghandler

export(float) var Health = 10
export(NodePath) var Parent
export(NodePath) var ShieldEmitter
export(float) var TF = 8

onready var _parent = get_node(Parent)

var _shield : part_shield
var _health: = 1.0
var _tf: = 0.0 #This is a workaround for shields being wonky - this needs 2 get fixeroni'd
signal death

func _ready() -> void:
	if ShieldEmitter: _shield = get_node(ShieldEmitter) as part_shield
	_tf = _parent.TorqueForce
	_health = Health as float

func _process(_delta: float) -> void:
	if _shield:
		if _shield.disabled: _parent.TorqueForce = _tf
		else: _parent.TorqueForce = _tf * TF

func damage(dmg):
	if _shield:
		if not _shield.disabled: _shield.damage(dmg)
		else: _health -= dmg
	else: _health -= dmg
	if _health <= 0.0: emit_signal("death")
