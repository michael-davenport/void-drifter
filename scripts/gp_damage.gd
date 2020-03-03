extends Node

class_name gp_Damage

export(float) var Health = 100
export(float) var Armor = 100
export(float, 0, 1) var Armor_Factor = 0.65
export(float) var Shield = 100
export(float, 0, 1) var Shield_Factor = 0.65 #Only applies if bleed is allowed, acts as second layer of armor
export(float) var Shield_Rate = 1 #pts/sec
export(bool) var Allow_Armor = true
export(bool) var Allow_Shield = true
export(bool) var Allow_Shield_Bleedthrough = false

var Parent = null
var HPNode = null
var SPNode = null
var APNode = null
var sp = null
var ap = null
var hp = null

signal death

func _ready():
	Parent = get_parent()
	if Parent:
		
		#Instantiate health
		hp = gp_Health.new()
		hp.Health = Health
		add_child(hp)
		
		#Instantiate armor
		if Allow_Armor and Armor > 0:
			ap = gp_Armor.new()
			ap.Armor = Armor
			ap.Armor_Factor = Armor_Factor
			add_child(ap)
		
		#Instantiate shield
		if Allow_Shield and Shield > 0:
			sp = gp_Shield.new()
			sp.Shield = Shield
			sp.Shield_Factor = Shield_Factor
			sp.Shield_Rate = Shield_Rate
			sp.Shield_Bleed = Allow_Shield_Bleedthrough
			sp.Shield_Max = Shield
			add_child(sp)

# warning-ignore:unused_argument
func _process(delta):
	if HPNode:
		HPNode.text = "HP: " + str(hp.Health)
		APNode.text = "AP: " + str(ap.Armor)
		SPNode.text = "SP: " + str(sp.Shield)
	if hp.Health <= 0:
		emit_signal("death")

remotesync func damage(Amount):
	if sp:
		sp.damage(Amount)
	elif ap:
		ap.damage(Amount)
	elif hp:
		hp.damage(Amount)
	else:
		print("WARNING: Attempted to damage entity with malformed damage handler")
	#print("Called damage on " + str(get_parent()) + " for " + str(Amount))
