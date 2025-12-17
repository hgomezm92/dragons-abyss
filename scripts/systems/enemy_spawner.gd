extends Node

@export var enemy_scene: PackedScene
@onready var _enemy_timer = $EnemySpawnTimer
@onready var _spawn_points: Array[Node] = $SpawnPoints.get_children()
var _wave_count: int = 1
var _spawn_interval: float = 2.0
var _enemies_alive: int = 0
var _enemies_to_spawn: int = 0
var _is_spawning_finished: bool = false

signal wave_finished
signal win

func _get_enemy_count_for_wave(wave):
	return 5 + wave * 2

func start_wave() -> void:
	_enemies_to_spawn = _get_enemy_count_for_wave(_wave_count)
	_enemies_alive = 0
	_is_spawning_finished = false
	
	_enemy_timer.wait_time = _spawn_interval
	_enemy_timer.start()
	
func _spawn_enemy():
	if _enemies_to_spawn <= 0:
		_enemy_timer.stop()
		_is_spawning_finished = true
		_check_wave_end()
		return
	# Create a new instance of the Enemy scene
	var enemy = enemy_scene.instantiate()

	# Choose a random location on Path2D
	var enemy_spawn_location = _spawn_points.pick_random()

	# Set the enemy's position to the random location
	enemy.global_position = enemy_spawn_location.global_position
	enemy.modulate.a = 0.0

	enemy.enemy_died.connect(_on_enemy_died)
	# Spawn the enemy by adding it to the Main scene
	get_parent().add_child(enemy)
	
	create_tween().tween_property(
		enemy,
		"modulate:a",
		1.0,
		0.5
	)
	
	_enemies_to_spawn -= 1
	_enemies_alive += 1

func _on_enemy_died():
	_enemies_alive -= 1
	_check_wave_end()

func _check_wave_end():
	if _is_spawning_finished and _enemies_alive <= 0:
		_end_wave()

func _end_wave():
	if _wave_count >= 5:
		win.emit("YOU WIN")
		return
	
	_wave_count += 1
	_spawn_interval = max(0.5, _spawn_interval - 0.3)
	wave_finished.emit(_wave_count)
	
	await get_tree().create_timer(2.0).timeout
	start_wave()

func _on_enemy_spawn_timer_timeout() -> void:
		_spawn_enemy()
		
func reset():
	_wave_count = 1
	_spawn_interval = 2.0
	_enemy_timer.stop()
