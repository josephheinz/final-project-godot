extends Node2D

@export var settings: GeneratorSettings
@export var minPadding: int = 50

var player: Node

@onready var cam: Camera2D = $MainCamera

const directions: Array[Vector2i] = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

var room_type_amounts: Array[int] = []

func add_room(_position: Vector2i, type: Global.TILE_TYPES, update_state: bool = true) -> Node:
	var room = Global.TILE_REFS[type].instantiate()
	room.position = _position
	add_child(room)
	
	var tile_pos: Vector2i = Vector2i( room.position / Vector2(Tile.Size) )
	Global.RoomsMap[tile_pos] = room
	if update_state:
		Global.State.dungeon[tile_pos] = Global.TILE_REFS[type]
	return room
	
# Bounds is a rectangle
# (x1, x2, y1, y2)
func in_bounds(_position: Vector2i, bounds: Vector4i) -> bool:
	# This gets confusing, 
	# bounds.x and bounds.y are the x1 and y1 coords
	# bounds.z and bounds.w are the x2 and y2 coords
	if _position.x < bounds.x or _position.x > bounds.z or _position.y < bounds.y or _position.y > bounds.w:
		return false
	return true
	
func add_specific_room(_position: Vector2i, room_scene: PackedScene, update_state: bool = true) -> Node:
	var room = room_scene.instantiate()
	room.position = _position
	add_child(room)
	
	var tile_pos: Vector2i = Vector2i( room.position / Vector2(Tile.Size) )
	Global.RoomsMap[tile_pos] = room
	if update_state:
		Global.State.dungeon[tile_pos] = room_scene
	return room

func generate_dungeon(_settings: GeneratorSettings) -> void:
	var _start_room: Node = add_specific_room(Vector2i(0, 0), Global.START_TILE_SCENE)
	var bounds: Vector4i = Vector4i(0, 0, 10, 10)
	var room_count: int = 1
	var current_pos: Vector2i = Vector2i.ZERO
	
	while room_count <= _settings.maxRooms:
		# choose using rng to allow for seeded runs
		var direction = directions[Global.RNG.randi_range( 0, len(directions) - 1 )]
		var direction_attempts = 0
		var new_pos = current_pos + direction
		# Make sure the new room location doesn't exist and is in bounds
		while Global.RoomsMap.has(new_pos) or !in_bounds(new_pos, bounds):
			if direction_attempts > 10:
				place_boss_tile() # Too many tries will take too long
				return
			direction = directions[Global.RNG.randi_range( 0, len(directions) - 1 )]
			direction_attempts += 1
			new_pos = current_pos + direction
		
		current_pos = new_pos
		var room_type: int = Global.RNG.randi_range( 0, len( Global.TILE_TYPES ) - 1 )
		if room_count == settings.maxRooms:
			place_boss_tile()
			break
		# Check to make sure max amount of rooms of this type hasn't been exceeded
		while room_type_amounts[room_type] >= _settings.roomMaxes[room_type]:
			room_type = Global.RNG.randi_range( 0, len( Global.TILE_TYPES ) - 1 )
		var _new_room = add_room(current_pos * Tile.Size, room_type)
		room_type_amounts[room_type] += 1
		room_count += 1
	return

func check_neighbors(_position: Vector2i) -> Array[Node]:
	var neighbors: Array[Node] = []
	# yuck
	if Global.RoomsMap.has(_position - Vector2i(1, 0)):
		neighbors.append(Global.RoomsMap[_position - Vector2i(1, 0)])
	if Global.RoomsMap.has(_position - Vector2i(0, 1)):
		neighbors.append(Global.RoomsMap[_position - Vector2i(0, 1)])
	if Global.RoomsMap.has(_position + Vector2i(1, 0)):
		neighbors.append(Global.RoomsMap[_position + Vector2i(1, 0)])
	if Global.RoomsMap.has(_position + Vector2i(0, 1)):
		neighbors.append(Global.RoomsMap[_position + Vector2i(0, 1)])
	return neighbors

func place_boss_tile() -> void:
	var max_pos: Vector2i = Vector2i(0, 0)
	for room in Global.RoomsMap:
		var _room = Global.RoomsMap[room]
		if _room.position.x > max_pos.x:
			max_pos.x = _room.position.x / Tile.Size.x
		if _room.position.y > max_pos.y:
			max_pos.y = _room.position.y / Tile.Size.y
	
	# Choose a direction to be the furthest away from the start
	var direction: Vector2i = Vector2i(0, 0)
	if max_pos.x > max_pos.y:
		direction = Vector2i(1, 0)
	elif max_pos.x < max_pos.y:
		direction = Vector2i(0, 1)
	else:
		var _left_right: float = Global.RNG.randf_range(-1, 1)
		# I think this setup makes putting the boss tile further on the x more likely
		direction = Vector2i(roundi(0 + _left_right), roundi(0 + _left_right))
	
	var new_pos = max_pos + direction
	while check_neighbors(new_pos) == []:
		new_pos -= Vector2i(1, 0)
	var _boss_tile: Node = add_specific_room(new_pos * Tile.Size, Global.BOSS_TILE_SCENE)
	return

func _ready() -> void:
	if !Global.State.player.character or Global.State.player.character == null:
		Global.State.player.character = Global.CHARACTERS.KNIGHT
	if !Global.State.player.stats:
		Global.State.player.stats = Global.character_stats[Global.State.player.character]
	if len(Global.RoomsMap) > 0:
		for room in Global.RoomsMap:
			#add_specific_room(room * Tile.Size, Global.RoomsMap[room])
			load_dungeon()
			return
	# Fill the room type amounts array with zeros to start
	room_type_amounts.resize(len(settings.roomMaxes))
	room_type_amounts.fill(0)
	generate_dungeon(settings)
	
	player = Global.PLAYER.instantiate()
	add_child(player)
	
	center_dungeon()

func _process(_delta: float) -> void:
	for room in Global.State.visited:
		Global.RoomsMap[room].Visited = true
	for room in Global.State.visible:
		Global.RoomsMap[room].Visible = true

func zoom_cam(cam_size: Vector2, floor_size: Vector2) -> void:
	var ratio: Vector2 = Vector2(floor_size / cam_size)
	var new_zoom: Vector2 = Vector2(max(ratio.x, ratio.y), max(ratio.x, ratio.y))
	cam.zoom /= new_zoom

func move_cam(max_pos: Vector2) -> void:
	var center: Vector2 = Vector2(max_pos.x / 2 - minPadding, max_pos.y / 2 - minPadding)
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
	
	var min_pos: Vector2 = Vector2(0, 0)
	var max_pos: Vector2 = Vector2(max_x + minPadding, max_y + minPadding)
	var floor_size: Vector2 = max_pos - min_pos
	var cam_size: Vector2 = get_viewport_rect().size
	
	move_cam(floor_size)
	if floor_size.x > cam_size.x * cam.zoom.x or floor_size.y > cam_size.y * cam.zoom.y:
		zoom_cam(cam_size, floor_size)

func load_dungeon() -> void:
	Global.RoomsMap = {}
	for room in Global.State.dungeon:
		var _room = add_specific_room(room * Tile.Size, Global.State.dungeon[room], false)
	
	player = Global.PLAYER.instantiate()
	player.position = Global.State.player.pos
	add_child(player)
	center_dungeon()
