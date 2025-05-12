class_name Movement extends Node

var parent: Node
signal move

func _ready() -> void:
	parent = get_parent()
	var _neighbors: Array = parent.get_parent().check_neighbors(parent.position)
	for room in _neighbors:
		var room_pos = Vector2i(room.position / Vector2(Tile.Size))
		if !Global.State.visible.has(room_pos):
			Global.State.visible.append(room_pos)

func Move(moveVec: Vector2i) -> bool:
	var playerTilePosition: Vector2i = ( parent.position / Vector2(Tile.Size) )
	var tryMovePos: Vector2i = playerTilePosition + moveVec
	if Global.RoomsMap.has(tryMovePos):
		parent.position = tryMovePos * Tile.Size
		var _neighbors: Array = parent.get_parent().check_neighbors(tryMovePos)
		for room in _neighbors:
			var room_pos = Vector2i(room.position / Vector2(Tile.Size))
			if !Global.State.visible.has(room_pos):
				Global.State.visible.append(room_pos)
		if parent.name == "Player":
			Global.State.player.pos = Vector2(parent.position)
		move.emit()
		if !Global.State.visited.has(tryMovePos):
			Global.State.visited.append(tryMovePos)
		return true
	else:
		return false
