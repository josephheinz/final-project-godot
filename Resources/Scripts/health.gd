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
