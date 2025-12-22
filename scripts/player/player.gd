extends CharacterBody2D

@export var fireball_scene: PackedScene
@export var shoot_position: Marker2D
@export var shoot_sfx: AudioStream
@export var hit_sfx: AudioStream
@export var game_over_sfx: AudioStream


@onready var _animation = $AnimatedSprite2D

var _speed: float = 600.0
var _screen_size: Vector2
var _health: int = 7
var _knockback_velocity: Vector2 = Vector2.ZERO
var _knockback_decay := 1200.0

signal damage_taken
signal player_dead

func _ready() -> void:
	_screen_size = get_viewport_rect().size
	_animation.play()

func _process(_delta: float) -> void:
	_face_mouse()

func _physics_process(_delta: float) -> void:
	var input_velocity = _get_input_direction() * _speed
		
	velocity = input_velocity + _knockback_velocity
	
	move_and_slide()
	
	_knockback_velocity = _knockback_velocity.move_toward(Vector2.ZERO, _knockback_decay * _delta)

func _get_input_direction() -> Vector2:
	var direction := Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		#_animation.flip_h = false
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		#_animation.flip_h = true
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	return direction.normalized()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		_shoot_fireball()

func _face_mouse():
	var mouse_pos: Vector2 = to_local(get_global_mouse_position())
	if mouse_pos.x < 0:
		scale.x = -1
	else:
		scale.x = 1
	
func _shoot_fireball() -> void:
	var fireball = fireball_scene.instantiate()
	
	# Posicion inicial = centro del jugador
	fireball.position = shoot_position.global_position
	fireball.z_index = 1
	
	# Direccion = raton
	var mouse_position: Vector2 = get_global_mouse_position()
	var dir = (mouse_position - shoot_position.global_position).normalized()
	fireball.direction = dir
	
	# Rotacion de la bola
	fireball.rotation = dir.angle()
	
	# Añadir la bola a la escena
	get_tree().current_scene.add_child(fireball)
	AudioManager.play_sfx(shoot_sfx)
	
func _take_damage(dmg: int):
	_health -= dmg
	damage_taken.emit(_health)
	AudioManager.play_sfx(hit_sfx)
	
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
	AudioManager.play_sfx(game_over_sfx)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hitbox"):
		_take_damage(area.damage)
		area.get_parent().attack_animation()
		_apply_knockback((global_position - area.global_position).normalized())

func _apply_knockback(direction: Vector2, force := 400.0):
	_knockback_velocity = direction * force

func start():
	_health = 7
