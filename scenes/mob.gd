extends CharacterBody2D

@export var animation: AnimatedSprite2D
@export var collision: CollisionShape2D
@export var hearts: AnimatedSprite2D
@export var speed: int = 200
@export var hitbox: Area2D
var _health: int = 2
var _player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.play("idle")
	_player = get_tree().get_first_node_in_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if _player == null:
		return
	
	var direction = (_player.global_position - global_position).normalized()
	velocity = direction * speed
	if animation.animation == "death":
		velocity = Vector2.ZERO
	move_and_slide()

func take_damage(dmg: float):
	_health -= dmg
	if _health == 1:
		hearts.frame = 1
	if _health <= 0:
		hearts.frame = 2
		_death()
		return
	animation.play("damage")
	animation.animation_finished.connect(_ready)

func _death():
	animation.play("death")
	hitbox.remove_from_group("enemy_hitbox")
	self.collision_layer = 0
	self.collision_mask = 0

	animation.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	queue_free()
