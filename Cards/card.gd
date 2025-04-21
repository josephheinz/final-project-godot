class_name CardData extends Resource

enum CARD_TYPES {ATTACK = 0, DEFENSE = 1, SPELL = 2}

@export_group("Card Data")
@export var name: String = ""
@export_global_file("*.png","*.jpg") var cardImage
