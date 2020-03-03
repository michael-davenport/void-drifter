extends CanvasLayer

onready var _text = $Control/VBoxContainer/HBoxTop/Label

func _process(delta: float) -> void:
	if util.CurAIDirector and _text:
		var _aic = util.CurAIDirector as gp_AIDirector
		_text.text = str(
			"Wave: " + str(_aic.waveno) +
			" || Spawn time: " + str(_aic.spawntime) +
			" || Spawn remaining: " + str(_aic.spawnremaining)
		)
