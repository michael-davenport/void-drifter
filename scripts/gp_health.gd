extends Node

class_name gp_Health
var Health

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func damage(Amount):
	if Health:
		Health -= Amount
		if Health <= 0: Health = 0
		return [Health]
