extends Control

@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_slider.value = volume_to_linear(AudioManager.get_bus_volume("Master"))
	music_slider.value = volume_to_linear(AudioManager.get_bus_volume("Music"))
	sfx_slider.value = volume_to_linear(AudioManager.get_bus_volume("SFX"))

func _on_master_slider_value_changed(value: float) -> void:
	var db = volume_to_db(value)
	AudioManager.set_bus_volume("Master", db)

func _on_music_slider_value_changed(value: float) -> void:
	var db = volume_to_db(value)
	AudioManager.set_bus_volume("Music", db)

func _on_sfx_slider_value_changed(value: float) -> void:
	var db = volume_to_db(value)
	AudioManager.set_bus_volume("SFX", db)

func volume_to_db(value: float) -> float:
	if value <= 0.001:
		return -80.0
	return linear_to_db(value)
	
func volume_to_linear(value: float) -> float:
	if value <= -80.0:
		return 0.0
	return db_to_linear(value)
