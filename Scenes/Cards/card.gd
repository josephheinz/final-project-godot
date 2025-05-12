class_name Card
extends Panel

const SIZE := Vector2(150, 210)

@export var text: String
@export var hovered: bool = false
@export var data: CardData
@export var show_cost: bool = false

@onready var label: Label = $Name
@onready var card_image: TextureRect = $"Image Border/Card Image"
@onready var cost: Label = $Cost

func _ready() -> void:
	label.text = data.name
	card_image.texture = load(data.cardImage)
	cost.visible = show_cost
	cost.text = "%s🪙" % data.basePrice

func _on_mouse_entered() -> void:
	hovered = true
	if is_instance_of(get_parent(), Hand):
		get_parent()._update_cards()

func _on_mouse_exited() -> void:
	hovered = false
	if is_instance_of(get_parent(), Hand):
		get_parent()._update_cards()

func _on_hover_panel_gui_input(event: InputEvent) -> void:
	if is_instance_of(event, InputEventMouseButton):
		if event.pressed == true and get_parent() is not Window:
			get_parent().selectCard(self)
