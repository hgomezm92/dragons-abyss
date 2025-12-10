extends CharacterBody2D

@export var animation: AnimatedSprite2D
@export var collision: CollisionShape2D
@export var hearts: AnimatedSprite2D
var _health: float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !animation.is_playing():
		queue_free()

func take_damage(dmg: float):
	_health -= dmg
	if _health == 1.0:
		hearts.frame = 1
	if _health <= 0.0:
		hearts.frame = 2
		death()
		return
	animation.play("damage")
	animation.animation_finished.connect(_ready)

func death():
	animation.play("death")
	collision.disabled = true
	animation.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	queue_free()
