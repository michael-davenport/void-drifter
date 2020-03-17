extends Node2D

export(PackedScene) var PlayersceneExport
export(PackedScene) var NebulaScene = preload("res://scenes/FX/nebula.tscn")
export(PackedScene) var Background = preload("res://scenes/FX/black_bg.tscn")
export(int) var NebulaLayers
export(float) var NebulaMinScroll
export(float) var NebulaMaxScroll 
export(float,0,1) var NebulaMaxOpacity = 0.2
export(int) var StarLayers
export(float) var StarMinScroll
export(float) var StarMaxScroll

var playerscene : PackedScene

func _ready() -> void:
	#Spawn player at 0,0
	var pscene = PlayersceneExport
	if playerscene: pscene = playerscene
	var player = util.scn_spawn(Vector2.ZERO,0,pscene)
	var controller = part_controller.new()
	player.set_name("Player")
	player.add_child(controller)
	player.parts.controller = controller
	player.add_inventory(1)
	player.add_inventory(1)
	
	#Spawn the black background
	var bg = util.scn_spawn(player.global_position,0,Background)
	bg.z_index = -100
	bg.player = player.parts.controller.CamNode
	
	#Spawn background funsies
	if NebulaScene:
		var i = 0
		for i in range(NebulaLayers):
			var scroll = NebulaMinScroll + ((NebulaMaxScroll - NebulaMinScroll) / NebulaLayers) * i
			var neb = util.scn_spawn(player.global_position,0,NebulaScene) as vfx_nebula
			neb.scroll_divisor = scroll
			neb.player = player.parts.controller.CamNode
			neb.z_index = -99 + i
			
			randomize()
			neb.modulate.r = randf()
			randomize()
			neb.modulate.g = randf()
			randomize()
			neb.modulate.b = randf()
			randomize()
			neb.modulate.a = randf() * NebulaMaxOpacity

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	return
