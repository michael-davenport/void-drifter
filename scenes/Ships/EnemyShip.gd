extends ShipObj

class_name EnemyShip

export(Array, NodePath) var WeaponsPaths

var Weapons : Array
var AIC
var root
var rootname
var dmg : gp_Damage

func _ready() -> void:
	root = get_tree().get_root()
	if WeaponsPaths.size() > 0:
		for x in WeaponsPaths: Weapons.push_back(get_node(x))
	dmg = find_node("gp_Damage")

func _physics_process(delta: float) -> void:
	if InputVector != Vector2.ZERO:
		$Shipsprite/Engine.visible = true
		$Shipsprite/Engine.playing = true
	else:
		$Shipsprite/Engine.visible = false
		$Shipsprite/Engine.playing = false
	return

func _process(delta: float) -> void:
	root = get_tree().get_current_scene()
	if not AIC:
		AIC = root.find_node("gp_AIController")
		#print(str(self) + " is attempting to register...")
		if AIC: 
			AIC.AIList.push_back(self)
			#print(str(self) + " registered successfully to " + str(AIC))
	return
	rootname = root.name

func pew():
	for x in Weapons:
		x.fire()
	return
