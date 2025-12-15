extends Node

@onready var _hud: CanvasLayer = get_parent().find_child("HUD")  
@onready var _player: CharacterBody2D = get_parent().find_child("Player") 
@onready var _enemy_spawner: Node = get_parent().find_child("EnemySpawner") 
var game_over_scene: PackedScene = preload("res://scenes/ui/game_over.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player.connect("damage_taken", _hud.update_health_bar)
	_player.connect("player_dead", _game_over)
	_enemy_spawner.connect("wave_finished", _hud.update_wave_counter)

func new_game(start_position) -> void:
	_player.start(start_position.position)
	_enemy_spawner.start_wave()

func _game_over():
	get_tree().paused = true
	var game_over_screen = game_over_scene.instantiate()
	get_parent().add_child(game_over_screen)
	game_over_screen.connect("restart", _restart)
	
func _restart():
	get_tree().paused = false
	get_tree().call_group("enemy", "queue_free")
	get_tree().reload_current_scene()
