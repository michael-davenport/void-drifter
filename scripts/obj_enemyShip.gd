extends ShipObj

class_name obj_EnemyShip

onready var _root = get_tree().get_current_scene()

var _aic
var marked_for_death: = false

func _ready() -> void:
	_aic = register()
	

func pew() -> void:
	for x in _wep:
		x.fire()
	return

func register():
	var i: = 0
	var _con
	while not _con:
		_con = _root.find_node("gp_AIController")
		if i >= 500:
			print(str(self) + " failed to find AI controller")
			return null
	_con.AIList.push_back(self)
	return _con

func on_death():
	util.fx_spawn(global_position,rotation,Vector2(2,2),Explod)
	marked_for_death = true
