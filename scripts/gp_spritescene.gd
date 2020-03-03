extends AnimatedSprite

class_name gp_spriteScene

export var KillFrame: = 5
export var KillTime: = 0.0

var _t = 0.0

func _ready() -> void:
	play()

func _process(delta: float) -> void:
	if KillTime == 0.0:
		if frame == KillFrame: queue_free()
	else:
		if _t >= KillTime: queue_free()
	_t += delta
	return
