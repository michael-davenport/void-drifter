extends KinematicBody2D

class_name BulletBase

export var Damage: = 1.0
export var Lifetime: = 0.5
export(PackedScene) var HitScene

var Velocity: = Vector2.ZERO
var ParentShip
var _life: = 0.0

onready var ColArea = $Area2D

func _ready() -> void:
	ColArea.connect("body_entered",self,"on_hit")
	return

func fire(dir:Vector2, MuzzleVel: float, Parent:Node, InheritVel:Vector2) -> void:
	Velocity = dir * MuzzleVel
	if InheritVel: Velocity += InheritVel
	ParentShip = Parent
	return

func _physics_process(delta: float) -> void:
	Velocity = move_and_slide(Velocity)
	return

func _process(delta: float) -> void:
	_life += delta
	if _life > Lifetime: queue_free()
	return

func on_hit(body) -> void:
	if not body == ParentShip:
		if body is ShipObj:
			#print("Bullet hit body")
			var BodyDamage = body._dmg
			if BodyDamage:
				BodyDamage.damage(Damage)
				#print("Bullet applied damage")
		if HitScene:
			util.fx_spawn(global_position,global_rotation - PI,Vector2(2,2),HitScene)
		queue_free()
	return
