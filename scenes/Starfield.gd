extends Node2D

export(float) var ScrollFactor = 0.05
var player

func _process(delta: float) -> void:
	if is_instance_valid(player):
		global_position = player.global_position * ScrollFactor
	else:
		player = get_node("/root/World/Player")
	return
