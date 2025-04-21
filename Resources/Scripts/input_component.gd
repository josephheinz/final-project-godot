class_name InputComponent extends Node

var parent: Node

func _ready() -> void:
	parent = get_parent()

func handleInputs() -> void:
	if Input.is_action_just_pressed("movement_left"):
		var moveVec: Vector2i = Vector2i( -1, 0 )
		parent.movement.Move(moveVec)
	if Input.is_action_just_pressed("movement_right"):
		var moveVec: Vector2i = Vector2i(1, 0)
		parent.movement.Move(moveVec)
	if Input.is_action_just_pressed("movement_up"):
		var moveVec: Vector2i = Vector2i(0, -1)
		parent.movement.Move(moveVec)
	if Input.is_action_just_pressed("movement_down"):
		var moveVec: Vector2i = Vector2i(0, 1)
		parent.movement.Move(moveVec)

func _process(_delta: float) -> void:
	handleInputs()
