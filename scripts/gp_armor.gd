extends Node

class_name gp_Armor
var Parent
var Armor
var Armor_Factor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func damage(Amount):
	Parent = get_parent()
	Armor -= Amount
	if Armor <= 0: Armor = 0
	if Parent and Parent.hp:
		if Armor:
			Parent.hp.damage(Amount * Armor_Factor)
		else:
			Parent.hp.damage(Amount)
	return [Armor, Amount * Armor_Factor]
