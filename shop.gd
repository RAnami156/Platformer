extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if Input.is_action_pressed("shop"):
		get_tree().change_scene_to_file("res://shop_lev.tscn")
