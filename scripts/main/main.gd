extends Node

@export var game_manager: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager.new_game()
