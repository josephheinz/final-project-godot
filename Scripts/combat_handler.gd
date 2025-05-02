class_name CombatHandler extends Node

@export var player: Sprite2D
@export var enemy: Sprite2D

@export var playerStats: Stats
@export var enemyStats: Stats

var player_health_bar: HealthBar
var enemy_health_bar: HealthBar

var player_health: Health
var enemy_health: Health

@onready var cursor = get_parent().get_node("Cursor")
@onready var hand = get_parent().get_node("CardHand/Hand")

func _ready() -> void:
	print("Starting")
	player_health_bar = player.get_node("PlayerHealthBar")
	enemy_health_bar = enemy.get_node("EnemyHealthBar")

	player_health = player_health_bar.HealthComponent
	enemy_health = enemy_health_bar.HealthComponent
	
	player_health_bar.max_value = player_health.maxHealth
	enemy_health_bar.max_value = enemy_health.maxHealth

func combatTick() -> void:
	player_health_bar.value = player_health.health
	enemy_health_bar.value = enemy_health.health
	
	get_parent().get_node("CanvasLayer/Deck Label").text = "Deck: " + str(len(Global.Cards.Deck))
	get_parent().get_node("CanvasLayer/Discard Label").text = "Discard: " + str(len(Global.Cards.Discard))
	
	player.get_node("BlockIcon/BlockLabel").text = str(player_health.block)
	enemy.get_node("BlockIcon/BlockLabel").text = str(enemy_health.block)
	
	if enemy_health.dead:
		SceneManager.change_scene_to_file("res://Scenes/main.tscn")
	if player_health.dead:
		get_tree().free()

func _process(_delta: float) -> void:
	combatTick()

func _input(event) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == 1 and cursor.selecting:
			hand.useCard(cursor.selectedObject)


func _on_button_pressed() -> void:
	hand.draw()
