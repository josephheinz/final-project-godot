class_name enemy extends Resource

@export_group("Settings")
@export var maxHealth: int
@export var target_type = CardData.TARGET_TYPES.ENEMY
@export var block: int
@export_file("*.png","*.jpg") var enemyImage
@export var name: String
@export_range(0, 100, 1) var damage: int

func make_health_comp() -> Health:
	var health: Health = Health.new()
	health.block = block
	health.maxHealth = maxHealth
	health.health = maxHealth
	health.target_type = target_type
	return health
