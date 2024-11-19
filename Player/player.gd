extends CharacterBody2D

signal health_changed (new_health)

enum {
	IDLE,
	MOVE,
	ATTACK,
	ATTACK2,
	ATTACK3,
	BLOCK,
	SLIDE,
	DAMAGE
}

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# гравитация
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
var max_health = 100
var health 
var gold = 0 
var state = MOVE
var run_speed = 1
var combo = false
var attack_down = false
var player_pos #хранение координат
var damage_basic = 10
var damage_multiplier = 1
var damage_current 

func _ready():
	Signals.connect("enemy_attack",Callable(self, "_on_damage_received"))
	health = max_health

func _physics_process(delta):
	
	damage_current = damage_basic * damage_multiplier
	
	match state :
		MOVE :
			move_state()
		ATTACK :
			attack_state()
		ATTACK2 :
			attack_state2()
		ATTACK3 :
			attack_state3()
		BLOCK :
			block_state()
		SLIDE :
			slide_state()
		DAMAGE :
			damage_state()

		# для гравитации
	if not is_on_floor():
		velocity.y += gravity * delta

	#падение
	if velocity.y > 0 :
		animPlayer.play("Fall")
		
	#смерть
	if health <= 0:
		health = 0 
		animPlayer.play("Death")
		set_physics_process(false) #эта хуйня фиксит баг 
		await animPlayer.animation_finished
		#queue_free() безполезная залупа которая не работала
		get_tree().change_scene_to_file("res://death_menu.tscn")
		
	move_and_slide()
	
	#для общего кода
	player_pos = self.position
	Signals.emit_signal("player_position_update", player_pos)

func move_state ():
	var direction = Input.get_axis("left", "right")

	#cheats	
	if Input.is_action_just_pressed("megaattack"):
		damage_basic += 100
		
	
	
	#прыжок
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animPlayer.play("Jump")
		
	if direction :
		velocity.x = direction * SPEED * run_speed 
		if velocity.y == 0 :
			if run_speed == 1 :
				animPlayer.play("Walk")
			else :
				animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0 :
			animPlayer.play("Idle")
			
			
			
	if direction == -1 :
		anim.flip_h = true
		$AttackDirection.rotation_degrees = 180
		
	elif direction == 1 :
		anim.flip_h = false 
		$AttackDirection.rotation_degrees = 0
		
	if Input.is_action_pressed("run") :
		run_speed = 2
	else :
		run_speed = 1
		
	if Input.is_action_pressed("block") :
		if velocity.x == 0 :
			state = BLOCK
		else :
			state = SLIDE
		
	if Input.is_action_just_pressed("attack") and attack_down == false :
		state = ATTACK
		
func block_state() :
	velocity.x = 0
	animPlayer.play("Block")
	#animPlayer.animation_finished
	if Input.is_action_just_released("block") :
		state = MOVE
		
func slide_state() :
	animPlayer.play("Slide")
	await  animPlayer.animation_finished
	state = MOVE
	
func attack_state() :
	damage_multiplier = 1
	if Input.is_action_just_pressed("attack") and combo == true :
		state = ATTACK2
	velocity.x = 0
	animPlayer.play("Attack")
	attack_freeze()
	await animPlayer.animation_finished
	state = MOVE
	
func attack_state2():
	damage_multiplier = 1.2
	if Input.is_action_just_pressed("attack") and combo == true :
		state = ATTACK3
	animPlayer.play("Attack2")
	await animPlayer.animation_finished
	state = MOVE
	
func attack_state3() : 
	damage_multiplier = 2
	animPlayer.play("Attack 3")
	await animPlayer.animation_finished
	state = MOVE
	
func combo1() :
	combo = true
	await animPlayer.animation_finished
	combo = false
	
func attack_freeze() :
	attack_down = true
	await get_tree().create_timer(0.5).timeout
	attack_down = false 
	
func damage_state() :
	print(health)
	velocity.x = 0
	anim.play("Damage")
	#await anim.animation_finished
	state = MOVE 
	
func _on_damage_received (enemy_damage) :
	if state == BLOCK :
		enemy_damage /= 2
	elif state == SLIDE :
		enemy_damage = 0
	else :
		state = DAMAGE
		health -= enemy_damage
			
func _on_hit_box_area_entered(area: Area2D) -> void:
	Signals.emit_signal("player_attack",damage_current)
	
	emit_signal("health_changed", health)
	
