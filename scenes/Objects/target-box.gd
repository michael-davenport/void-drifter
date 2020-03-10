extends Area2D

export(float) var ScanRadius = 500.0

onready var spurt = $target_box
onready var scan = $scan

var _target : ShipObj

func _ready() -> void:
	scan.shape.radius = ScanRadius

func _process(delta: float) -> void:
	if is_instance_valid(_target):
		rotation = -_target.rotation

func _physics_process(delta: float) -> void:
	if scan.shape.radius == ScanRadius and not is_instance_valid(_target):
		var list = get_overlapping_bodies()
		var plyship = get_tree().get_current_scene().find_node("PlyShip")
		if list.size() > 0:
			if list.size() == 1:
				if list[0] == plyship:
					return
				_target = list[0]
			else:
				#find closest to node
				var curidx = 0
				var curdst = ScanRadius
				for x in list:
					if x.global_position.distance_to(global_position) < curdst:
						curidx = list.find(x)
				_target = list[curidx]
		if is_instance_valid(_target):
			get_parent().remove_child(self)
			_target.add_child(self)
			scale = Vector2(1,1) * _target.ArrowSize
			global_position = _target.global_position
			visible = true
