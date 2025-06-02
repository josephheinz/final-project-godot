extends Node

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

enum DAMAGE_TYPES {NORMAL = 0, FIRE = 1, WATER = 2}
enum TILE_TYPES {EMPTY = 0, COMBAT = 1, ELITE_COMBAT = 2, SHOP = 3}
enum CHARACTERS {KNIGHT = 0, ARCHER = 1}

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

var State: Dictionary = {
	"player": {
		"pos": Vector2(0, 0),
		"stats": {},
		"character": null,
		"gold": int(10),
		"score": 0
	},
	"floor": 1,
	"dungeon": {},
	"visited": [Vector2i(0, 0)],
	"visible": [Vector2i(0, 0)]
}

var Cards: Dictionary[String, Array] = {
	"Deck": [],
	"Hand": [],
	"Discard": [],
	"Selected": []
}

var character_cards: Dictionary[CHARACTERS, Array] = {
	CHARACTERS.KNIGHT: ["res://Cards/card_deflect.tres","res://Cards/card_stab.tres","res://Cards/card_bandage.tres","res://Cards/card_block.tres","res://Cards/card_slash.tres","res://Cards/card_heal.tres"],
	CHARACTERS.ARCHER: ["res://Cards/card_dodge.tres","res://Cards/card_shot.tres","res://Cards/card_health_potion.tres","res://Cards/card_hide.tres","res://Cards/card_trickshot.tres","res://Cards/card_heal.tres"]
}

var character_decks: Dictionary[CHARACTERS, Array] = {
	CHARACTERS.KNIGHT: ["res://Cards/card_deflect.tres","res://Cards/card_stab.tres","res://Cards/card_deflect.tres","res://Cards/card_stab.tres","res://Cards/card_deflect.tres","res://Cards/card_stab.tres","res://Cards/card_deflect.tres","res://Cards/card_stab.tres","res://Cards/card_block.tres","res://Cards/card_slash.tres"],
	CHARACTERS.ARCHER: ["res://Cards/card_dodge.tres","res://Cards/card_shot.tres","res://Cards/card_dodge.tres","res://Cards/card_shot.tres","res://Cards/card_dodge.tres","res://Cards/card_shot.tres","res://Cards/card_dodge.tres","res://Cards/card_shot.tres","res://Cards/card_hide.tres","res://Cards/card_trickshot.tres",]
}

var character_sprites: Dictionary[CHARACTERS, Resource] = {
	CHARACTERS.KNIGHT: load("res://Sprites/knight.png"),
	CHARACTERS.ARCHER: load("res://Sprites/archer.png")
}

var enemies: Dictionary[float, Array] = {
	1: [load("res://Enemies/gublin.tres"),load("res://Enemies/goop.tres"),load("res://Enemies/hellpup.tres"),load("res://Enemies/ghost.tres"),load("res://Enemies/phil.tres"),load("res://Enemies/chair.tres")],
	1.25: [load("res://Enemies/hubgublin.tres"),load("res://Enemies/super_goop.tres"),load("res://Enemies/hellhound.tres"),load("res://Enemies/wraith.tres"),load("res://Enemies/phil.tres"),load("res://Enemies/horseman.tres")],
	1.75: [load("res://Enemies/gublin_king.tres"),load("res://Enemies/stone_golem.tres")]
}

var character_stats: Dictionary[CHARACTERS, Dictionary]

func create_character_health(maxHealth: int, character: CHARACTERS) -> void:
	var health = Health.new()
	health.maxHealth = maxHealth
	health.health = maxHealth
	health.target_type = CardData.TARGET_TYPES.PLAYER
	character_stats[character] = Health.get_values(health)

func _ready() -> void:
	create_character_health(20, CHARACTERS.KNIGHT)
	create_character_health(15, CHARACTERS.ARCHER)

func progress_floor() -> void:
	State.floor += 1
	RoomsMap = {}
	State.dungeon = {}
	State.visited = [Vector2i(0, 0)]
	State.visible = [Vector2i(0, 0)]
	State.player.stats.maxHealth *= 1.25
	State.player.stats.health = State.player.stats.maxHealth

func reset_state() -> void:
	State.player = {
		"pos": Vector2(0, 0),
		"stats": {},
		"character": null,
		"gold": int(10),
		"score": 0
	}
	State.dungeon = {}
	State.floor = 1
	State.visited = [Vector2i(0, 0)]
	State.visible = [Vector2i(0, 0)]
	RoomsMap = {}
	Cards.Deck = []
	Cards.Hand = []
	Cards.Selected = []
	Cards.Discard = []
	return

#Shield Hit 1 by CTCollab -- https://freesound.org/s/223630/ -- License: Attribution 3.0
#MCU_or_movie_inspired_blade_stab_or_slash_flesh_sounds.mp3 by Artninja -- https://freesound.org/s/700235/ -- License: Attribution 4.0
#Brooding Sinister Laughter by amauri8BIT -- https://freesound.org/s/786076/ -- License: Attribution 4.0
