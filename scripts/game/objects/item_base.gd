extends RigidBody2D

class_name item_base

export(int) var Type
export(Array, NodePath) var SoundPaths

func _ready() -> void:
	contact_monitor = true
	contacts_reported = 1
	connect("body_entered",self,"on_hit")

func on_hit(body):
	if body is Playership:
		if Type == data.ITEM_TYPE.mineral:
			body._mineralbay += 1
		else:
			#body._inventory.push_back(Type)
			body.add_inventory(Type)
		if SoundPaths.size() > 0:
			get_node(SoundPaths[randi() % SoundPaths.size()]).play()
		queue_free()
