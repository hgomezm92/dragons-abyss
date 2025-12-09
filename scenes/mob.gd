extends RigidBody2D

@export var animation: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
