extends Node2D

class_name WeaponBase

export(PackedScene) var BulletScene
export(NodePath) var MuzzleSprite
export(float) var MuzzleVelocity
export(Array, NodePath) var SoundNodes
export(int) var AmmoCapacity
export(float) var RechargeRate
export(float) var RefireDelay
export(NodePath) var ParentShip #This should be the root node for the ship scene

var _cycle: = 0.0
var _cycling: = false
var _ammo = AmmoCapacity as float
var _parent : ShipObj
var _sprite : AnimatedSprite

func _ready() -> void:
	_parent = get_node(ParentShip)
	_sprite = get_node(MuzzleSprite)
	return

func _process(delta: float) -> void:
	if _cycling:
		_cycle += delta
		if _cycle > RefireDelay:
			_cycle = 0.0
			_cycling = false
	if _sprite:
		if not _sprite.playing: _sprite.visible = false
		if _sprite.frame == 5: 
			_sprite.visible = false
			_sprite.playing = false
			_sprite.frame = 0
	if not _cycling:
		_ammo += RechargeRate * delta
		if _ammo > AmmoCapacity: _ammo = AmmoCapacity
	return

func fire() -> void:
	if not _cycling and _ammo > 1:
		var blap = BulletScene.instance()
		get_tree().get_root().call_deferred("add_child", blap)
		blap.global_position = global_position
		blap.global_rotation = global_rotation
		if ParentShip:
			blap.fire(_parent.Forward,MuzzleVelocity,_parent,_parent.linear_velocity)
			if SoundNodes.size() > 0:
				get_node(SoundNodes[randi() % SoundNodes.size()]).play()
			_cycling = true
			if _sprite:
				_sprite.visible = true
				_sprite.frame = 0
				_sprite.play()
			_ammo -= 1
		else: print("ERROR: Tried to fire bullet with no parent ship")
	return
