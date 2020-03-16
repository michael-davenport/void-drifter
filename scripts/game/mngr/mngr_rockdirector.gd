extends Node

class_name mngr_rockdirector

export(bool) var Enabled = true
export(int) var MaxRocks = 100
export(Array, PackedScene) var Rocks
export(float) var MaxInitVel = 50.0

onready var _root = get_tree().get_current_scene()

var _r: = 0
var _rocks = []
var _oob = sqrt(
	pow(ProjectSettings.get_setting("display/window/size/width"),2) +
	pow(ProjectSettings.get_setting("display/window/size/height"),2)
)
var player

func _ready() -> void:
	if Enabled:
		while _rocks.size() < MaxRocks: _rocks.push_back(spawn_rock_start())
	else:
		queue_free()

func _process(delta: float) -> void:
	if Enabled:
		if is_instance_valid(player):
			for x in _rocks:
				if x:
					if x.global_position.distance_to(player.global_position) > (_oob * 1.5):
						x.marked_for_death = true
			var _arr = []
			for x in _rocks:
				if x.marked_for_death:
					x.queue_free()
				else:
					_arr.push_back(x)
			_rocks = _arr
			while _rocks.size() < MaxRocks:
				_rocks.push_back(spawn_rock())
		else:
			player = _root.find_node("Player")

func spawn_rock():
	randomize()
	var spawnpos = util.random_point_minmax(player.global_position, _oob * 1.05, _oob * 1.5)
	var rock = util.scn_spawn(spawnpos, randf() * 2 * PI, util.select_random(Rocks))
	rock.linear_velocity.x = (randf() - randf() * MaxInitVel)
	rock.linear_velocity.y = (randf() - randf() * MaxInitVel)
	return rock

func spawn_rock_start():
	randomize()
	var spawnpos = util.random_point_minmax(player.global_position, 50, _oob * 1.5)
	var rock = util.scn_spawn(spawnpos, randf() * 2 * PI, util.select_random(Rocks))
	rock.linear_velocity.x = (randf() - randf() * MaxInitVel)
	rock.linear_velocity.y = (randf() - randf() * MaxInitVel)
	return rock
