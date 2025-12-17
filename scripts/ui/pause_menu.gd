extends CanvasLayer

signal resume
signal restart
signal menu

func _on_resume_pressed() -> void:
	resume.emit()

func _on_restart_pressed() -> void:
	restart.emit()


func _on_menu_pressed() -> void:
	menu.emit()
