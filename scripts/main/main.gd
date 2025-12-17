extends Node

@export var _game_manager: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_game_manager.new_game()
