class_name BossTile extends Tile

func interact() -> void:
	SceneManager.change_scene_to_packed(preload("res://Scenes/boss_battle.tscn"))
