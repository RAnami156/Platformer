extends Node2D

@onready var light = $DirectionalLight2D
@onready var pointlight = $PointLight2D
@onready var day_text  = $CanvasLayer/Day
@onready var animPlayer = $CanvasLayer/AnimationPlayer
@onready var hp_bar = $CanvasLayer/HpBar
@onready var player = $Player/Player

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var state = MORNING
var day_count: int

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close"):
		get_tree().change_scene_to_file("res://menu.tscn")
		
func _ready():
	hp_bar.max_value = player.max_health
	hp_bar.value = hp_bar.max_value 
	light.enabled = true
	day_count = 1
	set_day_text()

func morning_state() :
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.2, 20)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointlight, "energy", 0, 20)
func evening_state() :
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.95, 20)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointlight, "energy", 1.5, 20)


func _on_dey_night_timeout():
	match state :
		MORNING :
			morning_state()
		EVENING :
			evening_state()
	if state < 3 :
		state += 1
	else :
		state = MORNING
		day_count += 1
		set_day_text()
		animPlayer.play("day_text_fade_in")
		await  get_tree().create_timer(20).timeout
		animPlayer.play("day_text_fade")
		
func set_day_text() :
	day_text.text = "DAY" + str(day_count)

	


func _on_player_health_changet(new_health):
	hp_bar.value = new_health


func _on_player_health_changed(new_health: Variant) -> void:
	hp_bar.value = new_health
	


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")
