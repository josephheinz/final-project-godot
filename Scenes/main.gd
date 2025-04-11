extends Node2D

@export var settings: GeneratorSettings
@export var minPadding: int = 50

@onready var cam: Camera2D = $MainCamera

const directions: Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

var room_type_amounts: Array[int] = []

func add_room(position: Vector2i, type: Global.TILE_TYPES) -> Node:
	var room = Global.TILE_REFS[type].instantiate()
	room.position = position
	add_child(room)
	
	var tile_pos: Vector2i = Vector2i( room.position / Vector2(Tile.Size) )
	Global.RoomsMap[tile_pos] = room
	return room
	
# Bounds is a rectangle
# (x1, x2, y1, y2)
func in_bounds(position: Vector2i, bounds: Vector4i) -> bool:
	# This gets confusing, 
	# bounds.x and bounds.y are the x1 and y1 coords
	# bounds.z and bounds.w are the x2 and y2 coords
	if position.x < bounds.x or position.x > bounds.z or position.y < bounds.y or position.y > bounds.w:
		return false
	return true
	
func add_specific_room(position: Vector2i, room_scene: PackedScene) -> Node:
	var room = room_scene.instantiate()
	room.position = position
	add_child(room)
	
	var tile_pos: Vector2i = Vector2i( room.position / Vector2(Tile.Size) )
	Global.RoomsMap[tile_pos] = room
	return room

func generate_dungeon(settings: GeneratorSettings) -> void:
	var start_room: Node = add_specific_room(Vector2i(0, 0), Global.START_TILE_SCENE)
	var bounds: Vector4i = Vector4i(0, 0, 10, 10)
	var room_count: int = 1
	var current_pos: Vector2i = Vector2i.ZERO
	
	while room_count <= settings.maxRooms:
		# choose using rng to allow for seeded runs
		var direction = directions[Global.RNG.randi_range( 0, len(directions) - 1 )]
		var direction_attempts = 0
		var new_pos = current_pos + direction
		# Make sure the new room location doesn't exist and is in bounds
		while Global.RoomsMap.has(new_pos) or !in_bounds(new_pos, bounds):
			if direction_attempts > 10:
				return # Too many tries will take too long
			direction = directions[Global.RNG.randi_range( 0, len(directions) - 1 )]
			print_debug("Trying to find a valid direction")
			direction_attempts += 1
			new_pos = current_pos + direction
		
		current_pos = new_pos
		var room_type: int = Global.RNG.randi_range( 0, len( Global.TILE_TYPES ) - 1 )
		if room_count == settings.maxRooms:
			var boss_tile: Node = add_specific_room(current_pos * Tile.Size, Global.BOSS_TILE_SCENE)
			break
		# Check to make sure max amount of rooms of this type hasn't been exceeded
		while room_type_amounts[room_type] >= settings.roomMaxes[room_type]:
			room_type = Global.RNG.randi_range( 0, len( Global.TILE_TYPES ) - 1 )
		var new_room = add_room(current_pos * Tile.Size, room_type)
		room_type_amounts[room_type] += 1
		room_count += 1
	return

func _ready() -> void:
	# Fill the room type amounts array with zeros to start
	room_type_amounts.resize(len(settings.roomMaxes))
	room_type_amounts.fill(0)
	
	generate_dungeon(settings)
	center_dungeon()

func _process(_delta: float) -> void:
	handleInputs()
	if Input.is_action_just_pressed("ui_accept"):
		Global.RoomsMap = {}
		get_tree().reload_current_scene()

func zoom_cam(cam_size: Vector2, floor_size: Vector2) -> void:
	var ratio: Vector2 = Vector2(floor_size / cam_size)
	var new_zoom: Vector2 = Vector2(max(ratio.x, ratio.y), max(ratio.x, ratio.y))
	cam.zoom /= new_zoom
	print(cam.zoom)

func move_cam(max: Vector2, cam_size: Vector2) -> void:
	var center: Vector2 = Vector2(max.x / 2 - minPadding, max.y / 2 - minPadding)
	cam.position = Vector2(center.x, center.y)
	
func center_dungeon() -> void:
	var max_x: int = 0
	var max_y: int = 0
	
	for room in Global.RoomsMap:
		var _room = Global.RoomsMap[room]
		if _room.position.x + Tile.Size.x > max_x:
			max_x = _room.position.x + Tile.Size.x
		if _room.position.y + Tile.Size.y > max_y:
			max_y = _room.position.y + Tile.Size.y
	
	var min: Vector2 = Vector2(0, 0)
	var max: Vector2 = Vector2(max_x + minPadding, max_y + minPadding)
	var floor_size: Vector2 = max - min
	print(floor_size)
	var cam_size: Vector2 = get_viewport_rect().size
	
	move_cam(floor_size, cam_size)
	if floor_size.x > cam_size.x * cam.zoom.x or floor_size.y > cam_size.y * cam.zoom.y:
		zoom_cam(cam_size, floor_size)

func handleInputs() -> void:
	return
	if Input.is_action_just_pressed("ui_left"):
		var moveVec = Vector2i(-1, 0)
		#player.Move(moveVec)
	if Input.is_action_just_pressed("ui_right"):
		var moveVec = Vector2i(1, 0)
		#player.Move(moveVec)
	if Input.is_action_just_pressed("ui_up"):
		var moveVec = Vector2i(0, -1)
		#player.Move(moveVec)
	if Input.is_action_just_pressed("ui_down"):
		var moveVec = Vector2i(0, 1)
		#player.Move(moveVec)
