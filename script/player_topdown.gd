extends CharacterBody2D

var speed = 300
var current_dir = "none"
@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	anim.play("Front_idle")

enum {
	IDLE,
	MOVING	
}

#main
func _physics_process(delta):
	player_movement(delta)
	
	
func player_movement(delta):
	#run
	if Input.is_action_pressed("run"):
		speed = 600
	else :
		speed = 300
		
	
	if Input.is_action_pressed("right"):
		current_dir = "right"
		play_anim(MOVING)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("left"):
		current_dir = "left"
		play_anim(MOVING)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("down"):
		current_dir = "down"
		play_anim(MOVING)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("up"):
		current_dir = "up"
		play_anim(MOVING)
		velocity.y = -speed
		velocity.x = 0
	#idle
	else:
		play_anim(IDLE)
		velocity.x = 0
		velocity.y = 0 
	
	move_and_slide()
	
	
func play_anim(movement):
	var dir = current_dir
	
	if dir == "right":
		anim.flip_h = false 
		if movement == MOVING :
			anim.play("Side_walk")
		elif movement == IDLE:
			anim.play("Front_idle")
			
	if dir == "left":
		anim.flip_h = true 
		if movement == MOVING :
			anim.play("Side_walk")
		elif movement == IDLE:
			anim.play("Front_idle")
	
	if dir == "down":
		anim.flip_h = true 
		if movement == MOVING :
			anim.play("Front_walk")
		elif movement == IDLE:
			anim.play("Idle")
			
	if dir == "up":
		anim.flip_h = true 
		if movement == MOVING :
			anim.play("Back_walk")
		elif movement == IDLE:
			anim.play("Back_idle")
	


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
	
	print(speed)
