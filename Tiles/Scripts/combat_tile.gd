class_name CombatTile extends Tile

func interact() -> void:
	SceneManager.change_scene_to_packed(preload("res://Scenes/combat.tscn"))
