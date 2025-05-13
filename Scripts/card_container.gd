extends HBoxContainer

func selectCard(card: Node) -> void:
	get_parent().get_parent().selectCard(card)
