extends MarginContainer

func _ready() -> void:
	call_deferred("reparent")
	return

func reparent():
	var _cam = get_viewport()
	get_parent().remove_child(self)
	_cam.add_child(self)
