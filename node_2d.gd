extends Node2D

@onready var anim = $AnimatedSprite2D
var body_in = false
var chest_open = false 

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("e") and body_in == true:
		if chest_open:
			anim.play("close") 
			chest_open = false
		else:
			anim.play("open")  
			chest_open = true
	elif not chest_open:
		anim.play("close") 

func _on_area_2d_body_entered(body: Node2D) -> void:
	body_in = true  # Объект вошел в область

func _on_area_2d_body_exited(body: Node2D) -> void:
	body_in = false  # Объект покинул область
