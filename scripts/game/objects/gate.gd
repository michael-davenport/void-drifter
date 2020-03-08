extends KinematicBody2D

class_name object_gate

export(float,0,65535) var MinSpawnDistance = 2500
export(float,0,65535) var MaxSpawnDistance

func _ready() -> void:
	var _ply = get_tree().get_current_scene().find_node("PlyShip")
	var _indc = util.register_target(_ply,self,Color(0,1,0))
	if MinSpawnDistance > MaxSpawnDistance: MinSpawnDistance = MaxSpawnDistance
	if MaxSpawnDistance < MinSpawnDistance: MaxSpawnDistance = MaxSpawnDistance
	
	randomize()
	var pos = Vector2(1,0).rotated(rand_range(0,2*PI))
	print(str(pos))
	global_position = pos * rand_range(MinSpawnDistance,MaxSpawnDistance)
