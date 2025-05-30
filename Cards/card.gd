class_name CardData extends Resource

enum CARD_TYPES {ATTACK = 0, DEFENSE = 1, SPELL = 2}
enum TARGET_TYPES {PLAYER = 0, ENEMY = 1}
enum USE_TYPES {DAMAGE = 0, HEAL = 1, BLOCK = 2}

@export_group("Card Data")
@export var name: String = ""
@export_file("*.png","*.jpg") var cardImage
@export var allowedTargets: Array[TARGET_TYPES] = [TARGET_TYPES.ENEMY]
@export var useType: USE_TYPES = USE_TYPES.DAMAGE
@export var useAmount: int = 1
@export var basePrice: int = 1
@export var usePoints: int = 5

func Use(target: Node) -> Dictionary:
	Global.State.player.score += usePoints * Global.State.floor
	match useType:
		USE_TYPES.DAMAGE:
			return Damage(useAmount, target)
		USE_TYPES.HEAL:
			return Heal(useAmount, target)
		USE_TYPES.BLOCK:
			return Block(useAmount, target)
	return {
		"damage": 0,
		"color": Color.CRIMSON,
		"awaitable": null,
		"node": null
	}

func Damage(amount: int, target: Node) -> Dictionary:
	var result = target.get_node("HealthComponent").damage(amount)
	return result
	
func Heal(amount: int, target: Node) -> Dictionary:
	var result = target.get_node("HealthComponent").heal(amount)
	return result

func Block(amount: int, target: Node) -> Dictionary:
	var result = target.get_node("HealthComponent").defend(amount)
	return result
