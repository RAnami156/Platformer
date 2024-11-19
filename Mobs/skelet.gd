extends CharacterBody2D

@onready var animPlayer = $AnimationPlayer
@onready var fanta = $AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player = null  
var speed = 100
var chase = false

enum {
	IDLE,
	RUN,
	CHASE,
	ATTACK
}

var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			RUN:
				run_state()
			CHASE:
				chase_state()
			ATTACK:
				attack_state()
				
func _ready():
	Signals.connect("player_position_update", Callable(self, "_on_player_position_update"))

func _on_player_position_update(player_pos):
	player = player_pos

func _physics_process(delta: float) -> void:
	if velocity.x == 0 and animPlayer.current_animation == "Run":
		state = ATTACK
	if player != null:  # Проверка
		var direction = (player - self.position).normalized()
		
		if not is_on_floor():
			velocity.y += gravity * delta
	
		if direction.x < 0:
			fanta.flip_h = true
			$AttackDirection.rotation_degrees = 180
		else:
			fanta.flip_h = false
			$AttackDirection.rotation_degrees = 0
		if state == CHASE:
			chase_state()
		if state == RUN:
			run_state()
		
		move_and_slide()
		
func _on_detector_body_entered(body: Node2D) -> void:
	chase = true
	state = CHASE


func _on_detector_body_exited(body: Node2D) -> void:
	chase = false
	velocity.x = 0
	state = IDLE
		
func idle_state():
	animPlayer.play("Idle")
	velocity.x = 0
	if chase:
		state = CHASE

func run_state():
	var direction = (player - self.position).normalized()
	if chase:
		velocity.x = direction.x * speed
		animPlayer.play("Run")
	else:
		velocity.x = 0
		state = IDLE

func chase_state():
	var direction = (player - self.position).normalized()
	velocity.x = direction.x * speed  
	state = RUN
	
func attack_state():
	velocity.x = 0
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	state = IDLE  # Переход в состояние восстановления после атаки
	
	


func _on_attack_rage_body_entered(body: Node2D) -> void:
	state = ATTACK
