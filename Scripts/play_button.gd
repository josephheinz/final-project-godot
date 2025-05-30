extends Button

@onready var seed_text = get_parent().get_node("SeedText")
@onready var char_dropdown : OptionButton = get_parent().get_node("CharacterSelect")

func _on_pressed() -> void:
	Global.reset_state()
	if len(seed_text.text) > 0:
		if int(seed_text.text):
			Global.RNG.seed = int(seed_text.text)
	if char_dropdown.selected:
		var _char := char_dropdown.get_item_text(char_dropdown.get_selected_id())
		if _char != "":
			Global.State.player.character = Global.CHARACTERS[str(_char).to_upper()]
	SceneManager.change_scene_to_file("res://Scenes/main.tscn")
