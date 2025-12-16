extends CanvasLayer


@export var _main: PackedScene

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(_main)


func _on_quit_pressed() -> void:
	get_tree().quit()
