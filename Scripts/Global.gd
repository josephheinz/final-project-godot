extends Node

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

enum DAMAGE_TYPES {NORMAL = 0, FIRE = 1, WATER = 2}
enum TILE_TYPES {EMPTY = 0, COMBAT = 1, ELITE_COMBAT = 2, SHOP = 3}
const TILE_REFS: Array = [
	preload("res://Tiles/Scenes/emptyTile.tscn"),
	preload("res://Tiles/Scenes/combatTile.tscn"),
	preload("res://Tiles/Scenes/eliteCombatTile.tscn"),
	preload("res://Tiles/Scenes/shopTile.tscn")
]

const START_TILE_SCENE: PackedScene = preload("res://Tiles/Scenes/startTile.tscn")
const BOSS_TILE_SCENE: PackedScene = preload("res://Tiles/Scenes/bossTile.tscn")

const PLAYER: PackedScene = preload("res://Scenes/Player/player.tscn")

var RoomsMap: Dictionary[Vector2i, Node] = {}
