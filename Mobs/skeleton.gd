extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #это для гравитации

@onready var anim = $AnimatedSprite2D
var chase = false  #погоня
var damage = 20
var speed = 100
var alive = true

# тут просто физика
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	var player = $"../../Player/Player"
	var direction = (player. position - self.position ).normalized() #чтобы мы поняли справа или слева
	if alive == true :
		if chase == true :
			velocity.x = direction.x * speed 
			anim.play("Run")
		else :
			velocity.x = 0
			anim.play("Idle")
			
			#тут чтобы он крутился
		if direction.x < 0 :
			anim.flip_h = true
		else :
			anim.flip_h = false
		move_and_slide()

#тут он за мной идет
func _on_detektor_body_entered(body):
	chase = true
		
		
#это зона агра
func _on_area_2d_body_exited(body):
	chase = false

#тут я убиваю прыжком
func _on_death_body_entered(body):
	body.velocity.y -=300 
	death()
		
#тут я убиваю его касанием 
func _on_death_2_body_entered(body):
	Signals.emit_signal("enemy_attack", damage)
	#body.health -=20
	death()
	
#это функция для смерти
func death ():
	alive = false 
	anim.play("Death")
	await anim.animation_finished
	queue_free()
	
