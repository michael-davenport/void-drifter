extends Node2D

export(float) var ScrollFactor = 0.05
export(NodePath) var Player

onready var _player = get_node(Player)

func _process(delta: float) -> void:
	global_position = _player.global_position * ScrollFactor
	return
