extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test lev") :
		get_tree().change_scene_to_file("res://test_level.tscn")
	if Input.is_action_just_pressed("close"):
		get_tree().quit()
	if Input.is_action_just_pressed("play"):
		get_tree().change_scene_to_file("res://level.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://level.tscn")


func _on_test_pressed() -> void:
	get_tree().change_scene_to_file("res://test_level.tscn")
	
