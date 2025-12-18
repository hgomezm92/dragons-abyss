extends Node

@export var hud: CanvasLayer
@export var player: CharacterBody2D
@export var enemy_spawner: Node
@export var pause_menu: CanvasLayer
@export var wave_message: CanvasLayer
var _end_scene: PackedScene = preload("res://scenes/ui/end_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("damage_taken", hud.update_health_bar)
	player.connect("player_dead", _end)
	
	enemy_spawner.connect("wave_finished", _change_wave)
	enemy_spawner.connect("win", _end)
	enemy_spawner.connect("enemy_count_changed", hud.update_enemies_left)
	
	pause_menu.connect("resume", _toggle_pause)
	pause_menu.connect("restart", _restart)
	pause_menu.connect("menu", _go_to_menu)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu"):
		_toggle_pause()

func _toggle_pause():
	if get_tree().paused:
		_resume_game()
	else:
		_pause_game()

func _resume_game():
	get_tree().paused = false
	pause_menu.hide()
	
func _pause_game():
	get_tree().paused = true
	pause_menu.show()

func new_game() -> void:
	enemy_spawner.reset()
	player.start()
	enemy_spawner.start_wave()

func _end(text: String):
	get_tree().paused = true
	var end_screen = _end_scene.instantiate()
	end_screen.find_child("Label").text = text
	get_parent().add_child(end_screen)
	end_screen.connect("restart", _restart)
	end_screen.connect("go_to_menu", _go_to_menu)
	
func _restart():
	get_tree().paused = false
	get_tree().call_group("enemy", "queue_free")
	get_tree().reload_current_scene()
	
func _go_to_menu():
	get_tree().call_group("enemy", "queue_free")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
	
func _change_wave(wave):
	hud.update_wave_counter(wave)
	wave_message.show()
	create_tween().tween_property(
		wave_message.get_child(0),
		"modulate:a",
		1.0,
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(1.0).timeout
	create_tween().tween_property(
		wave_message.get_child(0),
		"modulate:a",
		0.0,
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(1.0).timeout
	wave_message.hide()
	
