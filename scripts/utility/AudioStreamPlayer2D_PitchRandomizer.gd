extends AudioStreamPlayer2D

export(float) var MinPitch = 0.8
export(float) var MaxPitch = 1.2

func _ready() -> void:
	connect("finished",self,"on_finished")
	on_finished()
	return

func on_finished() -> void:
	var _scl = (randf() - randf()) * (MaxPitch-MinPitch)
	pitch_scale = 1.0 + _scl
	return
