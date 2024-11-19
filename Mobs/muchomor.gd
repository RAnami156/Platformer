extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	CHASE,
	RUN,
	DAMAGE,
	DEATH,
	RECOVER
}

var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			CHASE:
				chase_state()
			RUN:
				run_state()
			DAMAGE:
				damage_state()
			DEATH:
				death_state()
			RECOVER:
				recover_state()

@onready var animPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player = null
var chase = false
var speed = 50
var damage = 20
var is_dead = false  # Флаг для проверки, что объект "мертв" и не должен реагировать

func _ready():
	Signals.connect("player_position_update", Callable(self, "_on_player_position_update"))

func _on_player_position_update(player_pos):
	player = player_pos

func _physics_process(delta):
	#print(velocity.x)
	if velocity.x == 0 and animPlayer.current_animation == "Run":
		state = ATTACK

	if is_dead:
		return  # Остановить все физические обновления, если объект мертв

	if not is_on_floor():
		velocity.y += gravity * delta

	if state == CHASE:
		chase_state()
	if state == RUN:
		run_state()
		
	if player != null :
		var direction = (player - self.position).normalized()
		if direction.x < 0:
			sprite.flip_h = true
			$AttackDirection.rotation_degrees = 180
		else:
			sprite.flip_h = false
			$AttackDirection.rotation_degrees = 0

	move_and_slide()

func _on_detector_body_entered(_body):
	if is_dead:
		return  # Игнорировать событие, если объект мертв
	chase = true
	state = CHASE

func _on_attack_range_body_entered(_body):
	if is_dead:
		return  # Игнорировать событие, если объект мертв
	state = ATTACK

func _on_detector_body_exited(body):
	if is_dead:
		return  # Игнорировать событие, если объект мертв
	chase = false
	velocity.x = 0
	state = IDLE

func idle_state():
	if is_dead:
		return  # Игнорировать idle_state, если объект мертв
	animPlayer.play("Idle")
	if chase:
		state = CHASE

func attack_state():
	if is_dead:
		return  # Игнорировать атаку, если объект мертв
	velocity.x = 0  # Останавливаем движение при атаке
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	state = IDLE  # Переход в состояние восстановления после атаки

func chase_state():
	if is_dead:
		return  # Игнорировать chase_state, если объект мертв
	state = RUN  # Устанавливаем состояние в RUN после определения направления

func run_state():
	if is_dead:
		return  # Игнорировать run_state, если объект мертв
	var direction = (player - self.position).normalized()
	if chase:
		velocity.x = direction.x * speed
		animPlayer.play("Run")
	else:
		velocity.x = 0
		state = IDLE

func recover_state():
	if is_dead:
		return  # Игнорировать recover_state, если объект мертв
	animPlayer.play("Recover")
	await animPlayer.animation_finished
	if chase:
		state = ATTACK  # Если враг продолжает преследовать, возвращаемся в CHASE
	else:
		state = ATTACK

func damage_state():
	if is_dead:
		return  # Игнорировать damage_state, если объект мертв
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	state = ATTACK

func death_state():
	if is_dead:
		return  # Если уже мертв, ничего не делаем
	is_dead = true  # Устанавливаем флаг, что объект мертв
	velocity.x = 0
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()  # Удаляем объект из сцены после завершения анимации смерти

func _on_hit_box_area_entered(area):
	if is_dead:
		return  # Игнорировать, если объект мертв
	Signals.emit_signal("enemy_attack", damage)

func _on_mobe_heals_no_health() -> void:
	state = DEATH

func _on_mobe_heals_damage_received() -> void:
	if is_dead:
		return  # Игнорировать повреждения, если объект мертв
	state = DAMAGE


func _on_default_body_entered(body: Node2D) -> void:
	if is_dead:
		return  # Игнорировать событие, если объект мертв
	state = ATTACK
