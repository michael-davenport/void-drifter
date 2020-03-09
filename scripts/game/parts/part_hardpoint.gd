extends Node2D

export(NodePath) var Parent

onready var _parent = get_node(Parent)

var _weapon : part_weapon

func fire():
	if is_instance_valid(_weapon):
		_weapon.fire()

func add_weapon(type : PackedScene):
	_weapon = type.instance()
	_weapon.global_position = global_position
	_weapon.global_rotation = global_rotation
	_weapon.BulletParent = _parent
	add_child(_weapon)
