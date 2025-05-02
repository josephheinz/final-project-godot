extends Marker2D

@onready var hand: Hand = get_parent().get_node("Hand")

func selectCard(card: Node) -> void:
	card.reparent(hand)
	hand._update_cards()
	hand.cursor.enabled = false
	hand.cursor.selectedCard = null
	Global.Cards.Hand.append(Global.Cards.Selected[-1])
	card.get_node("Hover Panel").connect("mouse_exited", card._on_mouse_exited)
	card.get_node("Hover Panel").connect("mouse_entered", card._on_mouse_entered)
