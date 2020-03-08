extends Node

class_name gp_AIDirector

export(bool) var Enabled
export(NodePath) var PlayerPath
export(NodePath) var AICPath
export(Array, PackedScene) var BaddieScene
export(int) var StartingEnemiesPerWave = 5
export(float) var StartingWaveSpawnTime = 3
export(float) var StepFactor = 1.5
export(float) var Timefactor = 0.15
export(float) var RestTime = 4.0

var player
var waveno: = 0
var aic : gp_AIController
var spawntime: = 0.0
var spawnremaining: = 0
var curmaxenemy
var curmaxtime

onready var _maxformula = StartingEnemiesPerWave * (1 - (waveno / 50))
onready var _restformula = RestTime * (1 - (waveno / 50))

var spawnradius: = 500.0
var spawnmin: = 0.0

var rest_time: = 0.0

func _ready() -> void:
	if not Enabled: queue_free()
	player = get_node(PlayerPath)
	#aic = get_node(AICPath)
	if not player or (data.EnemyList == null):
		print("AI DIRECTOR MISSING COMPONENTS:\nPlayer: " + str(player) + "\nAI Controller: " + str(data.EnemyList))
		queue_free()
	
	util.CurAIDirector = self
	return

func _process(delta: float) -> void:
	if _maxformula and _restformula:
		rest_time += delta
		if rest_time > _restformula:
			rest_time = 0.0
			if data.EnemyList.size() < _maxformula:
				spawn_baddie()
	return

func spawn_baddie() -> void:
	var dood = util.select_random(BaddieScene).instance()
	var tarpos = player.global_position
	var spawnpos = util.random_point_minmax(tarpos,util.OffscreenMin,util.OffscreenMin * 1.5)
	get_tree().get_current_scene().call_deferred("add_child", dood)
	dood.global_position = spawnpos
	dood.z_index = 2
	util.register_target(player,dood,Color(1,0,0))
	return

func start_wave() -> void:
	curmaxenemy = StartingEnemiesPerWave + (waveno * StepFactor)
	curmaxtime = 1
	spawnremaining = curmaxenemy
	waveno += 1
	return

func spawn_rock() -> void:
	pass
