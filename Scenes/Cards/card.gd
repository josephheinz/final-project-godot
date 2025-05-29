class_name Card
extends Panel

const SIZE := Vector2(150, 210)

@export var text: String
@export var hovered: bool = false
@export var data: CardData
@export var show_cost: bool = false
@export var show_desc: bool = true

@onready var label: Label = $Name
@onready var card_image: TextureRect = $"Image Border/Card Image"
@onready var cost: Label = $Cost
@onready var desc: Label = $Description

func _ready() -> void:
	label.text = data.name
	card_image.texture = load(data.cardImage)
	cost.visible = show_cost
	cost.text = "%s Gold" % data.basePrice
	var type: String = ""
	match data.useType:
		CardData.USE_TYPES.DAMAGE:
			type = "DMG"
		CardData.USE_TYPES.HEAL:
			type = "HEAL"
		CardData.USE_TYPES.BLOCK:
			type = "BLOCK"
	desc.visible = show_desc
	desc.text = "Do %s %s" % [data.useAmount, type]

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
