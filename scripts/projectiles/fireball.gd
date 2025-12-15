extends Area2D

@onready var animation = $AnimatedSprite2D
var _speed: float = 250.0
var direction: Vector2 = Vector2.ZERO
var _is_exploding: bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction != Vector2.ZERO and not _is_exploding:
		position += direction * _speed * delta
		animation.play("move")
	
	if animation.is_playing() == false:
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	_explode()

func _explode():
	_is_exploding = true
	animation.play("explode")

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
	_explode()
