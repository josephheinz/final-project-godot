extends Label

func _ready() -> void:
	text = "Score: %s" % Global.State.player.score
