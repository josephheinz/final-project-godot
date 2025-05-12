class_name ShopTile extends Tile

func interact() -> void:
	SceneManager.change_scene_to_packed(preload("res://Scenes/shop.tscn"))
