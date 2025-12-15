extends Node

@export var mob_scene: PackedScene
@onready var _hud = $HUD
@onready var _start_position = $StartPosition
@onready var _player = $Dragon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	_player.start(_start_position.position)
	
	_player.connect("damage_taken", _hud.update_health_bar)
	
	$MobTimer.start()

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set the mob's position to the random location
	mob.position = mob_spawn_location.position
	
	# Spawn the mob by adding it to the Main scene
	add_child(mob)
