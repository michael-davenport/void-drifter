extends Camera2D

export(float,1,4) var MaxZoomOut = 4.0
export(float,0.5,1) var MaxZoomIn = 0.5

var curzoom: = 1.0
var zoomvec: = Vector2(1.0, 1.0)

func _process(delta: float) -> void:
	rotation = -get_parent().rotation
	if Input.is_action_just_pressed("camera_zoom_in"): curzoom -= 0.25
	if Input.is_action_just_pressed("camera_zoom_out"): curzoom += 0.25
	curzoom = clamp(curzoom,MaxZoomIn,MaxZoomOut)
	zoomvec.x = curzoom
	zoomvec.y = curzoom
	zoom = zoomvec
	return
