extends ShipObj

class_name Playership

export(PackedScene) var dontask

var _alive: = true
var _inventory: = []

func _process(_delta: float) -> void:
	if _alive:
		InputVector = Vector2(
		Input.get_action_strength("Thrust_Up") - Input.get_action_strength("Thrust_Down"),
		Input.get_action_strength("Thrust_Right") - Input.get_action_strength("Thrust_Left"))
		
		TarPos = get_global_mouse_position()
		var _mp: = get_viewport().get_mouse_position()
		_mp.x = ((_mp.x / ProjectSettings.get_setting("display/window/size/width")) - 0.5)*2
		_mp.y = ((_mp.y / ProjectSettings.get_setting("display/window/size/height")) - 0.5)*2
		
		if Input.is_action_pressed("Pew"):
			if _wep.size() > 0:
				for x in _wep:
					x.fire()
		
		if Input.is_action_just_pressed("camera_zoom_in"):
			pass

func on_death():
	visible = false
	_alive = false
	InputVector = Vector2.ZERO
	util.fx_spawn(global_position,rotation,Vector2(2,2),Explod)
