extends RigidBody2D

export(data.ITEM_TYPE) var Type
export(Array, NodePath) var SoundPaths

func _ready() -> void:
	contact_monitor = true
	contacts_reported = 1
	connect("body_entered",self,"on_hit")

func on_hit(body):
	if body is Playership:
		body._inventory.push_back(Type)
		if SoundPaths.size() > 0:
			get_node(SoundPaths[randi() % SoundPaths.size()]).play()
		queue_free()
