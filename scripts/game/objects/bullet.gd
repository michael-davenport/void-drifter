extends RigidBody2D

class_name object_bullet

export(float) var Damage = 1.0
export(float) var Lifetime = 0.5
export(PackedScene) var HitScene

var _parent
var _life: = 0.0

func _ready() -> void:
	contact_monitor = true
	contacts_reported = 1
	linear_damp = 0.0
	angular_damp = 0.0
	connect("body_entered",self,"on_hit")
	return

func fire(dir : Vector2, vel : float, Parent : Node, ivel : Vector2) -> void:
	add_collision_exception_with(Parent)
	linear_velocity = dir * vel
	if ivel: linear_velocity += ivel
	_parent = Parent
	return

func _process(delta: float) -> void:
	_life += delta
	if _life > Lifetime: queue_free()

func on_hit(body) -> void:
	if not body == _parent:
		if body is ShipObj:
			var _bdmg = body._dmg
			if _bdmg:
				_bdmg.damage(Damage)
		if HitScene:
			util.fx_spawn(global_position,global_rotation - PI, Vector2(2,2), HitScene)
		queue_free()
	#else:
		#add_collision_exception_with(body) #Probably not necessary??
	return
