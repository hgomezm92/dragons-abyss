extends Node

@export var _game_manager: Node
@export var _start_position: Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_game_manager.new_game()
