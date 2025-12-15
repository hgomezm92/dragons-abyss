extends CanvasLayer
	
func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().call_group("enemy", "queue_free")
	get_tree().reload_current_scene()
	set_deferred("visible", false)
	queue_free()
