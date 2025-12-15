extends Node

@export var enemy_scene: PackedScene
@onready var _enemy_timer = $EnemySpawnTimer
@onready var _wave_timer = $WaveTimer
var _wave_count: int = 1
var _spawn_interval: float = 2.0
var _wave_time: float = 10.0

signal wave_finished

func start() -> void:
	_enemy_timer.wait_time = _spawn_interval
	_wave_timer.wait_time = _wave_time 
	_enemy_timer.start()
	_wave_timer.start()
	print(_wave_count)
	
func _on_wave_timer_timeout() -> void:
	if _wave_count <= 5:
		_wave_count += 1
		wave_finished.emit(_wave_count)
		_spawn_interval -= 0.5
		_enemy_timer.stop()
		start()

func _on_enemy_spawn_timer_timeout() -> void:
		_spawn_enemy()

func _spawn_enemy():
	# Create a new instance of the Enemy scene
	var enemy = enemy_scene.instantiate()

	# Choose a random location on Path2D
	var enemy_spawn_location = $EnemyPath/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()

	# Set the enemy's position to the random location
	enemy.position = enemy_spawn_location.position

	# Spawn the enemy by adding it to the Main scene
	get_tree().root.add_child(enemy)
