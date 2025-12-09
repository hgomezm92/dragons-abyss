extends Area2D

@export var animation: AnimatedSprite2D
@export var speed: float = 250.0
var direction: Vector2 = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction * speed * delta
		animation.play("default")
	else:
		animation.stop()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	hide()
