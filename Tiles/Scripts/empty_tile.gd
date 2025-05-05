class_name Tile extends Node2D

static var Size: Vector2i = Vector2i(100, 100)

var Visited: bool = false
var VisitedColor: Color = Color.WHITE
var UnvisitedColor: Color = Color.DARK_GRAY

func interact() -> void:
	pass

var _last_color: Color = Color(-1, -1, -1)

func _process(_delta: float) -> void:
	var target_color: Color = VisitedColor if Visited else UnvisitedColor
	
	if target_color != _last_color:
		var bg : Panel = self.get_node("Background")
		var styles := bg.get_theme_stylebox("panel")
		var sb := styles.duplicate(true)
		sb.bg_color = target_color
		bg.add_theme_stylebox_override("panel", sb)
		styles.emit_changed()
		queue_redraw()
