class_name Player extends Node2D

@export var movement: Movement
@export var input: InputComponent
@export var health: Health


func _on_movement_component_move() -> void:
	var currentTile: Tile = Global.RoomsMap[Vector2i(position / Vector2(Tile.Size))]
	currentTile.interact()
