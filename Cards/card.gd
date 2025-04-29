class_name CardData extends Resource

enum CARD_TYPES {ATTACK = 0, DEFENSE = 1, SPELL = 2}
enum TARGET_TYPES {PLAYER = 0, ENEMY = 1}

@export_group("Card Data")
@export var name: String = ""
@export_global_file("*.png","*.jpg") var cardImage
@export var allowedTargets: Array[TARGET_TYPES] = [TARGET_TYPES.ENEMY]

func Use() -> void:
	print("using")
