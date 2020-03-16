extends Sprite

var player


func _process(delta: float) -> void:
	if is_instance_valid(player):
		global_position = player.global_position
	else:
		player = get_node("/root/").find_node("Player")
