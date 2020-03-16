extends Node2D

class_name part_fsm_old

enum FSM_TYPE {
	idle,
	goto,
	attack,
	patrol,
	die
}

var FSM_CODE = [
	"fsm_idle",
	"fsm_goto",
	"fsm_attack",
	"fsm_patrol",
	"fsm_die"
]

var state = FSM_TYPE.idle
var curparams = {}
var _t: = 0.0

signal change_state(state, params)

func _ready() -> void:
	emit_signal("change_state",FSM_TYPE.idle,{})

func _process(delta: float) -> void:
	pass


func fsm_goto(ship : ShipObj, params = {}) -> void:
	if not ship: ship = get_parent()
	var pos : Vector2
	if params.has('tgt'):
		pos = params.tgt.global_position
	else:
		pos = params.pos
	var dst = ship.global_position.distance_to(pos)
	if dst < ship._maxrange: emit_signal("change_state",FSM_TYPE.idle,{})
	else:
		ship.TarPos = pos
		ship.InputVector = Vector2(1,0) #can throw in a pathfinder at some point instead but really we can just push rocks out the way
		if params.has('tgt'):
			if dst > ship.SensorStrength:
				emit_signal("change_state",FSM_TYPE.idle,{})
	interrupt_scan_hostiles(ship)

func fsm_attack(ship : ShipObj, params = {}) -> void:
	if not ship: ship = get_parent()
	var tgt = params.tgt
	if is_instance_valid(tgt):
		if tgt._alive:
			fsm_sub_attackrun(ship,{tgt=tgt})
		else:
			emit_signal("change_state",FSM_TYPE.idle,{})
	else:
		emit_signal("change_state",FSM_TYPE.idle,{})

func fsm_patrol(ship : ShipObj, params = {}) -> void:
	if not ship: ship = get_parent()
	var radius = params.radius
	var radiusmax = params.radiusmax
	if not radius: radius = ship.SensorStrength / 2
	if not radiusmax: radiusmax = ship.SensorStrength
	var pos = Vector2(1,0).rotated(rand_range(0,2*PI))
	pos = pos * rand_range(radius,radiusmax)
	emit_signal("change_state",FSM_TYPE.goto,{ pos = pos })

func fsm_idle(ship : ShipObj, params = {}) -> void:
	if not ship: ship = get_parent()
	var ply = get_tree().get_current_scene().find_node("PlyShip")
	if ply._alive:
		if ship.global_position.distance_to(ply.global_position) < ship.SensorStrength:
			emit_signal("change_state",FSM_TYPE.attack,{ tgt = ply })
		else:
			emit_signal("change_state",FSM_TYPE.patrol, { radius = ship.SensorStrength / 2, radiusmax = ship.SensorStrength })
	else:
		emit_signal("change_state",FSM_TYPE.patrol, { radius = ship.SensorStrength / 2, radiusmax = ship.SensorStrength })

func fsm_die(ship : ShipObj, params = {}) -> void:
	util.fx_spawn(ship.global_position,ship.rotation,Vector2(2,2),ship.Explod)
	ship.marked_for_death = true

func fsm_sub_attackrun(ship : ShipObj, params = {}):
	var tgt = params.tgt
	var dst = ship.global_position.distance_to(tgt.global_position)
	if not ship._maxrange == 65535 and is_instance_valid(ship._wep[0]._weapon):
		if dst > ship._maxrange: emit_signal("change_state",FSM_TYPE.goto,{ tgt = tgt })
		if dst < (ship._maxrange + ship.linear_velocity.length()):
			ship.pew()
			ship.TarPos = tgt.global_position + ((tgt.linear_velocity - ship.linear_velocity) * (dst / ship._wep[0]._weapon.MuzVelocity))
			ship.InputVector = Vector2(
				dst - ship._maxrange / 3.3,
				sin((PI/2)*ship._dta)
			)
	else:
		ship.find_maxrange()

func interrupt_scan_hostiles(ship : ShipObj):
	var plyship = get_tree().get_current_scene().find_node("PlyShip")
	if is_instance_valid(plyship):
		if plyship._alive:
			if ship.global_position.distance_to(plyship.global_position) < ship.SensorStrength:
				emit_signal("change_state",FSM_TYPE.attack,{ tgt = plyship })
