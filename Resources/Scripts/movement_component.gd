class_name Movement extends Node

var parent: Node
signal move

func _ready() -> void:
	parent = get_parent()

func Move(moveVec: Vector2i) -> bool:
	var playerTilePosition: Vector2i = ( parent.position / Vector2(Tile.Size) )
	var tryMovePos: Vector2i = playerTilePosition + moveVec
	if Global.RoomsMap.has(tryMovePos):
		parent.position = tryMovePos * Tile.Size
		if !Global.State.visited.has(tryMovePos):
			Global.State.visited.append(tryMovePos)
		if parent.name == "Player":
			Global.State.player.pos = Vector2(parent.position)
		move.emit()
		return true
	else:
		return false
