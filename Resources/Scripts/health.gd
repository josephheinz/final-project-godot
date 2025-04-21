class_name Health extends Node

var parent: Node

func _ready() -> void:
	parent = get_parent()

@export_group("Settings")
@export var maxHealth: int
@export var _health: int:
	set(value):
		_health = clamp(value, 0, maxHealth)
		if _health <= 0:
			_dead = true
	get:
		return _health
@export var _dead: bool = false:
	set(value):
		if _health > 0:
			_dead = false
		else:
			_dead = value
	get:
		return _dead
