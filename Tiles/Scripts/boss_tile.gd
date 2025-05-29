class_name BossTile extends Tile

func interact() -> void:
	var boss_intro := AudioStreamPlayer.new()
	boss_intro.stream = load("res://Audio/boss_intro_sfx.wav")
	boss_intro.volume_db = 5
	add_child(boss_intro)
	boss_intro.play()
	await boss_intro.finished
	SceneManager.change_scene_to_packed(preload("res://Scenes/boss_battle.tscn"))
