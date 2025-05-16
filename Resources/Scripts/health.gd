class_name Health extends Node

var parent: Node

func _ready() -> void:
	parent = get_parent()

@export_group("Settings")
@export var maxHealth: int
@export var health: int:
	set(value):
		health = clamp(value, 0, maxHealth)
		if health <= 0:
			dead = true
	get:
		return health
@export var dead: bool = false:
	set(value):
		if health > 0:
			dead = false
		else:
			dead = value
	get:
		return dead
@export var target_type: CardData.TARGET_TYPES
@export var block: int = 0

func damage(amount: int) -> void:
	if amount > block:
		amount -= block
		block = 0
	elif amount < block:
		block -= amount
		amount = 0
	health -= amount

func heal(amount: int) -> void:
	health += amount

func defend(amount: int) -> void:
	block += amount

static func get_values(_health: Health) -> Dictionary:
	return {
		"maxHealth": _health.maxHealth,
		"health": _health.health,
		"block": _health.block,
		"target_type": _health.target_type,
		"dead": _health.dead
	}
	
func set_values(values: Dictionary) -> void:
	maxHealth = values.maxHealth
	health = values.health
	block = values.block
	target_type = values.target_type
	dead = values.dead
