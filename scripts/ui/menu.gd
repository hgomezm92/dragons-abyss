extends CanvasLayer

var main: PackedScene = preload("res://scenes/main/main.tscn")
var credits: PackedScene = preload("res://scenes/ui/credits.tscn")

@export var music_menu: AudioStream
@export var game_music: AudioStream
@export var credits_music: AudioStream

func _ready() -> void:
	get_child(1).modulate.a = 0.0
	create_tween().tween_property(
		get_child(1),
		"modulate:a",
		1.0,
		1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	AudioManager.play_music(music_menu)

func _on_start_pressed() -> void:
	create_tween().tween_property(
		get_child(1),
		"modulate:a",
		0.0,
		1
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	AudioManager.play_music_with_fade(game_music)
	
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
	
	AudioManager.play_music(credits_music)
	
	await get_tree().create_timer(0.75).timeout
	get_tree().change_scene_to_packed(credits)
