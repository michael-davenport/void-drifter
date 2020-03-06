extends Node2D

export(NodePath) var FollowNode

onready var _follow = get_node(FollowNode)

func _process(delta: float) -> void:
	if _follow:
		global_position = _follow.global_position
	else:
		_follow = get_node(FollowNode)
		print("looking for follow")
