extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false  #погоня
var speed = 100
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var player = $"../../Player/Player"
	var direction = (player.position - self.position ).normalized()
	#if self.position.distance_to(player.position)<80 and not chase:
		#chase = true
	if chase == true :
		velocity.x = direction.x * speed 
		anim.play("Fly")
	else :
		velocity.x = 0
		anim.play("Idle")
	if direction.x < 0 :
			anim.flip_h = false
	else :
		anim.flip_h = true
	
	if Input.is_action_just_pressed("bat") :
		chase = true
	
	if Input.is_action_just_pressed("bat2") :
		chase = false
		
	move_and_slide()


#func _on_area_2d_body_entered(body):
	#if body.name == "Player" :
		#chase = true
