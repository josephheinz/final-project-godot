class_name SelectionPath extends Path2D

var startPoint: Vector2 = Vector2(0, 0)
var endPoint: Vector2 = Vector2(100, 100)

# First vector2 is the out tangent of the startPoint
# second vector2 is the in tanget of the endPoint
var tangents: Array[Vector2] = [
	Vector2( ( endPoint.x - startPoint.x ) / 2, 0 ),
	Vector2( 0, ( startPoint.y - endPoint.y ) / 2 ) 
]

func _enter_tree() -> void:
	self.curve = Curve2D.new()
	
	self.curve.add_point(startPoint)
	self.curve.add_point(endPoint)
	
	self.curve.set_point_out(0, tangents[0])
	self.curve.set_point_in(1, tangents[1])

func _process(_delta: float) -> void:
	var mousePos = get_global_mouse_position() - self.global_position
	tangents[0] = Vector2(mousePos.x/5, 0)
	
	self.curve.set_point_position(0, startPoint)
	self.curve.set_point_position(1, mousePos)
	
	self.curve.set_point_out(0, tangents[0])
	self.curve.set_point_in(1, tangents[1])
	
	queue_redraw()
	
func _draw():
	var points: PackedVector2Array = self.curve.get_baked_points()
	if points.size() > 1:
		draw_polyline(points, Color.GRAY, 4)
