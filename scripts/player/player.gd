extends CharacterBody2D

@export var fireball_scene: PackedScene
@onready var _animation = $AnimatedSprite2D
@onready var _collision = $CollisionShape2D

var _speed: float = 300.0
var _screen_size: Vector2
var _health: int = 7
var _is_knocked_back: bool = false

signal damage_taken
signal player_dead

func _ready() -> void:
	_screen_size = get_viewport_rect().size

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		_animation.flip_h = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		_animation.flip_h = true
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * _speed
		_animation.play()
	
	if !_is_knocked_back:
		move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_shoot_fireball()

func _shoot_fireball() -> void:
	var fireball = fireball_scene.instantiate()
	
	# Posicion inicial = centro del jugador
	fireball.position = global_position
	fireball.z_index = -1
	
	# Direccion = raton
	var mouse_position: Vector2 = get_global_mouse_position()
	var dir = (mouse_position - global_position).normalized()
	fireball.direction = dir
	
	# Rotacion de la bola
	fireball.rotation = dir.angle()
	
	# Añadir la bola a la escena
	get_tree().current_scene.add_child(fireball)
	
func _take_damage(dmg: int):
	_health -= dmg
	damage_taken.emit(_health)
	
	var tween = create_tween()
	tween.tween_property(
		self,
		"modulate",
		Color(18.892, 18.892, 18.892),
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		self,
		"modulate",
		Color.WHITE,
		0.15
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	if _health <= 0:
		_death()

func _death():
	player_dead.emit("Game Over")

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox"):
		_take_damage(area.damage)
		area.get_parent().attack_animation()
		_collision.set_deferred("disabled", true)
		_apply_knockback((global_position - area.global_position).normalized())
		

func _apply_knockback(direction: Vector2):
	if _is_knocked_back:
		return
	
	_is_knocked_back = true
	
	var tween = create_tween()
	tween.tween_property(
			self,
			"global_position",
			global_position + direction * 75,
			0.15
		).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(func():
		_is_knocked_back = false)

func start(pos):
	position = pos
	show()
