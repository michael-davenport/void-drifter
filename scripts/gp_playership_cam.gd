extends Camera2D

export(NodePath) var ShipPath
export(NodePath) var UIControl
export(float) var LookAhead = 350.0
export(float) var VelBias = 0.5
export(float) var Speed = 4.0

onready var _ship = get_node(ShipPath) as ShipObj
onready var _ctrl = get_node(UIControl) as CanvasLayer
onready var _shipdmg = _ship._dmg as part_dmghandler
onready var _aid = get_node("/root").find_node("gp_AIDirector")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if _ship:
		var _pos : Vector2
		_pos = _ship.global_position + _ship.linear_velocity * VelBias
		var _mp: = get_viewport().get_mouse_position()
		_mp.x = ((_mp.x / ProjectSettings.get_setting("display/window/size/width")) - 0.5)*2
		_mp.y = ((_mp.y / ProjectSettings.get_setting("display/window/size/height")) - 0.5)*2
		_pos += _mp * LookAhead
		global_position = global_position.linear_interpolate(_pos, delta * Speed)
		
		var hullbar = _ctrl.find_node("Hull") as ProgressBar
		var wepnbar = _ctrl.find_node("Weapon") as ProgressBar
		var shldbar = _ctrl.find_node("Shield") as ProgressBar
		var minlbay = _ctrl.find_node("MINERALBAY") as Label
		
		if hullbar:
			hullbar.max_value = _shipdmg.Health
			hullbar.value = _shipdmg._health
		
		if shldbar:
			shldbar.max_value = _shipdmg._shield.MaxHP
			shldbar.value = _shipdmg._shield._hp
		
		if wepnbar:
			var wpn = _ship._wep[0]
			wepnbar.max_value = wpn.MaxAmmo
			wepnbar.value = wpn._ammo
		
		if minlbay:
			minlbay.text = "Minerals: " + str(_ship._mineralbay)
		
		if Input.is_action_just_pressed("camera_zoom_in"):
			zoom -= Vector2(0.25,0.25)
		if Input.is_action_just_pressed("camera_zoom_out"):
			zoom += Vector2(0.25,0.25)
	return
