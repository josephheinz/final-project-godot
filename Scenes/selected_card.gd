extends Marker2D

@onready var hand: Hand = get_parent().get_node("Hand")

func selectCard(card: Node) -> void:
	card.get_node("Hover Panel").connect("mouse_exited", card._on_mouse_exited)
	card.reparent(hand)
	hand._update_cards()
