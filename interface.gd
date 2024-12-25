extends CanvasLayer

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close"):
		get_tree().change_scene_to_file("res://menu.tscn")


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file('res://menu.tscn')
