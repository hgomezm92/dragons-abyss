extends CanvasLayer

@export var health_bar: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_health_bar(frame):
	health_bar.frame = 7 - frame
