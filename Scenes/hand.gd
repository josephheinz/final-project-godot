class_name Hand
extends ColorRect

const CARD = preload("res://Scenes/Cards/card.tscn")

@export var hand_curve: Curve
@export var rotation_curve: Curve

@export var max_rotation_degrees := 5
@export var x_sep: float = -10
@export var y_min: float = 0
@export var y_max: float = -15
@export var hover_amount: float = 15

@onready var selectedCard: Marker2D = get_parent().get_node("Selected Card")

func draw() -> void:
	var new_card := CARD.instantiate()
	new_card.text = "Card %s" % (get_child_count() + 1)
	add_child(new_card)
	_update_cards()
	
func discard() -> void:
	if get_child_count() < 1:
		return
	
	var child := get_child(-1)
	child.reparent(get_tree().root)
	child.queue_free()
	_update_cards()

func _update_cards() -> void:
	var cards := get_child_count()
	print(cards)
	var all_cards_size: float = cards * Card.SIZE.x + x_sep * (cards - 1)
	var final_x_sep: float = x_sep
	
	if all_cards_size > size.x:
		final_x_sep = (size.x - Card.SIZE.x * cards) / (cards - 1)
		all_cards_size = size.x
	
	var offset: float = (size.x - all_cards_size) / 2
	
	for i in cards:
		var card := get_child(i)
		if card.get_parent() != self:
			continue
		var tween: Tween = create_tween()
		var y_multiplier := hand_curve.sample(1.0 / (cards - 1) * i)
		var rot_multiplier := rotation_curve.sample(1.0 / (cards - 1) * i)
		
		if cards == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0
		
		var final_x: float = offset + Card.SIZE.x * i + final_x_sep * i
		var final_y: float = y_min + y_max * y_multiplier
		
		tween.tween_property(card, "position", Vector2(final_x, final_y), 0.1).set_trans(Tween.TRANS_QUAD)
		#tween.parallel().tween_property(card, "rotation_degrees", max_rotation_degrees * rot_multiplier, 0.1).set_trans(Tween.TRANS_QUART)
		
		#card.position = Vector2(final_x, final_y)
		card.rotation_degrees = max_rotation_degrees * rot_multiplier
		
		card.z_index = i
		card.scale = Vector2i(1, 1)
		
		if card.hovered:
			#tween.tween_property(card, "rotation_degrees", 0, 0.1).set_trans(Tween.TRANS_QUART)
			card.rotation_degrees = 0
			var cardUp: Vector2 = card.get_global_transform().y.normalized()
			card.position = Vector2(
				card.position.x - cardUp.x * hover_amount, 
				card.position.y - cardUp.y * hover_amount
			)
			#tween.parallel().tween_property(card, "position", Vector2(
			#	card.position.x - cardUp.x * hover_amount, 
			#	card.position.y - cardUp.y * hover_amount
			#), 0.1).set_trans(Tween.TRANS_QUART)
			#tween.parallel().tween_property(card, "scale", Vector2(1.25, 1.25), 0.05).set_trans(Tween.TRANS_QUART)
			card.scale = Vector2(1.25, 1.25)
			card.z_index = 1000

func _ready() -> void:
	draw()
	draw()
	draw()
	draw()

func selectCard(card: Node) -> void:
	if selectedCard.get_child_count() > 0:
		return
	#reparent selected card and reposition it
	card.get_node("Hover Panel").disconnect("mouse_exited", card._on_mouse_exited)
	card.reparent(selectedCard, false)
	
	card.hovered = false
	card.position = -card.SIZE / 2
	card.rotation_degrees = 0
	
	_update_cards()
