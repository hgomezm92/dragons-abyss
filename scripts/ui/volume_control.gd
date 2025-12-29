extends Control

@export var master_slider: HSlider
@export var music_slider: HSlider
@export var sfx_slider: HSlider

const _MUTE_MAX_DB: float = -80.0
const _MASTER_MAX_DB: float = 0.0
const _MUSIC_MAX_DB: float = -30.0
const _SFX_MAX_DB: float = -6.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_slider.value = volume_to_linear(AudioManager.get_bus_volume("Master"), _MASTER_MAX_DB)
	music_slider.value = volume_to_linear(AudioManager.get_bus_volume("Music"), _MUSIC_MAX_DB)
	sfx_slider.value = volume_to_linear(AudioManager.get_bus_volume("SFX"), _SFX_MAX_DB)

func _on_master_slider_value_changed(value: float) -> void:
	var db = volume_to_db(value, _MASTER_MAX_DB)
	AudioManager.set_bus_volume("Master", db)

func _on_music_slider_value_changed(value: float) -> void:
	var db = volume_to_db(value, _MUSIC_MAX_DB)
	AudioManager.set_bus_volume("Music", db)

func _on_sfx_slider_value_changed(value: float) -> void:
	var db = volume_to_db(value, _SFX_MAX_DB)
	AudioManager.set_bus_volume("SFX", db)

func volume_to_db(value: float, max_db: float) -> float:
	if value <= 0.001:
		return _MUTE_MAX_DB
	return linear_to_db(value) + max_db
	
func volume_to_linear(value: float, max_db: float) -> float:
	if value <= _MUTE_MAX_DB:
		return 0.0
	return db_to_linear(value - max_db)
