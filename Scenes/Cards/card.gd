class_name Card
extends Panel

const SIZE := Vector2(150, 210)

@export var text: String
@export var hovered: bool = false
@onready var label: Label = $Label

func _ready() -> void:
	label.text = text

func _on_mouse_entered() -> void:
	hovered = true
	if is_instance_of(get_parent(), Hand):
		get_parent()._update_cards()

func _on_mouse_exited() -> void:
	hovered = false
	if is_instance_of(get_parent(), Hand):
		get_parent()._update_cards()
