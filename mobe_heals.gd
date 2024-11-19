extends Node2D

signal  no_health()
signal damage_received()

@onready var health_bat = $HealthBar
@onready var damage_text = $DamageText
@onready var animPlayer = $AnimationPlayer

var health = 100:
	set (value):
		health = value 
		health_bat.value = health
		if health <= 0:
			health_bat.visible = false
		else :
			health_bat.visible = true
		
func _ready() -> void:
	Signals.connect("player_attack", Callable(self,"_on_damage_received"))
	damage_text.modulate.a = 0
	health_bat.max_value = health
	health_bat.visible = false

func _on_damage_received (player_damage):
	health -= player_damage
	damage_text.text = str(player_damage)
	animPlayer.stop()
	animPlayer.play("damage_text")
	#print (player_damage)
	if health <= 0 :
		emit_signal("no_health")
	else :
		emit_signal("damage_received")
