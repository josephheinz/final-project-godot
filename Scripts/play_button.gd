extends Button

@onready var seed_text = get_parent().get_node("SeedText")

func _on_pressed() -> void:
	if len(seed_text.text) > 0:
		if int(seed_text.text):
			Global.RNG.seed = int(seed_text.text)
	SceneManager.change_scene_to_file("res://Scenes/main.tscn")
