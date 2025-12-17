extends CanvasLayer

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
var _parent: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	_parent = get_parent().name
	
	if _parent == "Main" and !get_tree().paused:
		_sprite.play("sight_idle")
	else:
		_sprite.play("hand_idle")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Seguir al ratón
	_sprite.global_position = get_viewport().get_mouse_position()

func _input(event):
	if _parent == "Main" and !get_tree().paused:
		if event.is_action_pressed("shoot"):
			_sprite.play("sight_pressed")
		else:
			_sprite.play("sight_idle")
	else:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_sprite.play("hand_pressed")
		else:
			_sprite.play("hand_idle")
