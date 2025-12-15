extends CanvasLayer

@onready var _health_bar = $Control/AnimatedSprite2D
@onready var _wave_counter = $Control/Wave

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_health_bar.frame = 0
	_wave_counter.text = "1"
	
func update_health_bar(frame):
	_health_bar.frame = 7 - frame
	
func update_wave_counter(wave):
	_wave_counter.text = str(wave)
