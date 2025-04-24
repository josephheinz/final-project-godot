class_name CombatHandler extends Node

@export var player: Sprite2D
@export var enemy: Sprite2D

@export var playerStats: Stats
@export var enemyStats: Stats

var player_health_bar: HealthBar
var enemy_health_bar: HealthBar

var player_health: Health
var enemy_health: Health

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

func _process(delta: float) -> void:
	combatTick()
