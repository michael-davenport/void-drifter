extends Node2D

class_name part_hardpoint

export(NodePath) var Parent
export(PackedScene) var StartingWeapon #Weapon scene that should occupy this hardpoint on spawn, if any

onready var _parent = get_node(Parent)

var _weapon : part_weapon

func _ready() -> void:
	if StartingWeapon:
		add_weapon(StartingWeapon)

func fire():
	if is_instance_valid(_weapon):
		_weapon.fire()

func add_weapon(type : PackedScene):
	_weapon = type.instance()
	add_child(_weapon)
	_weapon.global_position = global_position
	_weapon.global_rotation = global_rotation
	_weapon.BulletParent = _parent
	_parent.remove_inventory(_weapon.ItemType)

func remove_weapon():
	if is_instance_valid(_weapon):
		_parent.add_inventory(_weapon.ItemType)
		_weapon.queue_free()
		_weapon = null

func no_refunds():
	if is_instance_valid(_weapon):
		_weapon.queue_free()
		_weapon = null
