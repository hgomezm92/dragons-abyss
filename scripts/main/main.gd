extends Node

@onready var _hud = $HUD
@onready var _start_position = $StartPosition
@onready var _player = $Dragon
@onready var _enemy_spawner = $EnemySpawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player.start(_start_position.position)
	
	_player.connect("damage_taken", _hud.update_health_bar)
	_enemy_spawner.connect("wave_finished", _hud.update_wave_counter)
	
	_enemy_spawner.start()
