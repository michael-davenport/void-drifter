extends StaticBody2D

class_name object_gate

export(float) var MaxSpawnDistance

func _ready() -> void:
	var _ply = get_tree().get_current_scene().find_node("PlyShip")
	var _indc = util.register_target(_ply,self,Color(0,1,0))
	
	var pos = Vector2(1,0).rotated(randf() * 2 * PI)
	global_position = pos * MaxSpawnDistance
