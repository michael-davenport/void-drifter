extends ShipObj

class_name obj_EnemyShip

onready var _root = get_tree().get_current_scene()

export(Array,int) var Loot
export(float,0,1) var ChanceToDrop

var _aic
var _fsm : part_fsm
var _dta: = 0.0 #delta tracking used for sine-wave functions in the fsm

signal internal_die

func _ready() -> void:
	register()
	_fsm = part_fsm.new()
	add_child(_fsm)
	_fsm.connect("change_state",self,"on_statechange")

func _process(delta: float) -> void:
	if _fsm:
		_fsm.call(_fsm.FSM_CODE[_fsm.state],self,_fsm.curparams)
		_dta += delta
		if _dta > 10 * PI: _dta = _dta * -1
	if _fsm.state == _fsm.FSM_TYPE.die:
		var ret = data.EnemyList.find(self)
		if ret: data.EnemyList.erase(self)
		#if _indicator: _indicator.queue_free()
		#yield(get_tree().create_timer(0.2), "timeout")
		call_deferred("queue_free")
		emit_signal("internal_die")

func pew() -> void:
	for x in _wep:
		x.fire()
	return

func register():
	data.EnemyList.push_back(self)

func on_death():
	on_statechange(_fsm.FSM_TYPE.die,{})
	yield(self,"internal_die")
	pinata()

func on_statechange(state, params):
	_fsm.state = state
	_fsm.curparams = params

func pinata():
	randomize()
	if randf() < ChanceToDrop:
		var m = randf() * Loot.size()
		for i in range(0,m):
			var item = util.scn_spawn(global_position,global_rotation,data.ITEM_DICT[util.select_random(Loot)].ItemScene)
			item.linear_velocity.x = (randf() - randf()) * 250
			item.linear_velocity.y = (randf() - randf()) * 250
