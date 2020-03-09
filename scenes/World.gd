extends Node2D

func _ready() -> void:
	$TextureRect.modulate = Color(randf(),randf(),randf(),randf() * 0.3)
	$TextureRect2.modulate = Color(randf(),randf(),randf(),randf() * 0.3)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	return
