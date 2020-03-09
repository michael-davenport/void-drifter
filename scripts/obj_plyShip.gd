extends ShipObj

class_name Playership

export(PackedScene) var dontask

var _alive: = true
var _inventory: = []
var _inventory_pointer: = 0
var _selected_hardpoint: = 0

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
		
		if Input.is_action_just_pressed("ui_page_down"):
			if _inventory_pointer < _inventory.size() - 1:
				_inventory_pointer += 1
		
		if Input.is_action_just_pressed("ui_page_up"):
			if _inventory_pointer > 0:
				_inventory_pointer -= 1
		
		if Input.is_action_just_pressed("select_hardpoint_up"):
			if _selected_hardpoint > 0:
				_selected_hardpoint -= 1
		
		if Input.is_action_just_pressed("select_hardpoint_down"):
			if _selected_hardpoint < _wep.size() - 1:
				_selected_hardpoint += 1
		
		if Input.is_action_just_pressed("item_use"):
			use_item()
		
		if Input.is_action_just_pressed("hardpoint_unmount"):
			_wep[_selected_hardpoint].remove_weapon()
		
	if Input.is_action_just_pressed("respawn"):
		respawn()

func on_death():
	visible = false
	_alive = false
	InputVector = Vector2.ZERO
	util.fx_spawn(global_position,rotation,Vector2(2,2),Explod)

func add_inventory(type : int):
	_inventory.push_back(type)

func remove_inventory(type : int):
	_inventory.erase(type)

func find_hardpoint() -> part_hardpoint:
	for x in _wep:
		if is_instance_valid(x):
			if x is part_hardpoint:
				if not is_instance_valid(x._weapon):
					return x
	var ret = _wep[_selected_hardpoint]
	_selected_hardpoint += 1
	if _selected_hardpoint >= _wep.size(): _selected_hardpoint = 0
	return ret

func use_item():
	if _inventory.size() > 0:
		var item = _inventory[_inventory_pointer]
		if data.ITEM_DICT[item].has('UseFunc'):
			var code = data.ITEM_DICT[item].UseFunc
			data.call(code,self,data.ITEM_DICT[item].UseParams)

func respawn():
	print("pen island")
	if not _alive:
		randomize()
		var pos = Vector2((randf()-randf()) * SensorStrength, (randf()-randf()) * SensorStrength)
		pos += global_position
		global_position = pos
		for x in _wep:
			x.remove_weapon()
		_inventory = []
		_inventory.push_back(1)
		_inventory_pointer = 0
		_dmg._health = _dmg.Health
		visible = true
		_alive = true
