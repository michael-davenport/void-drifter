extends ShipObj

class_name obj_EnemyShip

onready var _root = get_tree().get_current_scene()

var _aic

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
	_indicator = util.register_target(_root.find_node("PlyShip"),self,Color(1,0,0))
	return _con

func on_death():
	util.fx_spawn(global_position,rotation,Vector2(2,2),Explod)
	marked_for_death = true
	if _indicator: _indicator.queue_free()
