extends RigidBody2D

class_name item_base

export(int) var Type
export(Array, NodePath) var SoundPaths

func _ready() -> void:
	contact_monitor = true
	contacts_reported = 1
	connect("body_entered",self,"on_hit")

func on_hit(body):
	if body is obj_ship:
		if Type > 0:
			if body.parts.cargobay.size() <= body.MaxCargo:
				body.add_inventory()
				if SoundPaths.size() > 0:
					get_node(SoundPaths[randi() % SoundPaths.size()]).play()
				queue_free()
		else:
			body.parts.mineralbay += 1
			queue_free()
