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
	var hit_sfx := AudioStreamPlayer.new()
	if amount > block:
		amount -= block
		block = 0
		hit_sfx.stream = load("res://Audio/slash_sfx.mp3")
	elif amount < block:
		block -= amount
		amount = 0
		hit_sfx.stream = load("res://Audio/shield_sfx.wav")
	elif amount == block:
		amount = 0
		block = 0
		hit_sfx.stream = load("res://Audio/shield_sfx.wav")
	add_child(hit_sfx)
	hit_sfx.play()
	health -= amount
	await hit_sfx.finished
	hit_sfx.queue_free()

func heal(amount: int) -> void:
	var heal_sfx := AudioStreamPlayer.new()
	heal_sfx.stream = load("res://Audio/heal_sfx.wav")
	add_child(heal_sfx)
	heal_sfx.play()
	health += amount
	await heal_sfx.finished
	heal_sfx.queue_free()

func defend(amount: int) -> void:
	var shield_sfx := AudioStreamPlayer.new()
	shield_sfx.stream = load("res://Audio/shield_sfx.wav")
	add_child(shield_sfx)
	shield_sfx.play()
	block += amount
	await shield_sfx.finished
	shield_sfx.queue_free()

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
