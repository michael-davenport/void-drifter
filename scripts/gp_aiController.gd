extends Node

class_name gp_AIController

export(bool) var Enabled

var AIList : Array

onready var root = get_tree().get_current_scene()
onready var plyship = root.find_node("PlyShip")

func _ready() -> void:
	if not Enabled: queue_free()

func _process(delta: float) -> void:
	if AIList.size() > 0 and plyship:
		for bot in AIList:
			if not bot.marked_for_death:
				bot = bot as obj_EnemyShip
				
				var dist = bot.global_position.distance_to(bot.TarPos)
				var fore = clamp((dist - 250) / 40,-1,1) #This should really be reading the bot's ship modules and formulating input on that
				var star = sin(PI*delta*0.25)
				
				if plyship._alive:
					bot.TarPos = plyship.global_position
					bot.InputVector = Vector2(fore,star)
					bot.pew()
			else:
				AIList.remove(AIList.find(bot))
				bot.queue_free()

