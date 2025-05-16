class_name Shop extends Node2D

const CARD = preload("res://Scenes/Cards/card.tscn")

var stock: Array[Dictionary] = []

func _ready() -> void:
	$CanvasLayer/GoldLabel.text = "You have: %s Gold" % Global.State.player.gold
	stock = generate_stock(3)
	add_stock(stock)

func _on_leave_button_pressed() -> void:
	SceneManager.change_scene_to_file("res://Scenes/main.tscn")

func generate_stock(amount: int) -> Array[Dictionary]:
	var Stock: Array[Dictionary] = []
	for i in amount:
		# Add a random card from your character's available cards
		Stock.append({
			"res" : Global.character_cards[Global.State.player.character].pick_random(),
			"selected": false
		})
	return Stock

func add_stock(Stock: Array[Dictionary]) -> void:
	for _card in Stock:
		var card := CARD.instantiate()
		card.data = load(_card.res)
		card.show_cost = true
		
		$CanvasLayer/CardContainer.add_child(card)

func _process(_delta: float) -> void:
	var children := $CanvasLayer/CardContainer.get_children()
	if children.is_empty():
		return
	for card in children:
		var index := children.find(card)
		if stock[index].selected:
			card.scale = Vector2(1.1, 1.1)
		else:
			card.scale = Vector2(1, 1)

func selectCard(card: Node) -> void:
	var index := $CanvasLayer/CardContainer.get_children().find(card)
	
	stock[index].selected = not stock[index].selected

func _on_buy_button_pressed() -> void:
	var selected : Array[Dictionary] = []
	for card in stock:
		if card.selected:
			selected.append(card)
	
	var total_cost: int = 0
	
	for card in selected:
		total_cost += load(card.res).basePrice
	
	if Global.State.player.gold >= total_cost:
		Global.State.player.gold -= total_cost
		for card in selected:
			Global.Cards.Deck.append(card.res)
		SceneManager.change_scene_to_file("res://Scenes/main.tscn")
	else:
		return
