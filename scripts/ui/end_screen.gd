extends CanvasLayer
	
signal restart
signal go_to_menu

func _on_restart_pressed() -> void:
	restart.emit()


func _on_menu_pressed() -> void:
	go_to_menu.emit()
