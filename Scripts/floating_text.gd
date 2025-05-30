extends Marker2D

@onready var label = $Label
@onready var tween = get_tree().create_tween().bind_node(self)
var amount = 0
var color = Color.RED

func _ready() -> void:
	label.text = str(amount)
	label.add_theme_color_override("font_color",color)
	
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	tween.tween_property(self, "scale", Vector2(0.1, 0.1), 0.7).set_delay(0.3)
	await tween.finished
	self.queue_free()
