extends CollisionShape2D

class_name part_shield

export(float) var MaxHP = 10
export(float) var RegenRate = 0.25
export(float) var DownTime = 2
export(NodePath) var Visual

onready var _vis = get_node(Visual)

var _hp = MaxHP
var _dt = 0.0

func _ready() -> void:
	_hp = MaxHP

func _process(delta: float) -> void:
	if not disabled: _hp += delta * RegenRate
	else:
		_dt += delta
		if _dt > DownTime:
			_dt = 0.0
			_vis.visible = true
			set_deferred("disabled",false)

func damage(dmg):
	_hp = clamp(_hp - dmg,0,MaxHP)
	if _hp <= 0.0: 
		_vis.visible = false
		set_deferred("disabled",true)
