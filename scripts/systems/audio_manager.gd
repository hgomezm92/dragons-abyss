extends Node

var music_player: AudioStreamPlayer
var music_tween: Tween

func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	music_player.process_mode = Node.PROCESS_MODE_ALWAYS
	
	add_child(music_player)
	
	_set_default_volumes()

func _set_default_volumes() -> void:
	set_bus_volume("Master", 0.0)
	set_bus_volume("Music", -30.0)
	set_bus_volume("SFX", -18.0)
	
func get_bus_volume(bus_name: String) -> float:
	var bus_index = AudioServer.get_bus_index(bus_name)
	var bus_volume: float = 0.0
	if bus_index != -1:
		bus_volume = AudioServer.get_bus_volume_db(bus_index)
	return bus_volume

func set_bus_volume(bus_name: String, volume_db: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, volume_db)

func play_music(stream: AudioStream) -> void:
	if music_player.stream == stream:
		return

	music_player.stop()
	music_player.stream = stream
	music_player.play()

func play_music_with_fade(stream: AudioStream, fade_time: float = 1.0) -> void:
	if music_player.stream == stream:
		return

	if music_tween:
		music_tween.kill()

	music_tween = create_tween()
	music_tween.tween_property(
		music_player,
		"volume_db",
		-80.0,
		fade_time
	)

	music_tween.tween_callback(func ():
		music_player.stop()
		music_player.stream = stream
		music_player.play()
		music_player.volume_db = -80.0
	)

	music_tween.tween_property(
		music_player,
		"volume_db",
		0.0,
		fade_time
	)

func stop_music() -> void:
	if music_player.playing:
		music_player.stop()

func play_sfx(stream: AudioStream) -> void:
	var sfx_player := AudioStreamPlayer.new()
	sfx_player.process_mode = Node.PROCESS_MODE_ALWAYS
	sfx_player.stream = stream
	sfx_player.bus = "SFX"
	add_child(sfx_player)

	sfx_player.play()

	sfx_player.finished.connect(func ():
		sfx_player.queue_free()
	)
