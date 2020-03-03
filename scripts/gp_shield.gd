extends Node

class_name gp_Shield
var Shield
var Shield_Max
var Shield_Factor
var Shield_Rate
var Shield_Bleed
var Parent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if Shield < Shield_Max:
		Shield += Shield_Rate * delta
		if Shield > Shield_Max: Shield = Shield_Max

func damage(Amount):
	Parent = get_parent()
	Shield -= Amount
	if Shield <= 0 and not Shield_Bleed:
		if Parent.ap:
			Parent.ap.damage(Amount)
		elif Parent.hp:
			Parent.hp.damage(Amount)
		Shield = 0
	elif Shield_Bleed:
		if Parent.ap:
			Parent.ap.damage(Amount * Shield_Factor)
		elif Parent.hp:
			Parent.hp.damage(Amount * Shield_Factor)

		return [Shield, Amount * Shield_Factor]
	
