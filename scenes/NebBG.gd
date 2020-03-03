extends TextureRect

export(float) var scroll_divisor = 320
export(NodePath) var Player
export(Vector2) var Offset = Vector2(-1024,-1024)

var _player

func _ready() -> void:
	_player = get_node(Player)
	return

func _process(_delta: float) -> void:
	rect_global_position = _player.global_position + Offset
	self.material.set_shader_param("g_offset_x" , _player.global_position.x / scroll_divisor)
	self.material.set_shader_param("g_offset_y" , _player.global_position.y / scroll_divisor)
	return
