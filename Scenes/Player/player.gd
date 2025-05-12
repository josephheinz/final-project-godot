class_name Player extends Node2D

@export var movement: Movement
@export var input: InputComponent
@export var health: Health


func _on_movement_component_move() -> void:
	var pos: Vector2i = Vector2i(position / Vector2(Tile.Size))
	var currentTile: Tile = Global.RoomsMap[pos]
	if !Global.State.visited.has(pos):
		currentTile.interact()
