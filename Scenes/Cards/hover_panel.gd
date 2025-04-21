extends Panel

func _on_mouse_entered() -> void:
	get_parent().hovered = true
	if is_instance_of(get_parent(), Hand):
		get_parent().get_parent()._update_cards()

func _on_mouse_exited() -> void:
	get_parent().hovered = false
	if is_instance_of(get_parent(), Hand):
		get_parent().get_parent()._update_cards()
