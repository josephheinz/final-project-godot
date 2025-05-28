class_name CombatHandler extends Node

@export var player: Sprite2D
@export var enemy: Sprite2D

@export var playerStats: Stats
@export var enemyStats: Stats

var player_health_bar: HealthBar
var enemy_health_bar: HealthBar

var player_health: Health
var enemy_health: Health

var Enemy: enemy

var cards_per_turn: int = 2

var combat_type: float = 1

signal player_no_more_cards

@onready var cursor = get_parent().get_node("Cursor")
@onready var hand = get_parent().get_node("CardHand/Hand")

func _ready() -> void:
	match get_parent().name:
		"Combat":
			combat_type = 1
		"Elite Combat":
			combat_type = 1.25
		"Boss Battle":
			combat_type = 1.75
			
	player_health_bar = player.get_node("PlayerHealthBar")
	enemy_health_bar = enemy.get_node("EnemyHealthBar")		
	
	Enemy = Global.enemies[combat_type].pick_random()
	var _temp_health: Health = Enemy.make_health_comp()
	enemy_health_bar.HealthComponent.set_values(Health.get_values(_temp_health))
	
	player_health = player_health_bar.HealthComponent
	player_health.set_values(Global.State.player.stats)
	
	enemy_health = enemy_health_bar.HealthComponent
	
	player_health_bar.max_value = player_health.maxHealth
	enemy_health_bar.max_value = enemy_health.maxHealth
	
	get_parent().get_node("CombatEnemy").texture = load(Enemy.enemyImage)
	get_parent().get_node("CombatEnemy/Name").text = Enemy.name
	
	get_parent().get_node("CombatPlayer").texture = Global.character_sprites[Global.State.player.character]
	
	player_turn()

func enemy_turn() -> void:
	var attack_damage: int = Global.RNG.randi_range(1, (player_health.maxHealth) / 5) * combat_type
	print(attack_damage)
	player_health.damage(attack_damage)
	
	player_turn()

func player_turn() -> void:
	cards_per_turn = 2
	if len(Global.Cards.Hand) <= 0:
		hand.reset_deck()
		hand.draw()
		hand.draw()
	
	for i in range(2):
		hand.draw()
	
	await player_no_more_cards
	
	await get_tree().create_timer(1.5).timeout
	
	enemy_turn()

func combatTick() -> void:
	player_health_bar.value = player_health.health
	enemy_health_bar.value = enemy_health.health
	
	get_parent().get_node("CanvasLayer/Deck Label").text = "Deck: " + str(len(Global.Cards.Deck))
	get_parent().get_node("CanvasLayer/Discard Label").text = "Discard: " + str(len(Global.Cards.Discard))
	get_parent().get_node("CanvasLayer/Cards Left Label").text = "Cards Left This Turn: %s" % str(cards_per_turn)
	
	player.get_node("BlockIcon/BlockLabel").text = str(player_health.block)
	enemy.get_node("BlockIcon/BlockLabel").text = str(enemy_health.block)
	
	Global.State.player.stats = Health.get_values(player_health)
	
	if enemy_health.dead:
		hand.reset_deck()
		Global.State.player.gold += Global.RNG.randi_range(0, 5) * combat_type
		if combat_type == 1.75:
			Global.progress_floor()
		SceneManager.change_scene_to_file("res://Scenes/main.tscn")
	if Global.State.player.stats.dead:
		SceneManager.change_scene_to_file("res://Scenes/game_over_screen.tscn")

func _process(_delta: float) -> void:
	combatTick()

func _input(event) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == 1 and cursor.selecting and cards_per_turn > 0:
			hand.useCard(cursor.selectedObject)
			cards_per_turn -= 1
			if cards_per_turn <= 0:
				player_no_more_cards.emit()


func _on_button_pressed() -> void:
	hand.draw()


func _on_end_turn_button_pressed() -> void:
	enemy_turn()
