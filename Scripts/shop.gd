class_name Shop extends Node2D

@export var sep_curve: Curve

const CARD = preload("res://Scenes/Cards/card.tscn")

func _ready() -> void:
	$CanvasLayer/GoldLabel.text = "You have: %s🪙" % Global.Gold
	var e := generate_stock(3)
	add_stock(e)

func _on_leave_button_pressed() -> void:
	SceneManager.change_scene_to_file("res://Scenes/main.tscn")

func generate_stock(amount: int) -> Array[String]:
	var stock: Array[String] = []
	for i in amount:
		# Add a random card from your character's available cards
		stock.append(Global.character_cards[Global.CurrentCharacter].pick_random())
	return stock

func add_stock(stock: Array[String]) -> void:
	var center: Vector2 = get_viewport_rect().size / 2
	for _card in stock:
		var card := CARD.instantiate()
		card.data = load(_card)
		card.show_cost = true
		
		var index := stock.find(_card)
		print(sep_curve.sample(1.0 / (len(stock) - 1) * index))
		$CanvasLayer/CardContainer.add_child(card)
