extends ColorRect

var alpha: = 0.0
export(Vector2) var bounds = Vector2(64,64)
export(PackedScene) var SelfScene

var _neighbor = []

func _ready() -> void:
	color = Color(color.r,color.b,color.g,alpha)
	return
	
func update_color(c : Color) -> Color:
	color = c
	return color

func _grow():
	for i in range(4):
		if not _neighbor[i]:
			var _root = get_tree().get_current_scene()
			var _neb = SelfScene.instance()
			var _pos = Vector2.ZERO
			_root.call_deferred("add_child",_neb)
			match i:
				0: _pos = Vector2(rect_global_position.x, rect_global_position.y - bounds.y)
				1: _pos = Vector2(rect_global_position.x - bounds.x, rect_global_position.y)
				2: _pos = Vector2(rect_global_position.x, rect_global_position.y + bounds.y)
				3: _pos = Vector2(rect_global_position.x + bounds.x, rect_global_position.y)
				_: print("NEBTILE ERROR: Invalid neighbor")
	return
