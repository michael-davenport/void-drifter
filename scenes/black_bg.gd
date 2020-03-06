extends Sprite

var _fuck

func _ready() -> void:
	_fuck = get_tree().get_current_scene().find_node("PlayerCam")

func _process(delta: float) -> void:
	if _fuck:
		global_position = _fuck.global_position
	else: print("need fuck")
