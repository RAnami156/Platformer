extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false #погоня
var speed = 100
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var player = $"../../Player/Player"
	var direction = (player.position - self.position ).normalized()
	if chase == true :
		velocity.x = direction.x * speed 
		anim.play("Run")
	else :
		velocity.x = 0
		anim.play("Idle")
	if direction.x < 0 :
			anim.flip_h = false
	else :
		anim.flip_h = true
		
	move_and_slide()
	
	


func _on_detector_body_entered(body):
	if body.name == "Player" :
		chase = true
