extends CharacterBody2D

@export var speed: float = 300.0
@export var fireball_scene: PackedScene
@export var animation: AnimatedSprite2D
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	var velocity: Vector2 =  Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		animation.flip_h = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		animation.flip_h = true
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		animation.play()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot_fireball()

func shoot_fireball() -> void:
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
	
