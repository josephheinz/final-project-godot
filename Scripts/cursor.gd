class_name Cursor extends Sprite2D

const DEFAULT_SIZE: Vector2 = Vector2(500, 500)

@export var enabled: bool = true

var selecting: bool = false

func _ready() -> void:
	visible = true if enabled else false

func _process(_delta: float) -> void:
	visible = true if enabled else false
	if not selecting:
		position = lerp(position, get_global_mouse_position(), 0.15)
		scale = lerp(scale, Vector2(0.2, 0.2), 0.15)
	try_get_hover()

func select(object: Sprite2D) -> void:
	selecting = true
	var obj_size: Vector2 = object.texture.get_size() * object.scale	
	var goal_size = obj_size + Vector2(20, 20)
	
	position = lerp(position, object.position, 0.15)
	scale = lerp(scale, goal_size / DEFAULT_SIZE, 0.15)

func deselect() -> void:
	selecting = false

func try_get_hover() -> void:
	var mouse_pos: Vector2 = Vector2(get_global_mouse_position().x, get_global_mouse_position().y) 
	var space = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	
	parameters.canvas_instance_id = 0
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false
	parameters.position = mouse_pos
	
	var result = space.intersect_point(parameters, 1)
	
	for hit in result:
		if hit.collider is Area2D:
			select(hit.collider.get_parent())
	if len(result) < 1:
		deselect()
