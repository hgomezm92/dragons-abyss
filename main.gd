extends Node

@export var mob_scene: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mob = mob_scene.instantiate()
	mob.position = Vector2(640, 360)
	add_child(mob)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
