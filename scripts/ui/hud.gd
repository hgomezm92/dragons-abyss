extends CanvasLayer

@onready var _health_bar = $Control/AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_health_bar.frame = 0
	
func update_health_bar(frame):
	_health_bar.frame = 7 - frame
