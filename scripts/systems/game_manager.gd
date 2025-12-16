extends Node

@export var _hud: CanvasLayer
@export var _player: CharacterBody2D
@export var _enemy_spawner: Node
var _end_scene: PackedScene = preload("res://scenes/ui/end_screen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player.connect("damage_taken", _hud.update_health_bar)
	_player.connect("player_dead", _end)
	_enemy_spawner.connect("wave_finished", _hud.update_wave_counter)
	_enemy_spawner.connect("win", _end)

func new_game(start_position) -> void:
	_enemy_spawner.reset()
	_player.start(start_position.position)
	_enemy_spawner.start_wave()

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
