class_name EliteCombatTile extends Tile

func interact() -> void:
	SceneManager.change_scene_to_packed(preload("res://Scenes/elite_combat.tscn"))
