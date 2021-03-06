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
				bot = bot
				
				var dist = bot.global_position.distance_to(bot.TarPos)
				var fore = clamp((dist - 250) / 40,-1,1) #This should really be reading the bot's ship modules and formulating input on that
				var star = sin(PI*delta*0.25)
				
				if plyship._alive:
					var plypos = plyship.global_position
					var leadpos = plypos + plyship.linear_velocity * (bot.global_position.distance_to(plypos) / (bot._wep[0].MuzVelocity + bot.linear_velocity.length()))
					bot.TarPos = leadpos
					bot.InputVector = Vector2(fore,star)
					var tdist = bot.global_position.distance_to(bot.TarPos)
					if tdist <= (bot._maxrange + bot.linear_velocity.length()) and not bot._maxrange == 65535: bot.pew()
			else:
				AIList.remove(AIList.find(bot))
				bot.queue_free()

