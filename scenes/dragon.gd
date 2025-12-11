extends CharacterBody2D

@export var speed: float = 300.0
@export var fireball_scene: PackedScene
@export var animation: AnimatedSprite2D
var screen_size: Vector2
var _health: int = 7
signal damage_taken

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
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
	
	move_and_slide()

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
	
func _take_damage(dmg: int):
	_health -= dmg
	print("DENTRO DE LA FUNCION _take_damage")
	damage_taken.emit(_health)
	
	modulate = Color(18.892, 18.892, 18.892)
	await get_tree().create_timer(0.15).timeout
	modulate = Color.WHITE
	
	if _health <= 0:
		_death()

func _death():
	pass

func _on_hurtbox_area_entered(area: Area2D) -> void:
	print("DETECTA PERO NO ESTA EN EL GRUPO")
	if area.is_in_group("enemy_hitbox"):
		_take_damage(area.damage)
