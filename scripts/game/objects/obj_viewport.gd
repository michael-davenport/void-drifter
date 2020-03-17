extends Node2D

var cam
var inv_text
var player

func _ready() -> void:
	var n = []
	util.get_all_children(self, n)
	if n.size() > 0:
		for x in n:
			if x is Camera2D: cam = x
			if x is RichTextLabel: inv_text = x
	player = get_node("/root/World/Player") #No fuckin clue why this only works like 10% of the time
	inv_text = $Camera2D/UILayer/Control/HBoxContainer/Panel/InvText
	if not cam == null:
		cam.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
		cam.process_mode = Camera2D.CAMERA2D_PROCESS_IDLE
	else:
		print("ERROR: obj_viewport spawned with no camera node in its scene. Deleting...")
		queue_free()

func _process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		player = util.world.find_node("Player")
	else:
		
		#Handle inventory UI
		if not inv_text == null:
			inv_text.text = "Cargo bay:\n"
			if player.parts.cargobay.size() > 0:
				var i
				for i in range(0,player.parts.cargobay.size()):
					var addtext = data.ITEM_DICT[player.parts.cargobay[i]].DisplayName
					if i == player.parts.controller.CargoPointer:
						inv_text.text += "<< " + addtext + " >>\n"
					else:
						inv_text.text += addtext + "\n"
		
		#Handle hardpoint UI (basically same shit)
		
