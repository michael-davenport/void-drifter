extends Node2D

#Player controller
class_name part_controller

var InputVector : Vector2
var MousePos : Vector2
var CargoPointer: = 0
var HardPointer: = 0
var CamNode
var Zoomfactor = 0.25
var COffset = Vector2.ZERO

signal try_use
signal try_fire
signal try_unmount
signal try_respawn
signal try_target

func _ready() -> void:
	CamNode = util.scn_spawn(Vector2.ZERO,0,load("res://scenes/Objects/obj_viewport.tscn"))
	if get_parent():
		CamNode.global_position = get_parent().global_position
		COffset = get_parent().global_position
	#CamNode = Camera2D.new()
	#get_tree().get_current_scene().add_child(CamNode)
	#CamNode.make_current()
	#CamNode.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	#CamNode.process_mode = Camera2D.CAMERA2D_PROCESS_IDLE
	#if get_parent():
	#	CamNode.global_position = get_parent().global_position
	#	COffset = get_parent().global_position

func _process(delta: float) -> void:
	#Validate the parent and other critical properties
	var Ship = get_parent()
	if Ship.get('parts') == null: return
	if Ship.get('status') == null: return
	if not is_instance_valid(Ship): return
	if not is_instance_valid(CamNode): return
	
	#Fluid inputs
	MousePos = get_global_mouse_position()
	InputVector = Vector2(
		Input.get_action_strength("Thrust_Up") - Input.get_action_strength("Thrust_Down"),
		Input.get_action_strength("Thrust_Right") - Input.get_action_strength("Thrust_Left")
	)
	if Input.is_action_pressed("Pew"):
		emit_signal("try_fire")
			
	#Cargo bay stuff
	if Ship.parts.cargobay.size() > 0:
		if Input.is_action_just_pressed("select_cargo_down"):
			if CargoPointer < Ship.parts.cargobay.size() - 1:
				CargoPointer += 1
		if Input.is_action_just_pressed("select_cargo_up"):
			if CargoPointer > 0:
				CargoPointer -= 1
		if Input.is_action_just_pressed("item_use"):
			emit_signal("try_use",CargoPointer)
	
	#Hardpoint stuff
	if Ship.parts.hardpoint.size() > 0:
		if Input.is_action_just_pressed("select_hardpoint_down"):
			if HardPointer < Ship.parts.hardpoint.size() - 1:
				HardPointer += 1
		if Input.is_action_just_pressed("select_hardpoint_up"):
			if HardPointer > 0:
				HardPointer -= 1
		if Input.is_action_just_pressed("hardpoint_unmount"):
			emit_signal("try_unmount",HardPointer)
	
	#Camera work
	var pos = Ship.global_position
	COffset = lerp(COffset,(MousePos - Ship.global_position) * Zoomfactor,0.15)
	CamNode.global_position = pos + COffset
	#var offset = (MousePos - Ship.global_position) * Zoomfactor
	#CamNode.global_position = lerp(CamNode.global_position, pos + offset, .05)
	
	#Others
	if Input.is_action_just_pressed("respawn"):
		if Ship.status.alive == false:
			emit_signal("try_respawn")
	
	if Input.is_action_just_pressed("target-boresight"):
		if Ship.status.alive == true:
			emit_signal("try_target",MousePos)
