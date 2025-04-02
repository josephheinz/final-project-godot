extends Node

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

enum TILE_TYPES {EMPTY = 0, COMBAT = 1, ELITE_COMBAT = 2, SHOP = 3}
const TILE_REFS: Array = [
	
]

#const START_TILE_SCENE: PackedScene
#const BOSS_TILE_SCENE: PackedScene

#const PLAYER: PackedScene

var RoomsMap: Dictionary[Vector2i, Node] = {}
