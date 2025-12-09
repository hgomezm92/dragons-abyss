extends Area2D

@export var speed: float = 300.0
var direction: Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction * speed * delta
