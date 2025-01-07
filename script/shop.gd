extends Area2D
var player_in_area = false

func _physics_process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("e"):
		get_tree().change_scene_to_file("res://shop_lev.tscn")

func _on_body_entered(body: Node2D) -> void:
	player_in_area = true

func _on_body_exited(body: Node2D) -> void:
	player_in_area = false
