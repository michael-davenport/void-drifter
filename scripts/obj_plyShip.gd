extends ShipObj

class_name Playership

export(PackedScene) var dontask

var _alive: = true
var _inventory: = []
var _inventory_pointer: = 0
var _selected_hardpoint: = 0
var tbox = preload("res://scenes/Objects/target-box.tscn")
var tscan = preload("res://scenes/Objects/boresight-scan.tscn")
var _target_indicator
var _target

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
		
		if Input.is_action_just_pressed("target-boresight"):
			target_boresight()
		
		update_tbox()
		
	if Input.is_action_just_pressed("respawn"):
		respawn()
	
	if is_instance_valid(_target_indicator):
		if is_instance_valid(_target_indicator.get_parent()):
			if _target_indicator.get_parent() is RigidBody2D:
				_target = _target_indicator.get_parent()
				if is_instance_valid(_target):
					if _target._iff == 1:
						_target_indicator.modulate = Color(1,0,0)
					_target_indicator.scale = Vector2(1,1) * clamp(_target.ArrowSize,1,5)
			else:
				_target = null
			if _target_indicator.get_parent() == self:
				_target = null
				_target_indicator.queue_free()
				_target_indicator = null
		else:
			_target = null
			_target_indicator.queue_free()
			_target_indicator = null
	else:
		_target = null

func on_death():
	visible = false
	_alive = false
	InputVector = Vector2.ZERO
	util.fx_spawn(global_position,rotation,Vector2(2,2),Explod)
	reset_target()

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
		reset_target()
		visible = true
		_alive = true

func target_boresight():
#	var pos = get_global_mouse_position()
#	if _target_indicator:
#		_target_indicator.queue_free()
#	_target_indicator = util.scn_spawn(pos,0,tbox)
#	pass
	var scan = util.scn_spawn(get_global_mouse_position(),0,tscan)
	yield(get_tree().create_timer(0.1),"timeout")
	find_target(scan)

func find_target(scanner : Area2D):
	reset_target()
	var list = scanner.get_overlapping_bodies()
	if list.find(self): list.erase(self)
	if list.size() > 0:
		for x in list:
			if x is ShipObj:
				_target = x
				_target_indicator = util.scn_spawn_parented(_target.global_position,0,tbox,_target)
				break

func update_tbox():
	if is_instance_valid(_target_indicator):
		if is_instance_valid(_target):
			_target_indicator.rotation = -_target.rotation
			if is_instance_valid(_target_indicator.tli):
				#tgt.global_position + ((tgt.linear_velocity - ship.linear_velocity) * (dst / ship._wep[0].MuzVelocity))
				var tli = _target_indicator.tli
				var dst = global_position.distance_to(_target.global_position)
				var pos = Vector2.ZERO
				if is_instance_valid(_wep[_selected_hardpoint]._weapon):
					pos = (_target.linear_velocity - linear_velocity) * (dst / _wep[_selected_hardpoint]._weapon.MuzVelocity)
					pos = pos/_target_indicator.scale.x
				tli.position = pos
		else:
			reset_target()

func reset_target():
	if is_instance_valid(_target_indicator):
		_target_indicator.queue_free()
		_target_indicator = null
	_target = null
