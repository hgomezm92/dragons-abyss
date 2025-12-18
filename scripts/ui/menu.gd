extends CanvasLayer

var main: PackedScene = preload("res://scenes/main/main.tscn")
var credits: PackedScene = preload("res://scenes/ui/credits.tscn")

func _ready() -> void:
	get_child(1).modulate.a = 0.0
	create_tween().tween_property(
		get_child(1),
		"modulate:a",
		1.0,
		1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_start_pressed() -> void:
	create_tween().tween_property(
		get_child(1),
		"modulate:a",
		0.0,
		1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.75).timeout
	get_tree().change_scene_to_packed(main)

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	create_tween().tween_property(
		get_child(1),
		"modulate:a",
		0.0,
		1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.75).timeout
	get_tree().change_scene_to_packed(credits)
