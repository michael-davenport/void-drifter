extends AudioStreamPlayer2D

class_name asp2d_random

export(float) var MinPitch = 0.8
export(float) var MaxPitch = 1.2

func play_rnd():
	var _scl = (randf() - randf()) * (MaxPitch-MinPitch)
	pitch_scale = 1.0 + _scl
	play()
