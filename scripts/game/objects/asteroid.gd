extends ShipObj

export(int,0,100) var MinYield = 1
export(int,0,100) var MaxYield = 4
export(float,0,500) var MaxVelocity = 40.0
export(Array,PackedScene) var Minerals

var _yield: = 1

func _ready() -> void:
	if MinYield > MaxYield:
		MinYield = MaxYield
	if MaxYield < MinYield:
		MinYield = MaxYield
	_yield = (randi() % (MaxYield-MinYield)) + MinYield
	
func on_death():
	if not Minerals.size() == 0:
		var i
		for i in range(_yield):
			var mineral = util.scn_spawn(global_position,0,util.select_random(Minerals))
			mineral.linear_velocity = Vector2(1,0).rotated(randf() * 2 * PI) * (randf() * MaxVelocity)
	util.fx_spawn(global_position,rotation,Vector2(2,2),Explod)
	marked_for_death = true
