extends Node2D

class_name part_weapon

export(PackedScene) var BulletScene #Scene that will be spawned when weapon is fired
#export(data.ITEM_TYPE) var ItemType #Type of item this will enumerate to if dropped into cargo
export(int) var ItemType
export(NodePath) var MuzzleSprite #Nodepath to the muzzle flash animated sprite
export(NodePath) var MuzzleNode #Nodepath to the spawn point for the bullet
export(NodePath) var AudioPlayer #Nodepath to the asp2d_random that contains the audio for the weapon
export(float) var MuzVelocity = 100.0 #Speed of the round exiting the weapon
export(float) var Spread = 0.0 #Cone of fire, in radians (express as fractions of pi)
export(int) var MaxAmmo #Maximum charges the weapon will take
export(float) var RechargeRate #How quickly the weapon regenerates charges
export(float) var FireRate #Refire rate of the weapon
export(int) var MaxRange = 500 #Determines when AI will switch to attack state

var _muzzlesprite #Actual reference to the muzzle flash animated sprite
var _muzzlenode #Node2D representing the spawnpoint of the bullet
var _audioplayer #Actual reference to the asp2d_random node containing the sound

var _cycle: = 0.0 #Internal timer for the action cycle
var _cycling: = false #Whether the weapon's action is mid-cycle
var _ammo : float #Current ammunition in the weapon
var BulletParent #This needs to get set when attached to a hardpoint - this should be the ship that is carrying this weapon

func _ready() -> void:
	if MuzzleSprite:
		_muzzlesprite = get_node(MuzzleSprite)
		_muzzlesprite.connect("animation_finished",self,"reset_muzzlesprite")
		_muzzlesprite.emit_signal("animation_finished")
	if MuzzleNode: _muzzlenode = get_node(MuzzleNode)
	if AudioPlayer: _audioplayer = get_node(AudioPlayer)
	_ammo = MaxAmmo
	return

func _process(delta : float) -> void:
	#Cycle the weapon, if necessary
	if _cycling:
		_cycle += delta
		if _cycle > FireRate:
			_cycle = 0.0
			_cycling = false
	
	#Recharge the weapon if its not being cycled
	if not _cycling and _ammo < MaxAmmo:
		_ammo += RechargeRate * delta
		if _ammo > MaxAmmo: _ammo = MaxAmmo
	
	#Visual
	if is_instance_valid(_muzzlesprite):
		if not _muzzlesprite.playing:
			_muzzlesprite.visible = false
	
	return

func reset_muzzlesprite(): #Resets the muzzle flash sprite so that it can be played again
	_muzzlesprite.frame = 0
	_muzzlesprite.playing = false
	_muzzlesprite.visible = false
	return

func fire() -> void: #Attempt to fire the weapon
	if not is_instance_valid(BulletParent): return #Abort if we do not have a bullet parent to pass
	
	#If we are able to fire, spawn the scene and do so
	if not _cycling and _ammo >= 1:
		var bullet = util.scn_spawn(_muzzlenode.global_position,global_rotation,BulletScene)
		var forward = Vector2(1,0).rotated(global_rotation - PI/2)
		forward = forward.rotated((randf() - randf()) * Spread)
		bullet.fire(forward,MuzVelocity,BulletParent,BulletParent.linear_velocity)
		_cycling = true
		_ammo -= 1

		#Visual and audio FX
		if is_instance_valid(_audioplayer):
			_audioplayer.play_rnd()
		if is_instance_valid(_muzzlesprite):
			reset_muzzlesprite()
			_muzzlesprite.visible = true
			_muzzlesprite.play()

func pass_range():
	if is_instance_valid(BulletParent):
		BulletParent._weprange.push_back(MaxRange)
		BulletParent.find_maxrange()
