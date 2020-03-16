extends Node2D

class_name gp_starSpawner

export(bool) var Enabled = true
export(int) var MaxStars = 25
export(Array,NodePath) var Sprites
export(Array,NodePath) var StarfieldNode

var StarRadius = sqrt(
	pow(ProjectSettings.get_setting("display/window/size/width"),2) +
	pow(ProjectSettings.get_setting("display/window/size/height"),2)
) * .7

var _starlist : Array
var _player : Playership
var _sprites : Array
var _root : Node2D
var _starfields : Array
var _started: = false

func _ready() -> void:
	if not Enabled: queue_free()
	for x in Sprites:
		_sprites.push_back(get_node(x))
	for x in StarfieldNode:
		_starfields.push_back(get_node(x))

func _process(_delta) -> void:
	if not _player:
		_player = get_node("/root").find_node("Player")
	else:
		if not _started: start_spawner()
		for x in _starlist:
			x = x as Sprite
			var offset = _player.global_position - x.global_position as Vector2
			if offset.length() > (StarRadius):
				x.global_position = util.random_point_circle(_player.global_position,StarRadius)
	return

func start_spawner():
	if not _started:
		while _starlist.size() < MaxStars:
			var offset = (Vector2(randf(), randf()) - Vector2(randf(),randf())) * StarRadius
			var spawnpos = _player.global_position + offset
			var sprite = _sprites[randi() % _sprites.size()].duplicate() #should probably force this to make sure its a sprite
			_root = _starfields[randi() % _starfields.size()]
			_root.call_deferred("add_child",sprite)
			sprite.global_position = spawnpos
			sprite.visible = true
			_starlist.push_back(sprite)
		_started = true
