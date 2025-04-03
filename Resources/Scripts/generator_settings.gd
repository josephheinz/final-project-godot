class_name GeneratorSettings extends Resource

@export var maxRooms: int = 10

@export_group("Tile Type Maxes")
@export var emptyTiles: int = maxRooms
@export var combatTiles: int = 2
@export var eliteCombatTiles: int = 1
@export var shopTiles: int = 1

var roomMaxes: Array[int] = [emptyTiles, combatTiles, eliteCombatTiles, shopTiles]
