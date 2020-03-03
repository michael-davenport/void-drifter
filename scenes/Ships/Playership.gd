extends ShipBase
class_name PlayershipOld

export(Array,NodePath) var Weapons
export(NodePath) var CameraPath

onready var _camera = get_node(CameraPath) as Camera2D
onready var _ui_l_shield = $Camera2D/UILayer/VBoxContainer/HBoxContainer2/l_shield
onready var _ui_l_armor = $Camera2D/UILayer/VBoxContainer/HBoxContainer2/l_armor
onready var _ui_l_gun = $Camera2D/UILayer/VBoxContainer/HBoxContainer2/l_gun
onready var _ui_pb_shield = $Camera2D/UILayer/VBoxContainer/HBoxContainer/pb_shield
onready var _ui_pb_armor = $Camera2D/UILayer/VBoxContainer/HBoxContainer/pb_armor
onready var _ui_pb_gun = $Camera2D/UILayer/VBoxContainer/HBoxContainer/pb_gun
onready var _ui_dbtext = $Camera2D/UILayer/DebugText

func _ready() -> void:
	_ui_pb_armor.max_value = DamageHandler.Health
	_ui_pb_shield.max_value = DamageHandler.Shield
	_ui_pb_gun.max_value = get_node(Weapons[0]).AmmoCapacity
	return

func _process(delta: float) -> void:
	InputVector = Vector2(
		Input.get_action_strength("Thrust_Up") - Input.get_action_strength("Thrust_Down"),
		Input.get_action_strength("Thrust_Right") - Input.get_action_strength("Thrust_Left"))
	TargetPos = get_global_mouse_position()
	if Input.is_action_pressed("Pew"):
		if Weapons.size() > 0:
			for x in Weapons:
				get_node(x).fire()
	if Input.is_action_just_pressed("ui_cancel"):
		print("Manual breakpoint pressed!")
	
	_camera.rotation = -rotation
	_ui_pb_shield.value = DamageHandler.sp.Shield
	_ui_pb_armor.value = DamageHandler.hp.Health
	_ui_pb_gun.value = get_node(Weapons[0])._ammo
	_ui_dbtext.text = str(Velocity)
	return

func _physics_process(delta: float) -> void:
	if InputVector != Vector2.ZERO:
		$ShipSprite/Engine_R.visible = true
		$ShipSprite/Engine_R/AnimatedSprite.playing = true
		$ShipSprite/Engine_L.visible = true
		$ShipSprite/Engine_L/AnimatedSprite.playing = true
	else:
		$ShipSprite/Engine_R.visible = false
		$ShipSprite/Engine_L.visible = false
	return

func on_death():
	print("PLAYER DED")
	queue_free()
	return
