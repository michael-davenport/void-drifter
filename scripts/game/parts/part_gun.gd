extends Node2D

class_name part_gun

export(NodePath) var Parent #This is either a ship or a turret base
export(PackedScene) var BulletScene
export(NodePath) var MuzzleSprite
export(int) var MuzzleSpriteKillFrame = 5
export(float) var MuzVelocity = 100.0
export(float) var Spread = 0.0
export(Array, NodePath) var SoundNodes
export(int) var MaxAmmo
export(float) var RechargeRate
export(float) var FireRate

var _cycle: = 0.0
var _cycling: = false
var _ammo : float
var _bulletparent

onready var _parent = get_node(Parent)
onready var _sprite = get_node(MuzzleSprite)

func _ready() -> void:
	if not _parent:
		print("ERROR: " + str(self) + " is unable to find its parent!")
		queue_free()
	if not _sprite: print("WARNING: " + str(self) + " does not have a muzzle vfx sprite assigned")
	if _parent:
		if _parent is ShipObj:
			_bulletparent = _parent
		if _parent is part_turret:
			_bulletparent = _parent._parent
	_ammo = MaxAmmo
	return

func _process(delta: float) -> void:
	if _cycling:
		_cycle += delta
		if _cycle > FireRate:
			_cycle = 0.0
			_cycling = false
	if _sprite:
		if not _sprite.playing: _sprite.visible = false
		if _sprite.frame == MuzzleSpriteKillFrame:
			_sprite.visible = false
			_sprite.playing = false
			_sprite.frame = 0
	if not _cycling and _ammo < MaxAmmo:
		_ammo += RechargeRate * delta
		if _ammo > MaxAmmo: _ammo = MaxAmmo
	return

func fire() -> void:
	if not _bulletparent: find_bparent()
	if not _cycling and _ammo >= 1:
		var blap = BulletScene.instance()
		var fore = Vector2(1,0).rotated(global_rotation - PI/2)
		get_tree().get_root().call_deferred("add_child",blap)
		blap.global_position = global_position
		blap.global_rotation = global_rotation
		if _bulletparent:
			fore = fore.rotated((randf() - randf()) * Spread)
			blap.fire(fore,MuzVelocity,_bulletparent,_bulletparent.linear_velocity)
			if SoundNodes.size() > 0: get_node(SoundNodes[randi() % SoundNodes.size()]).play()
			_cycling = true
			if _sprite:
				_sprite.visible = true
				_sprite.frame = 0
				_sprite.play()
			_ammo -= 1
		else: print("ERROR: " + str(self) + " is being fired with no parent!")
	return

func find_bparent():
	if not _parent: return null
	if _parent is ShipObj:
		_bulletparent = _parent
		return _bulletparent
	if _parent is part_turret:
		_bulletparent = _parent._parent
		return _bulletparent
	print("ERROR: part_gun " + str(self) + " unable to find bulletparent!")
