extends Node

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

enum DAMAGE_TYPES {NORMAL = 0, FIRE = 1, WATER = 2}
enum TILE_TYPES {EMPTY = 0, COMBAT = 1, ELITE_COMBAT = 2, SHOP = 3}
enum CHARACTERS {KNIGHT = 0}

const TILE_REFS: Array = [
	preload("res://Tiles/Scenes/emptyTile.tscn"),
	preload("res://Tiles/Scenes/combatTile.tscn"),
	preload("res://Tiles/Scenes/eliteCombatTile.tscn"),
	preload("res://Tiles/Scenes/shopTile.tscn")
]

const START_TILE_SCENE: PackedScene = preload("res://Tiles/Scenes/startTile.tscn")
const BOSS_TILE_SCENE: PackedScene = preload("res://Tiles/Scenes/bossTile.tscn")

const PLAYER: PackedScene = preload("res://Scenes/Player/player.tscn")

var Gold: int = 10
var CurrentCharacter: CHARACTERS

var RoomsMap: Dictionary[Vector2i, Node] = {}

var State: Dictionary = {
	"player": {
		"pos": Vector2(0, 0)
	},
	"dungeon": {},
	"visited": [Vector2i(0, 0)],
	"visible": [Vector2i(0, 0)]
}

var Cards: Dictionary[String, Array] = {
	"Deck": ["res://Cards/card_block.tres","res://Cards/card_slash.tres","res://Cards/card_block.tres","res://Cards/card_slash.tres","res://Cards/card_block.tres","res://Cards/card_slash.tres","res://Cards/card_block.tres","res://Cards/card_slash.tres","res://Cards/card_heal.tres","res://Cards/card_heal.tres","res://Cards/card_heal.tres","res://Cards/card_heal.tres","res://Cards/card_heal.tres"],
	"Hand": [],
	"Discard": [],
	"Selected": []
}

var character_cards: Dictionary[CHARACTERS, Array] = {
	CHARACTERS.KNIGHT: ["res://Cards/card_block.tres","res://Cards/card_slash.tres","res://Cards/card_heal.tres"]
}
