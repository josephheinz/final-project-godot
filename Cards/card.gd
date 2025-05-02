class_name CardData extends Resource

enum CARD_TYPES {ATTACK = 0, DEFENSE = 1, SPELL = 2}
enum TARGET_TYPES {PLAYER = 0, ENEMY = 1}
enum USE_TYPES {DAMAGE = 0, HEAL = 1, BLOCK = 2}

@export_group("Card Data")
@export var name: String = ""
@export_global_file("*.png","*.jpg") var cardImage
@export var allowedTargets: Array[TARGET_TYPES] = [TARGET_TYPES.ENEMY]
@export var useType: USE_TYPES = USE_TYPES.DAMAGE
@export var useAmount: int = 1

func Use(target: Node) -> void:
	match useType:
		USE_TYPES.DAMAGE:
			Damage(useAmount, target)
		USE_TYPES.HEAL:
			Heal(useAmount, target)
		USE_TYPES.BLOCK:
			Block(useAmount, target)

func Damage(amount: int, target: Node) -> void:
	target.get_node("HealthComponent").damage(amount)
	
func Heal(amount: int, target: Node) -> void:
	target.get_node("HealthComponent").heal(amount)

func Block(amount: int, target: Node) -> void:
	target.get_node("HealthComponent").defend(amount)
