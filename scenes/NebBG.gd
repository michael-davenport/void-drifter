extends Node2D

class_name vfx_nebula

export(float) var scroll_divisor = 320
export(Vector2) var Offset = Vector2(-1024,-1024)

onready var neb = $TextureRect

var player

func _process(_delta: float) -> void:
	if is_instance_valid(player):
		neb.rect_global_position = player.global_position + Offset
		neb.material.set_shader_param("g_offset_x" , player.global_position.x / scroll_divisor)
		neb.material.set_shader_param("g_offset_y" , player.global_position.y / scroll_divisor)
	else:
		player = get_tree().get_current_scene().find_node("Player")
	return
