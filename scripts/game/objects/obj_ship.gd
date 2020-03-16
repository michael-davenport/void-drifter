extends RigidBody2D

class_name obj_ship

export(float) var MaxTorque = 150000

#components
var parts = {
	thruster = [],
	shield = null,
	hardpoint = [],
	sensor = null,
	dmghandler = null,
	controller = null, #note: this gets registered after spawn unless it is part_fsm
	cargobay = []
}

var status = {
	alive = true,
	target = null,
	maxthrust = Vector2.ZERO,
	forward = Vector2(1,0),
	torque = 0.0
}

var READY: = false

func _ready() -> void:
	#Register all attached parts in the scene tree
	var n = []
	util.get_all_children(self,n)
	for x in n:
		if x is part_thruster: register_thruster(x)
		if x is part_shield: parts.shield = x
		if x is part_hardpoint: parts.hardpoint.append(x)
		if x is part_sensor: parts.sensor = x
		if x is part_fsm: register_fsm(x)
	for x in n:
		if x is part_dmghandler:
			register_dmghandler(x)
			break
	READY = true
	if parts.dmghandler == null:
		print("WARNING: " + str(self) + " ship spawned with no damage handler.")

func _physics_process(delta: float) -> void:
	#Validate
	if not READY or parts.controller == null: return #Abort if we are not ready
	if not is_instance_valid(parts.controller): return
	
	#Update physical status
	status.forward = Vector2(1,0).rotated(rotation)
	
	#Read controller's input and apply thrust and effects
	apply_torque_impulse(get_angle_to(parts.controller.MousePos) * status.torque * delta)
	if not parts.controller.InputVector == Vector2.ZERO:
		#Figure base factors
		var thrust = (status.maxthrust * parts.controller.InputVector).rotated(global_rotation)
		#Apply forces and modifiers
		apply_central_impulse(status.forward * parts.controller.InputVector.x * status.maxthrust.x * delta)
		apply_central_impulse(status.forward.rotated(PI/2) * parts.controller.InputVector.y * status.maxthrust.y * delta)
		#Do vfx stuff
		if parts.thruster.size() > 0:
			for x in parts.thruster:
				x.exhaust.visible = true
	else:
		if parts.thruster.size() > 0:
			for x in parts.thruster:
				x.exhaust.visible = false
	
	#Update input-independent vfx
	for x in parts.thruster:
		x.audio.pitch_scale = clamp(linear_velocity.length() / 750,0.001,1)

func register_controller(controller):
	parts.controller = controller
	parts.controller.connect("try_fire",self,"try_fire")
	parts.controller.connect("try_use",self,"try_use")
	parts.controller.connect("try_unmount",self,"try_unmount")
	parts.controller.connect("try_respawn",self,"try_respawn")
	parts.controller.connect("try_target",self,"try_target")

func register_fsm(controller):
	parts.controller = controller

func register_thruster(thruster):
	parts.thruster.append(thruster)
	status.maxthrust.x += thruster.ThrustForce.x
	status.maxthrust.y += thruster.ThrustForce.y
	status.torque += thruster.Torque
	mass += thruster.Mass
	if status.torque > MaxTorque:
		status.torque = MaxTorque

func register_dmghandler(dmghandler):
	parts.dmghandler = dmghandler
	if is_instance_valid(parts.shield):
		parts.dmghandler._shield = parts.shield

func register_hardpoint(hardpoint):
	hardpoint._parent = self
	parts.hardpoint.append(hardpoint)

func try_fire():
	if parts.hardpoint.size() > 0:
		for x in parts.hardpoint:
			x.fire()

func try_use(pointer : int):
	pass

func try_unmount(pointer : int):
	pass

func try_respawn():
	pass

func try_target():
	pass

func add_inventory():
	pass
